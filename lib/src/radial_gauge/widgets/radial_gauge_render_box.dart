import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

import '../internal/radial_gauge_axis_definition.dart';
import '../internal/radial_gauge_size_ratios.dart';

/// To optimize the gauge indicator widget calculations are split
/// into two phases: size-related and paint-related.
/// Layout-related can be made only on layout change and there is no need
/// to redo them on each paint.
/// Paint-related are calculations that are required to paint the gauge,
/// For it to work the offset (provided to the paint method) needs to be
/// provided.

class RadialGaugeRenderBox extends RenderShiftedBox {
  /// Current value of the radial gauge
  double _value;

  double get value => _value;

  set value(double value) {
    if (_value != value) {
      _value = value;
      _axisDefinition.markNeedsRecalculation();
      markNeedsPaint();
    }
  }

  /// Only a single axis is supported
  GaugeAxis get axis => _axis;
  GaugeAxis _axis;

  set axis(GaugeAxis axis) {
    if (_axis != axis) {
      if (_axis.degrees != axis.degrees ||
          _axis.style.thickness != axis.style.thickness) {
        markNeedsLayout();
      } else {
        _axisDefinition.markNeedsRecalculation();
        markNeedsPaint();
      }
      _axis = axis;
    }
  }

  Alignment _alignment;

  Alignment get alignment => _alignment;

  set alignment(Alignment alignment) {
    if (_alignment != alignment) {
      _alignment = alignment;
      markNeedsLayout();
    }
  }

  double? _radius;

  double? get radius => _radius;

  set radius(double? radius) {
    if (_radius != radius) {
      _radius = radius;
      markNeedsLayout();
    }
  }

  bool _debug;

  bool get debug => _debug;

  set debug(bool debug) {
    if (_debug != debug) {
      _debug = debug;
      markNeedsPaint();
    }
  }

  late RadialGaugeLayout _computedLayout;
  late RadialGaugeAxisDefinition _axisDefinition;

  /// Creates a RenderBox that displays a radial gauge.
  RadialGaugeRenderBox({
    required final double value,
    required final GaugeAxis axis,
    required final Alignment alignment,
    required final bool debug,
    required final double? radius,
    RenderBox? child,
  })  : _value = value,
        _axis = axis,
        _alignment = alignment,
        _radius = radius,
        _debug = debug,
        super(child);

  @override
  bool get sizedByParent => false;

  double get _valueProgress => (value - axis.min) / (axis.max - axis.min);

  double get _from => (axis.zero - axis.min) / (axis.max - axis.min);

  @override
  void performLayout() {
    final ratios = RadialGaugeSizeRatios.fromDegrees(axis.degrees);

    _computedLayout = RadialGaugeLayout.calculate(
      constraints,
      ratios,
      alignment: alignment,
      preferredRadius: radius,
    );
    size = _computedLayout.sourceRect.size;

    _axisDefinition =
        RadialGaugeAxisDefinition.calculate(_computedLayout, axis);

    if (child != null) {
      final innerCircleRadius =
          (_computedLayout.radius - axis.style.thickness) / 2 * math.sqrt2;
      final circleRect = Rect.fromCircle(
        center: _computedLayout.circleRect.center,
        radius: innerCircleRadius,
      );
      final childRect = circleRect.intersect(_computedLayout.targetRect);

      child!.layout(BoxConstraints.tight(childRect.size));

      final childParentData = child!.parentData! as BoxParentData;
      childParentData.offset = Offset(
        childRect.left - _computedLayout.sourceRect.left,
        childRect.top - _computedLayout.sourceRect.top,
      );
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    /// Paint a child
    super.paint(context, offset);

    /// No space, nothing to paint.
    if (size.isEmpty) return;

    if (_axisDefinition.needsRecalculation) {
      _axisDefinition = RadialGaugeAxisDefinition.calculate(
        _computedLayout,
        axis,
      );
    }

    final canvas = context.canvas;
    final layout = _computedLayout.shift(offset);
    final axisDefinition = _axisDefinition.shift(offset);

    assert(() {
      if (debug) {
        canvas.drawRect(
          layout.sourceRect,
          Paint()..color = Colors.blue.withOpacity(0.1),
        );
        canvas.drawRect(
          layout.targetRect,
          Paint()..color = Colors.red.withOpacity(0.1),
        );
        canvas.drawRect(
          layout.circleRect,
          Paint()..color = Colors.green.withOpacity(0.1),
        );
      }
      return true;
    }(), 'Debug view');

    canvas.save();

    if (axis.style.background != null) {
      final paint = Paint()
        ..color = axis.style.background!
        ..style = PaintingStyle.fill;
      canvas.drawPath(axisDefinition.surface, paint);
    }

    final progressBar = axis.progressBar;

    final hasProgressBarInside = progressBar != null &&
        progressBar.placement == GaugeProgressPlacement.inside;

    if (hasProgressBarInside) {
      final segmentsPath = Path();

      for (int i = 0; i < axisDefinition.segments.length; i++) {
        final segment = axisDefinition.segments[i];
        segmentsPath.addPath(segment.path, offset);
      }
      canvas.clipPath(segmentsPath);
    }

    // drawing segments

    for (var i = 0; i < axisDefinition.segments.length; i++) {
      final segment = axisDefinition.segments[i];
      final paint = Paint()..style = PaintingStyle.fill;

      if (segment.shader != null) {
        paint.shader = segment.shader!;
      } else if (segment.gradient != null) {
        final gradient = segment.gradient!;
        paint.shader = ui.Gradient.sweep(
          layout.circleRect.center,
          gradient.colors,
          gradient.colorStops,
          gradient.tileMode,
          0.0,
          segment.sweepAngle,
          GradientRotation(segment.startAngle)
              .transform(layout.circleRect)
              .storage,
        );
      } else if (segment.color != null) {
        paint.color = segment.color!;
      }

      canvas.drawPath(segment.path, paint);
    }

    // drawing progress

    if (progressBar != null &&
        progressBar.placement == GaugeProgressPlacement.inside) {
      progressBar.paint(axis, layout, canvas, _from, _valueProgress);
    }

    for (var i = 0; i < axisDefinition.segments.length; i++) {
      final segment = axisDefinition.segments[i];
      final border = segment.border;
      if (border == null) continue;

      final borderPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = border.width
        ..color = border.color;
      canvas.drawPath(segment.path, borderPaint);
    }

    if (progressBar != null &&
        progressBar.placement == GaugeProgressPlacement.over) {
      progressBar.paint(axis, layout, canvas, _from, _valueProgress);
    }

    canvas.restore();

    /// Draw a pointer

    final pointer = axis.pointer;
    if (pointer != null) {
      drawPointer(canvas, axisDefinition, pointer);
    }
  }

  void drawPointer(
    Canvas canvas,
    RadialGaugeAxisDefinition axisDefinition,
    GaugePointer pointer,
  ) {
    final degrees = axis.degrees;
    final center = axisDefinition.center;
    final offset = pointer.position.offset;
    final size = pointer.size;

    final double originDY;
    switch (pointer.position.anchor) {
      case GaugePointerAnchor.center:
        originDY = size.height - offset.dy;
        break;
      case GaugePointerAnchor.surface:
        originDY = axisDefinition.radius + size.height / 2 - offset.dy;
        break;
    }

    final origin = Offset(
      size.width / 2 - offset.dx,
      originDY,
    );

    final rotation = _valueProgress * degrees - degrees / 2;
    final transformation = rotateOverOrigin(
      matrix: Matrix4.translationValues(
        center.dx - size.width / 2 + offset.dx,
        center.dy - originDY,
        0.0,
      ),
      origin: origin,
      rotation: toRadians(rotation),
    );

    final path = pointer.path.transform(transformation.storage);

    final fillPaint = Paint();

    if (pointer.shadow != null) {
      canvas.drawPath(path, pointer.shadow!.toPaint());
    }

    if (pointer.color != null) {
      fillPaint.color = pointer.color!;
    }

    if (pointer.gradient != null) {
      fillPaint.shader = pointer.gradient!.createShader(path.getBounds());
    }

    fillPaint.style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);

    final border = pointer.border;
    if (border != null && border.width > 0) {
      final strokePaint = Paint()
        ..strokeWidth = math.max(border.width, 0)
        ..color = border.color
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, strokePaint);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('value', value));
    properties.add(DiagnosticsProperty<GaugeAxis>('axis', axis));
    properties.add(DiagnosticsProperty<bool>('debug', debug));
    properties.add(DoubleProperty('radius', radius));
  }
}
