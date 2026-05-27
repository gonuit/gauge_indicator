// ignore_for_file: public_member_api_docs
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/src/internal.dart';

class GaugeZoneDefinition {
  final double startAngle;
  final double sweepAngle;
  final Color? color;
  final GaugeAxisGradient? gradient;
  final GaugeBorder? border;
  final Shader? shader;
  final BoxShadow? shadow;
  final GaugeZoneLabel? label;
  final double thickness;
  final Path path;

  GaugeZoneDefinition({
    required this.startAngle,
    required this.sweepAngle,
    required this.path,
    required this.color,
    required this.gradient,
    required this.border,
    required this.shader,
    required this.shadow,
    required this.label,
    required this.thickness,
  });

  GaugeZoneDefinition shift(Offset offset) => GaugeZoneDefinition(
    startAngle: startAngle,
    sweepAngle: sweepAngle,
    path: path.shift(offset),
    color: color,
    gradient: gradient,
    border: border,
    shader: shader,
    shadow: shadow,
    label: label,
    thickness: thickness,
  );
}

class RadialGaugeAxisDefinition {
  /// Describes a circle placed in the axis center.
  final Rect rect;
  final Path surface;
  final double thickness;
  final List<GaugeZoneDefinition> zones;

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
    required this.zones,
    required this.thickness,
  });

  RadialGaugeAxisDefinition shift(Offset offset) => RadialGaugeAxisDefinition(
    surface: surface.shift(offset),
    rect: rect.shift(offset),
    zones: zones.map((s) => s.shift(offset)).toList(),
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
        degrees: axis.sweepDegrees,
        thickness: axis.style.thickness,
      );
    } else if (cornerRadius.x == cornerRadius.y &&
        cornerRadius.x == halfThickness) {
      axisSurface = calculateRoundedArcPath(
        layout.circleRect,
        degrees: axis.sweepDegrees,
        thickness: axis.style.thickness,
      );
    } else {
      axisSurface = calculateRadiusArcPath(
        layout.circleRect,
        cornerRadius: cornerRadius,
        degrees: axis.sweepDegrees,
        thickness: axis.style.thickness,
      );
    }

    final clampedRadius = layout.radius;
    final degrees = axis.sweepDegrees.clamp(10.0, 360.0);

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
      zones: _calculateAxisZones(
        axisRect,
        axis,
        gaugeDegreesTween,
        centerRadius,
      ).toList(),
    );
  }

  static Iterable<GaugeZoneDefinition> _calculateAxisZones(
    Rect axisRect,
    GaugeAxis axis,
    Tween<double> gaugeDegreesTween,
    double radius,
  ) sync* {
    final spacingAngle = getArcAngle(axis.style.zoneSpacing, radius);
    // Each zone has a half separator added / removed from its path.
    final separatorAngle = spacingAngle / 2;
    // Fraction of the axis span, so the gap stays consistent across degrees.
    final desiredSeparator = separatorAngle / toRadians(axis.sweepDegrees);
    // Reserve a minimum rendered width per zone so they don't disappear.
    final axisArcLength = radius * toRadians(axis.sweepDegrees);
    final minZoneFraction = axisArcLength > 0
        ? _minZonePx / axisArcLength
        : 0.0;
    final separators = _resolveSeparators(
      axis,
      desiredSeparator,
      minZoneFraction,
    );

    final range = axis.max - axis.min;
    final styleThickness = axis.style.thickness;

    for (var i = 0; i < axis.zones.length; i++) {
      final zone = axis.zones[i];

      // Clamp to [0, 1] so animation overshoot (e.g. elastic curves) doesn't
      // produce negative widths or push zones outside the visible axis.
      final from = ((zone.from - axis.min) / range).clamp(0.0, 1.0);
      final startAngle = gaugeDegreesTween.transform(from);

      final to = ((zone.to - axis.min) / range).clamp(0.0, 1.0);
      final endAngle = gaugeDegreesTween.transform(to);
      final sweepAngle = endAngle - startAngle;

      final isFirst = i == 0;
      final isLast = i == axis.zones.length - 1;
      // Only trim where a neighbor zone exists; outer caps reach the
      // axis ends.
      final trimStart = isFirst ? 0.0 : separators[i - 1];
      final trimEnd = isLast ? 0.0 : separators[i];

      // Clamp so a zone never extends past the axis surface.
      final zoneThickness = (zone.thickness ?? styleThickness).clamp(
        0.0,
        styleThickness,
      );
      final zoneHalfThickness = zoneThickness / 2;
      final zoneExternalRect = EdgeInsets.all(
        zoneHalfThickness,
      ).inflateRect(axisRect);

      final clampedFrom = (from + trimStart).clamp(0.0, 1.0);
      final clampedTo = (to - trimEnd).clamp(0.0, 1.0);

      final zoneCornerRadius = zone.cornerRadius.clampValues(
        minimumX: 0,
        minimumY: 0,
        maximumX: zoneHalfThickness,
        maximumY: zoneHalfThickness,
      );
      final styleCornerRadius = axis.style.cornerRadius.clampValues(
        minimumX: 0,
        minimumY: 0,
        maximumX: zoneHalfThickness,
        maximumY: zoneHalfThickness,
      );

      final path = calculateRadiusArcPath(
        zoneExternalRect,
        cornerRadius: zoneCornerRadius,
        startCornerRadius: isFirst ? styleCornerRadius : zoneCornerRadius,
        endCornerRadius: isLast ? styleCornerRadius : zoneCornerRadius,
        degrees: axis.sweepDegrees,
        from: math.min(clampedFrom, clampedTo),
        to: math.max(clampedFrom, clampedTo),
        thickness: zoneThickness,
      );

      yield GaugeZoneDefinition(
        startAngle: toRadians(startAngle) + trimStart,
        sweepAngle: toRadians(sweepAngle) - trimEnd,
        color: zone.color,
        gradient: zone.gradient,
        border: zone.border,
        shader: zone.shader,
        shadow: zone.shadow,
        label: zone.label,
        thickness: zoneThickness,
        path: path,
      );
    }
  }

  /// Minimum rendered zone width in logical pixels.
  static const double _minZonePx = 1.0;

  /// Per-boundary separator widths. There are `zones.length - 1` boundaries;
  /// `result[i]` is the gap between `zones[i]` and `zones[i + 1]`. Honors
  /// [GaugeAxisStyle.zoneSpacingMode]: uniform picks the smallest value
  /// supported by any zone; local trims only the gaps adjacent to narrow
  /// zones.
  static List<double> _resolveSeparators(
    GaugeAxis axis,
    double desiredSeparator,
    double minWidth,
  ) {
    final count = axis.zones.length;
    if (count < 2) return const <double>[];

    final range = axis.max - axis.min;
    final reservable = List<double>.generate(count, (i) {
      final zone = axis.zones[i];
      // Same clamp as the render loop so animation overshoot doesn't collapse
      // the spacing budget for a frame.
      final from = ((zone.from - axis.min) / range).clamp(0.0, 1.0);
      final to = ((zone.to - axis.min) / range).clamp(0.0, 1.0);
      return math.max(0.0, to - from - minWidth);
    });

    switch (axis.style.zoneSpacingMode) {
      case ZoneSpacingMode.uniform:
        var maxSeparator = double.infinity;
        for (final r in reservable) {
          maxSeparator = math.min(maxSeparator, r / 2);
        }
        final separator = math.min(desiredSeparator, maxSeparator);
        return List<double>.filled(count - 1, separator);

      case ZoneSpacingMode.local:
        // Each boundary between zone i and zone i+1 reserves up to half of
        // both zones' free space.
        return List<double>.generate(count - 1, (i) {
          final local = math.min(reservable[i], reservable[i + 1]) / 2;
          return math.min(desiredSeparator, local);
        });
    }
  }
}
