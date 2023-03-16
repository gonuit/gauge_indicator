import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:gauge_indicator/src/utils/calculate_radius_path.dart';

class GaugeSegmentDefinition {
  final double startAngle;
  final double sweepAngle;
  final Color? color;
  final GaugeAxisGradient? gradient;
  final Shader? shader;
  final Path path;

  GaugeSegmentDefinition({
    required this.startAngle,
    required this.sweepAngle,
    required this.path,
    this.color,
    this.gradient,
    this.shader,
  });
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
        segments: segments,
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
    const pi2 = math.pi * 2;
    final spacingAngle = getArcAngle(axis.style.segmentSpacing, radius);
    // Each segment has a half separator added / removed from its path.
    final separatorAngle = spacingAngle / 2;
    final separator = separatorAngle / pi2;

    final pathRadius = axis.style.thickness * 0.5;
    final pathInsets = EdgeInsets.all(pathRadius);
    final externalRect = pathInsets.inflateRect(axisRect);

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

      final thickness = axis.style.thickness;
      final halfThickness = thickness / 2;

      final clampedFrom = (from - trimStart).clamp(0.0, 1.0);
      final clampedTo = (to - trimEnd).clamp(0.0, 1.0);

      final path = calculateRadiusArcPath(
        externalRect,
        cornerRadius: segment.cornerRadius.clampValues(
          minimumX: 0,
          minimumY: 0,
          maximumX: halfThickness,
          maximumY: halfThickness,
        ),
        degrees: axis.degrees,
        from: math.min(clampedFrom, clampedTo),
        to: math.max(clampedFrom, clampedTo),
        thickness: thickness,
      );

      yield GaugeSegmentDefinition(
        startAngle: toRadians(startAngle) - trimStart,
        sweepAngle: toRadians(sweepAngle) - trimEnd,
        color: segment.color,
        gradient: segment.gradient,
        shader: segment.shader,
        path: path,
      );
    }
  }
}
