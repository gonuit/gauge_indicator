import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class GaugeSegmentDefinition {
  final double startAngle;
  final double sweepAngle;
  final Color? color;
  final GaugeAxisGradient? gradient;
  final GaugeBorder? border;
  final Shader? shader;
  final Path path;

  GaugeSegmentDefinition({
    required this.startAngle,
    required this.sweepAngle,
    required this.path,
    required this.color,
    required this.gradient,
    required this.border,
    required this.shader,
  });

  GaugeSegmentDefinition shift(Offset offset) => GaugeSegmentDefinition(
        startAngle: startAngle,
        sweepAngle: sweepAngle,
        path: path.shift(offset),
        color: color,
        gradient: gradient,
        border: border,
        shader: shader,
      );
}

class RadialGaugeAxisDefinition {
  /// Describes a circle placed in the axis center.
  final Rect rect;
  final Path surface;
  final double thickness;
  final List<GaugeSegmentDefinition> segments;

  Offset get center => rect.center;
  double get radius => rect.width / 2;

  bool _needsReposition = false;
  bool get needsRecalculation => _needsReposition;
  void markNeedsRecalculation() {
    _needsReposition = true;
  }

  RadialGaugeAxisDefinition({
    required this.surface,
    required this.rect,
    required this.segments,
    required this.thickness,
  });

  RadialGaugeAxisDefinition shift(Offset offset) => RadialGaugeAxisDefinition(
        surface: surface.shift(offset),
        rect: rect.shift(offset),
        segments: segments.map((s) => s.shift(offset)).toList(),
        thickness: thickness,
      );

  factory RadialGaugeAxisDefinition.calculate(
    RadialGaugeLayout layout,
    GaugeAxis axis,
  ) {
    final thickness = axis.style.thickness;
    final halfThickness = thickness / 2;

    final cornerRadius = axis.style.cornerRadius.clampValues(
      minimumX: 0,
      minimumY: 0,
      maximumX: halfThickness,
      maximumY: halfThickness,
    );

    final Path axisSurface;
    if (cornerRadius == Radius.zero) {
      axisSurface = calculateAxisPath(
        layout.circleRect,
        degrees: axis.degrees,
        thickness: axis.style.thickness,
      );
    } else if (cornerRadius.x == cornerRadius.y &&
        cornerRadius.x == halfThickness) {
      axisSurface = calculateRoundedArcPath(
        layout.circleRect,
        degrees: axis.degrees,
        thickness: axis.style.thickness,
      );
    } else {
      axisSurface = calculateRadiusArcPath(
        layout.circleRect,
        cornerRadius: cornerRadius,
        degrees: axis.degrees,
        thickness: axis.style.thickness,
      );
    }

    final clampedRadius = layout.radius;
    final degrees = axis.degrees.clamp(10.0, 360.0);

    /// We are shifting arc angles to center it horizontally.
    final angleShift = (degrees - 180) / 2;
    final gaugeDegreesTween = Tween<double>(
      begin: -180.0 - angleShift,
      end: 0.0 + angleShift,
    );

    final centerRadius = clampedRadius - halfThickness;

    final axisRect = Rect.fromCircle(
      center: layout.targetRect.topCenter + Offset(0.0, clampedRadius),
      radius: centerRadius,
    );

    return RadialGaugeAxisDefinition(
      surface: axisSurface,
      rect: axisRect,
      thickness: thickness,
      segments: _calculateAxisSegments(
        axisRect,
        axis,
        gaugeDegreesTween,
        centerRadius,
      ).toList(),
    );
  }

  static Iterable<GaugeSegmentDefinition> _calculateAxisSegments(
    Rect axisRect,
    GaugeAxis axis,
    Tween<double> gaugeDegreesTween,
    double radius,
  ) sync* {
    final spacingAngle = getArcAngle(axis.style.segmentSpacing, radius);
    // Each segment has a half separator added / removed from its path.
    final separatorAngle = spacingAngle / 2;
    // Fraction of the axis span, so the gap stays consistent across degrees.
    final desiredSeparator = separatorAngle / toRadians(axis.degrees);
    // Reserve a minimum rendered width per segment so they don't disappear.
    final axisArcLength = radius * toRadians(axis.degrees);
    final minSegmentFraction =
        axisArcLength > 0 ? _minSegmentPx / axisArcLength : 0.0;
    final separator =
        math.min(desiredSeparator, _maxSeparator(axis, minSegmentFraction));

    final pathRadius = axis.style.thickness * 0.5;
    final pathInsets = EdgeInsets.all(pathRadius);
    final externalRect = pathInsets.inflateRect(axisRect);

    final range = axis.max - axis.min;

    for (var i = 0; i < axis.segments.length; i++) {
      final segment = axis.segments[i];

      // Clamp to [0, 1] so animation overshoot (e.g. elastic curves) doesn't
      // produce negative widths or push segments outside the visible axis.
      final from = ((segment.from - axis.min) / range).clamp(0.0, 1.0);
      final startAngle = gaugeDegreesTween.transform(from);

      final to = ((segment.to - axis.min) / range).clamp(0.0, 1.0);
      final endAngle = gaugeDegreesTween.transform(to);
      final sweepAngle = endAngle - startAngle;

      final isFirst = i == 0;
      final isLast = i == axis.segments.length - 1;
      // Only trim where a neighbor segment exists; outer caps reach the
      // axis ends.
      final trimStart = isFirst ? 0.0 : separator;
      final trimEnd = isLast ? 0.0 : separator;

      final thickness = axis.style.thickness;
      final halfThickness = thickness / 2;

      final clampedFrom = (from + trimStart).clamp(0.0, 1.0);
      final clampedTo = (to - trimEnd).clamp(0.0, 1.0);

      final segmentCornerRadius = segment.cornerRadius.clampValues(
        minimumX: 0,
        minimumY: 0,
        maximumX: halfThickness,
        maximumY: halfThickness,
      );
      final styleCornerRadius = axis.style.cornerRadius.clampValues(
        minimumX: 0,
        minimumY: 0,
        maximumX: halfThickness,
        maximumY: halfThickness,
      );

      final path = calculateRadiusArcPath(
        externalRect,
        cornerRadius: segmentCornerRadius,
        startCornerRadius: isFirst ? styleCornerRadius : segmentCornerRadius,
        endCornerRadius: isLast ? styleCornerRadius : segmentCornerRadius,
        degrees: axis.degrees,
        from: math.min(clampedFrom, clampedTo),
        to: math.max(clampedFrom, clampedTo),
        thickness: thickness,
      );

      yield GaugeSegmentDefinition(
        startAngle: toRadians(startAngle) + trimStart,
        sweepAngle: toRadians(sweepAngle) - trimEnd,
        color: segment.color,
        gradient: segment.gradient,
        border: segment.border,
        shader: segment.shader,
        path: path,
      );
    }
  }

  /// Minimum rendered segment width in logical pixels.
  static const double _minSegmentPx = 1.0;

  /// Largest separator that keeps every segment at least [minWidth] wide.
  static double _maxSeparator(GaugeAxis axis, double minWidth) {
    final count = axis.segments.length;
    if (count < 2) return double.infinity;
    final range = axis.max - axis.min;
    var maxSeparator = double.infinity;
    for (var i = 0; i < count; i++) {
      final seg = axis.segments[i];
      // Same clamp as the render loop so animation overshoot doesn't collapse
      // the spacing budget for a frame.
      final from = ((seg.from - axis.min) / range).clamp(0.0, 1.0);
      final to = ((seg.to - axis.min) / range).clamp(0.0, 1.0);
      final width = to - from;
      final reservable = math.max(0.0, width - minWidth);
      maxSeparator = math.min(maxSeparator, reservable / 2);
    }
    return maxSeparator;
  }
}
