import 'dart:collection';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/src/internal.dart';

/// Paints a [GaugeZoneLabel] inside [zone], clipped to [zonePath].
void paintGaugeZoneLabel({
  required Canvas canvas,
  required Path zonePath,
  required Offset center,
  required double centerlineRadius,
  required double thickness,
  required double axisMin,
  required double axisMax,
  required double sweepDegrees,
  required GaugeZone zone,
  required GaugeZoneLabel label,
}) {
  final range = axisMax - axisMin;
  if (range <= 0 || centerlineRadius <= 0) return;

  // Arc spans [-180 - shift, 0 + shift]; gauge top sits at -90°.
  final angleShift = (sweepDegrees - 180) / 2;
  final fromTheta = toRadians(_interpolate(
    -180.0 - angleShift,
    0.0 + angleShift,
    ((zone.from - axisMin) / range).clamp(0.0, 1.0),
  ));
  final toTheta = toRadians(_interpolate(
    -180.0 - angleShift,
    0.0 + angleShift,
    ((zone.to - axisMin) / range).clamp(0.0, 1.0),
  ));

  final glyphs = _buildGlyphs(label);
  if (glyphs.isEmpty) return;

  final paddingTheta = label.padding / centerlineRadius;
  final radialOffset =
      label.radialAlignment.clamp(-1.0, 1.0) * thickness / 2;
  final glyphRadius = centerlineRadius + radialOffset;

  final advances = glyphs.map((g) => g.width / centerlineRadius).toList();
  final totalSpan = advances.fold<double>(0, (a, b) => a + b);

  final double startTheta;
  switch (label.alignment) {
    case GaugeZoneLabelAlignment.start:
      startTheta = fromTheta + paddingTheta;
      break;
    case GaugeZoneLabelAlignment.end:
      startTheta = toTheta - paddingTheta - totalSpan;
      break;
    case GaugeZoneLabelAlignment.center:
      startTheta = (fromTheta + toTheta) / 2 - totalSpan / 2;
      break;
  }

  canvas.save();
  canvas.clipPath(zonePath);

  var theta = startTheta;
  for (var i = 0; i < glyphs.length; i++) {
    final glyph = glyphs[i];
    final advance = advances[i];
    // Anchor each glyph at its angular center so it stays balanced about
    // its own tangent line.
    final glyphCenterTheta = theta + advance / 2;
    final point = getPointOnCircle(center, glyphCenterTheta, glyphRadius);
    // Tangent direction at angle θ on a canvas circle is θ + π/2.
    final tangent = glyphCenterTheta + math.pi / 2;

    canvas.save();
    canvas.translate(point.dx, point.dy);
    canvas.rotate(tangent);
    glyph.painter.paint(
      canvas,
      Offset(-glyph.width / 2, -glyph.painter.height / 2),
    );
    canvas.restore();

    theta += advance;
  }

  canvas.restore();
}

double _interpolate(double a, double b, double t) => a + (b - a) * t;

class _Glyph {
  final TextPainter painter;
  final double width;
  const _Glyph(this.painter, this.width);
}

// Per-label glyph layout cache. LRU-evicted so dynamic labels don't grow it
// without bound.
const int _glyphCacheCapacity = 64;
final LinkedHashMap<GaugeZoneLabel, List<_Glyph>> _glyphCache =
    LinkedHashMap<GaugeZoneLabel, List<_Glyph>>();

List<_Glyph> _buildGlyphs(GaugeZoneLabel label) {
  final cached = _glyphCache.remove(label);
  if (cached != null) {
    _glyphCache[label] = cached; // re-insert as most-recently-used
    return cached;
  }
  final glyphs = _layoutGlyphs(label);
  _glyphCache[label] = glyphs;
  if (_glyphCache.length > _glyphCacheCapacity) {
    _glyphCache.remove(_glyphCache.keys.first);
  }
  return glyphs;
}

List<_Glyph> _layoutGlyphs(GaugeZoneLabel label) {
  final glyphs = <_Glyph>[];
  final fontSize = label.style?.fontSize ?? 14.0;

  final icon = label.icon;
  if (icon != null) {
    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          fontSize: fontSize,
          color: label.style?.color,
          height: 1.0,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
      maxLines: 1,
    )..layout();
    glyphs.add(_Glyph(iconPainter, iconPainter.width));
  }

  final text = label.text;
  if (text != null && text.isNotEmpty) {
    if (icon != null) {
      // Transparent spacer that only consumes arc length.
      glyphs.add(_Glyph(_emptyPainter, label.iconGap));
    }
    final runes = text.runes.toList();
    for (final rune in runes) {
      final ch = String.fromCharCode(rune);
      final painter = TextPainter(
        text: TextSpan(text: ch, style: label.style),
        textDirection: ui.TextDirection.ltr,
        maxLines: 1,
      )..layout();
      glyphs.add(_Glyph(painter, painter.width));
    }
  }

  return glyphs;
}

final TextPainter _emptyPainter = TextPainter(
  text: const TextSpan(text: ''),
  textDirection: ui.TextDirection.ltr,
)..layout();
