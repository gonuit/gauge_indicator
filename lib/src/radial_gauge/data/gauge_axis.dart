import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gauge_indicator/src/internal.dart';

/// How [GaugeAxisStyle.zoneSpacing] adapts when a zone is too narrow to
/// reserve the full spacing on both sides.
enum ZoneSpacingMode {
  /// Shrink every gap to the same value so spacing stays visually uniform
  /// across the gauge. A single narrow zone tightens the whole gauge.
  uniform,

  /// Shrink only the gaps adjacent to a narrow zone. Other boundaries keep
  /// the full requested spacing. May produce uneven gap widths.
  local,
}

/// Visual style for a [GaugeAxis] — controls thickness, corner radius,
/// background, and zone spacing.
@immutable
class GaugeAxisStyle {
  /// Width of the axis band in logical pixels.
  final double thickness;

  /// Gap between adjacent zones, in fractional axis units.
  final double zoneSpacing;

  /// How [zoneSpacing] adapts when a zone is too narrow to reserve the full
  /// gap on both sides. Defaults to [ZoneSpacingMode.uniform].
  final ZoneSpacingMode zoneSpacingMode;

  /// Corner radius of the axis surface. Clamped to half of [thickness].
  final Radius cornerRadius;

  /// Fill color drawn behind the zones. When null, no background is
  /// painted.
  final Color? background;

  /// Whether adjacent zone colors should blend across their boundary.
  final bool blendColors;

  /// Creates an axis style.
  const GaugeAxisStyle({
    this.thickness = 20,
    this.background = const Color(0xFFf0f0f0),
    this.cornerRadius = const Radius.circular(10),
    this.zoneSpacing = 0,
    this.zoneSpacingMode = ZoneSpacingMode.uniform,
    this.blendColors = true,
  });

  /// Linearly interpolates between two [GaugeAxisStyle]s at fraction [t].
  static GaugeAxisStyle lerp(
    GaugeAxisStyle begin,
    GaugeAxisStyle end,
    double t,
  ) =>
      GaugeAxisStyle(
        thickness: lerpDouble(begin.thickness, end.thickness, t),
        background: Color.lerp(begin.background, end.background, t),
        blendColors: end.blendColors,
        zoneSpacing: lerpDouble(begin.zoneSpacing, end.zoneSpacing, t),
        zoneSpacingMode: end.zoneSpacingMode,
        cornerRadius: Radius.lerp(begin.cornerRadius, end.cornerRadius, t)!,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GaugeAxisStyle &&
        runtimeType == other.runtimeType &&
        other.thickness == thickness &&
        other.zoneSpacing == zoneSpacing &&
        other.zoneSpacingMode == zoneSpacingMode &&
        other.background == background &&
        other.blendColors == blendColors &&
        other.cornerRadius == cornerRadius;
  }

  @override
  int get hashCode => Object.hash(
        thickness,
        zoneSpacing,
        zoneSpacingMode,
        background,
        blendColors,
        cornerRadius,
      );
}

/// A [Tween] over [GaugeAxis] values used by [AnimatedRadialGauge] to
/// interpolate axis configurations during transitions.
class GaugeAxisTween extends Tween<GaugeAxis?> {
  /// Creates a tween between two axes.
  GaugeAxisTween({super.begin, super.end});

  @override
  GaugeAxis? lerp(double t) => GaugeAxis.lerp(begin, end, t);
}

/// Configuration for the gauge's circular axis.
///
/// Defines the value range ([min], [max]), the sweep angle ([sweepDegrees]),
/// visual [style], [zones], [pointer], [progressBar], and animation
/// [transformer]. Pass to [RadialGauge.axis] or [AnimatedRadialGauge.axis].
@immutable
class GaugeAxis {
  /// If specified, the defined indicator will be used to display
  /// the current value of the gauge.
  ///
  /// Defaults to [defaultPointer].
  /// ```
  final GaugePointer? pointer;

  /// The minimum value the gauge can display.
  ///
  /// Defaults to 0.0. Must be less than [max].
  final double min;

  /// The maximum value the gauge can display.
  ///
  /// Defaults to 1.0. Must be greater than [min].
  final double max;

  /// Value from which the progress bar is drawn. Must lie within
  /// `[min, max]`. Defaults to [min].
  final double origin;

  /// Sweep angle of the axis in degrees. Defaults to 180.
  ///
  /// Must be between 10 and 360 inclusive.
  final double sweepDegrees;

  /// Specifies the style of the indicator axis.
  final GaugeAxisStyle style;

  /// Transformer is responsible for modifying zones.
  ///
  /// Implementations:
  /// - [GaugeAxisTransformer.noTransform] - default, no transformation.
  /// - [GaugeAxisTransformer.progress] - Uses zones to display gauge value.
  ///  Can be used as a progress bar.
  /// - [GaugeAxisTransformer.colorFadeIn] - Gradually displays the colors of
  /// the zones.
  final GaugeAxisTransformer transformer;

  /// Progress bar drawn from [origin] to the current value. When null, no
  /// progress bar is rendered.
  final GaugeProgressBar? progressBar;

  /// Zones drawn along the gauge axis.
  final List<GaugeZone> zones;

  /// Default pointer used when no [pointer] is specified.
  static const defaultPointer = GaugePointer.triangle(
    width: 24,
    height: 24,
    border: GaugePointerBorder(
      color: Color(0xFFf0f0f0),
      width: 2,
    ),
    borderRadius: 3,
    position: GaugePointerPosition.surface(
      offset: Offset(0, 8),
    ),
    color: Colors.black,
  );

  /// Default progress bar used when no [progressBar] is specified.
  static const defaultProgressBar =
      GaugeProgressBar.basic(color: Color(0xFF9fec6d));

  /// Creates a gauge axis.
  const GaugeAxis({
    this.min = 0.0,
    this.max = 1.0,
    double? origin,
    this.transformer = const GaugeAxisTransformer.noTransform(),
    this.zones = const [],
    this.sweepDegrees = 180,
    this.pointer = defaultPointer,
    this.progressBar = defaultProgressBar,
    this.style = const GaugeAxisStyle(),
  })  : origin = origin ?? min,
        assert(
          sweepDegrees >= 10 && sweepDegrees <= 360,
          'sweepDegrees must be between 10 and 360, inclusive.',
        ),
        assert(
          (origin ?? min) >= min && (origin ?? min) <= max,
          'origin must be within [min, max].',
        );

  /// Applies the [transformer] to produce a per-frame transformed axis.
  GaugeAxis transform({
    required GaugeRange range,
    required double progress,
    required double value,
    required bool isInitial,
  }) =>
      transformer.transform(this, range, progress, value, isInitial);

  /// Returns a copy of this axis with the given fields replaced.
  GaugeAxis copyWith({
    final GaugeAxisStyle? style,
    final List<GaugeZone>? zones,
    final GaugePointer? pointer,
    final GaugeProgressBar? progressBar,
    final GaugeAxisTransformer? transformer,
    final double? sweepDegrees,
    final double? min,
    final double? max,
    final double? origin,
  }) =>
      GaugeAxis(
        min: min ?? this.min,
        max: max ?? this.max,
        origin: origin ?? this.origin,
        sweepDegrees: sweepDegrees ?? this.sweepDegrees,
        zones: zones ?? this.zones,
        style: style ?? this.style,
        pointer: pointer ?? this.pointer,
        transformer: transformer ?? this.transformer,
        progressBar: progressBar ?? this.progressBar,
      );

  /// Returns a copy with overlapping zones merged into a continuous
  /// non-overlapping sequence.
  GaugeAxis flatten() => copyWith(
        zones: flattenZones(
          zones,
          colorBlending: style.blendColors,
        ).toList(),
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GaugeAxis &&
        runtimeType == other.runtimeType &&
        other.pointer == pointer &&
        other.style == style &&
        listEquals(other.zones, zones) &&
        other.sweepDegrees == sweepDegrees &&
        other.progressBar == progressBar;
  }

  @override
  int get hashCode => Object.hash(
        pointer,
        style,
        Object.hashAll(zones),
        sweepDegrees,
        progressBar,
      );

  /// Linearly interpolates between two axes at fraction [t]. Returns null
  /// when both ends are null.
  static GaugeAxis? lerp(GaugeAxis? begin, GaugeAxis? end, double t) {
    if (begin == null && end == null) {
      return null;
    } else if (begin == null) {
      return end;
    } else if (end == null) {
      return begin;
    } else {
      late final List<GaugeZone> transformedZones;
      if (t == 1.0) {
        transformedZones = end.zones;
      } else if (t == 0.0) {
        transformedZones = begin.zones;
      } else {
        transformedZones = List.generate(
          math.max(begin.zones.length, end.zones.length),
          (index) {
            final beginZone =
                index < begin.zones.length ? begin.zones[index] : null;
            final endZone = index < end.zones.length ? end.zones[index] : null;

            /// One zone is always present.
            return GaugeZone.lerp(
              beginZone ?? endZone!.copyWith(from: endZone.to),
              endZone ?? beginZone!.copyWith(to: beginZone.from),
              t,
            );
          },
        );
      }
      return end.copyWith(
        sweepDegrees: lerpDouble(begin.sweepDegrees, end.sweepDegrees, t)
            .clamp(10.0, 360.0),
        style: GaugeAxisStyle.lerp(begin.style, end.style, t),
        pointer: end.pointer,
        progressBar: end.progressBar,
        transformer: end.transformer,
        zones: transformedZones,
      );
    }
  }
}
