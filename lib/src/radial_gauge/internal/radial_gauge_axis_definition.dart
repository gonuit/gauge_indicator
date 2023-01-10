import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class GaugeSegmentDefinition {
  final double startAngle;
  final double sweepAngle;
  final Color? color;
  final GaugeAxisGradient? gradient;
  final Shader? shader;

  GaugeSegmentDefinition({
    required this.startAngle,
    required this.sweepAngle,
    this.color,
    this.gradient,
    this.shader,
  });
}

class RadialGaugeAxisDefinition {
  /// Describes a cricle placed in the axis center.
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
        segments: segments,
        thickness: thickness,
      );

  factory RadialGaugeAxisDefinition.calculate(
      RadialGaugeLayout layout, GaugeAxis axis) {
    final axisSurface = calculateRoundedArcPath(
      layout.circleRect,
      degrees: axis.degrees,
      thickness: axis.style.thickness,
    );

    final clampedRadius = layout.radius;
    final degrees = axis.degrees.clamp(10.0, 360.0);

    /// We are shifting arc angles to center it horizontally.
    final angleShift = (degrees - 180) / 2;
    final gaugeDegreesTween = Tween<double>(
      begin: -180.0 - angleShift,
      end: 0.0 + angleShift,
    );

    final thickness = axis.style.thickness;
    final halfThickness = thickness / 2;

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
        axis,
        gaugeDegreesTween,
        centerRadius,
      ).toList(),
    );
  }

  static Iterable<GaugeSegmentDefinition> _calculateAxisSegments(
    GaugeAxis axis,
    Tween<double> gaugeDegreesTween,
    double radius,
  ) sync* {
    final separator = getArcAngle(axis.style.segmentSpacing, radius) / 2;

    for (var i = 0; i < axis.segments.length; i++) {
      final segment = axis.segments[i];

      final from = (segment.from - axis.min) / (axis.max - axis.min);
      final startAngle = gaugeDegreesTween.transform(from);

      final to = (segment.to - axis.min) / (axis.max - axis.min);
      final endAngle = gaugeDegreesTween.transform(to);
      final sweepAngle = endAngle - startAngle;

      final isLast = (i + 1) == axis.segments.length;
      final isFirst = i == 0;
      final trimStart = isFirst ? 0 : -separator;
      final trimEnd = isFirst && isLast
          ? 0
          : isFirst || isLast
              ? separator
              : separator * 2;

      yield GaugeSegmentDefinition(
        startAngle: toRadians(startAngle) - trimStart,
        sweepAngle: toRadians(sweepAngle) - trimEnd,
        color: segment.color,
        gradient: segment.gradient,
        shader: segment.shader,
      );
    }
  }
}
