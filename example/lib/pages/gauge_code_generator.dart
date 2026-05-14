import 'dart:ui' show Color;

import 'gauge_data_controller.dart';

/// Generates a Dart source snippet that reproduces the gauge currently
/// described by [c]. The output is a widget-tree expression suitable for
/// pasting inside another widget's `build` method.
String generateGaugeCode(GaugeDataController c) {
  final b = _CodeBuilder();

  b.line('SizedBox(');
  b.indent(() {
    b.line('width: ${_d(c.parentWidth)},');
    b.line('height: ${_d(c.parentHeight)},');
    b.line('child: AnimatedRadialGauge(');
    b.indent(() {
      b.line('radius: ${_d(c.gaugeRadius)},');
      b.line('duration: Duration(milliseconds: ${c.duration.inMilliseconds}),');
      b.line('curve: Curves.${c.curveName},');
      b.line('value: ${_d(c.value)},');

      final showLabel =
          !(c.hasPointer && c.pointerType == PointerType.needle);
      if (showLabel) {
        b.line('builder: (context, _, value) => RadialGaugeLabel(');
        b.indent(() {
          b.line('style: TextStyle(');
          b.indent(() {
            b.line('color: Color(0xFF002E5F),');
            b.line('fontSize: ${_d(c.fontSize)},');
            b.line('fontWeight: FontWeight.bold,');
          });
          b.line('),');
          b.line('value: value,');
        });
        b.line('),');
      }

      b.line('axis: GaugeAxis(');
      b.indent(() {
        b.line('min: 0,');
        b.line('max: 100,');
        b.line('degrees: ${_d(c.degree)},');

        if (c.hasPointer) {
          _writePointer(b, c);
        }
        if (c.hasProgressBar) {
          _writeProgressBar(b, c);
        }

        b.line('transformer: GaugeAxisTransformer.colorFadeIn(');
        b.indent(() {
          b.line('interval: Interval(0.0, 0.3),');
          b.line('background: Color(0xFFD9DEEB),');
        });
        b.line('),');

        b.line('style: GaugeAxisStyle(');
        b.indent(() {
          b.line('thickness: ${_d(c.thickness)},');
          if (c.hasSurface) {
            b.line('background: ${_color(c.surfaceColor)},');
          }
          b.line('segmentSpacing: ${_d(c.spacing)},');
          b.line('blendColors: false,');
          b.line('cornerRadius: Radius.circular(${_d(c.surfaceRadius)}),');
        });
        b.line('),');

        _writeSegments(b, c);
      });
      b.line('),');
    });
    b.line('),');
  });
  b.line(')');

  return b.toString();
}

void _writePointer(_CodeBuilder b, GaugeDataController c) {
  final size = c.pointerSize;
  final color = _color(c.pointerColor);
  switch (c.pointerType) {
    case PointerType.needle:
      b.line('pointer: GaugePointer.needle(');
      b.indent(() {
        b.line('width: ${_d(size * 0.625)},');
        b.line('height: ${_d(size * 4)},');
        b.line('color: $color,');
        b.line('position: GaugePointerPosition.center(');
        b.indent(() {
          b.line('offset: Offset(0, ${_d(size * 0.3125)}),');
        });
        b.line('),');
      });
      b.line('),');
    case PointerType.triangle:
      b.line('pointer: GaugePointer.triangle(');
      b.indent(() {
        b.line('width: ${_d(size)},');
        b.line('height: ${_d(size)},');
        b.line('borderRadius: ${_d(size * 0.125)},');
        b.line('color: $color,');
        b.line('position: GaugePointerPosition.surface(');
        b.indent(() {
          b.line('offset: Offset(0, ${_d(c.thickness * 0.6)}),');
        });
        b.line('),');
        b.line('border: GaugePointerBorder(');
        b.indent(() {
          b.line('color: Colors.white,');
          b.line('width: ${_d(size * 0.125)},');
        });
        b.line('),');
      });
      b.line('),');
    case PointerType.circle:
      b.line('pointer: GaugePointer.circle(');
      b.indent(() {
        b.line('radius: ${_d(size * 0.5)},');
        b.line('color: $color,');
        b.line('border: GaugePointerBorder(');
        b.indent(() {
          b.line('color: Colors.white,');
          b.line('width: ${_d(size * 0.125)},');
        });
        b.line('),');
      });
      b.line('),');
  }
}

void _writeProgressBar(_CodeBuilder b, GaugeDataController c) {
  final ctor = c.progressBarType == ProgressBarType.rounded
      ? 'GaugeProgressBar.rounded'
      : 'GaugeProgressBar.basic';
  b.line('progressBar: $ctor(');
  b.indent(() {
    b.line('color: ${_color(c.progressBarColor)},');
    b.line('placement: GaugeProgressPlacement.${c.progressBarPlacement.name},');
  });
  b.line('),');
}

void _writeSegments(_CodeBuilder b, GaugeDataController c) {
  if (c.segments.isEmpty) {
    b.line('segments: [],');
    return;
  }
  b.line('segments: [');
  b.indent(() {
    for (final s in c.segments) {
      b.line('GaugeSegment(');
      b.indent(() {
        b.line('from: ${_d(s.from)},');
        b.line('to: ${_d(s.to)},');
        b.line('color: ${_color(s.color)},');
        b.line('cornerRadius: Radius.circular(${_d(c.segmentsRadius)}),');
      });
      b.line('),');
    }
  });
  b.line('],');
}

/// Formats a double so it always reads as a Dart double literal.
String _d(double v) {
  if (v.isNaN || v.isInfinite) return v.toString();
  if (v == v.roundToDouble()) return '${v.toInt()}.0';
  return v.toString();
}

String _color(Color c) {
  final hex =
      c.toARGB32().toRadixString(16).toUpperCase().padLeft(8, '0');
  return 'Color(0x$hex)';
}

class _CodeBuilder {
  final StringBuffer _buf = StringBuffer();
  int _depth = 0;

  static const _indentUnit = '    ';

  void line(String text) {
    _buf
      ..write(_indentUnit * _depth)
      ..writeln(text);
  }

  void indent(void Function() body) {
    _depth++;
    body();
    _depth--;
  }

  @override
  String toString() => _buf.toString().trimRight();
}
