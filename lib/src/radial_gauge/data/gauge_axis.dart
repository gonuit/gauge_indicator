import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gauge_indicator/src/internal.dart';

/// Visual style for a [GaugeAxis] — controls thickness, corner radius,
/// background, and segment spacing.
@immutable
class GaugeAxisStyle extends Equatable {
  /// Width of the axis band in logical pixels.
  final double thickness;

  /// Gap between adjacent segments, in fractional axis units.
  final double segmentSpacing;

  /// Corner radius of the axis surface. Clamped to half of [thickness].
  final Radius cornerRadius;

  /// Fill color drawn behind the segments. When null, no background is
  /// painted.
  final Color? background;

  /// Whether adjacent segment colors should blend across their boundary.
  final bool blendColors;

  /// Creates an axis style.
  const GaugeAxisStyle({
    this.thickness = 20,
    this.background = const Color(0xFFf0f0f0),
    this.cornerRadius = const Radius.circular(10),
    this.segmentSpacing = 0,
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
        segmentSpacing: lerpDouble(begin.segmentSpacing, end.segmentSpacing, t),
        cornerRadius: Radius.lerp(begin.cornerRadius, end.cornerRadius, t)!,
      );

  @override
  List<Object?> get props =>
      [thickness, segmentSpacing, background, blendColors, cornerRadius];
}

/// A [Tween] over [GaugeAxis] values used by [AnimatedRadialGauge] to
/// interpolate axis configurations during transitions.
class GaugeAxisTween extends Tween<GaugeAxis?> {
  /// Creates a tween between two axes.
  GaugeAxisTween({GaugeAxis? begin, GaugeAxis? end})
      : super(begin: begin, end: end);

  @override
  GaugeAxis? lerp(double t) => GaugeAxis.lerp(begin, end, t);
}

/// Configuration for the gauge's circular axis.
///
/// Defines the value range ([min], [max]), the sweep angle ([sweepDegrees]),
/// visual [style], [segments], [pointer], [progressBar], and animation
/// [transformer]. Pass to [RadialGauge.axis] or [AnimatedRadialGauge.axis].
@immutable
class GaugeAxis extends Equatable {
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

  /// Value from which the progress bar is drawn. Defaults to 0.0.
  final double origin;

  /// Sweep angle of the axis in degrees. Defaults to 180.
  ///
  /// Must be between 10 and 360 inclusive.
  final double sweepDegrees;

  /// Renamed to [origin].
  @Deprecated('Renamed to origin. Will be removed in 0.6.0.')
  double get zero => origin;

  /// Renamed to [sweepDegrees].
  @Deprecated('Renamed to sweepDegrees. Will be removed in 0.6.0.')
  double get degrees => sweepDegrees;

  /// Specifies the style of the indicator axis.
  final GaugeAxisStyle style;

  /// Transformer is responsible for modifying segments.
  ///
  /// Implementations:
  /// - [GaugeAxisTransformer.noTransform] - default, no transformation.
  /// - [GaugeAxisTransformer.progress] - Uses segments to display gauge value.
  ///  Can be used as a progress bar.
  /// - [GaugeAxisTransformer.colorFadeIn] - Gradually displays the colors of
  /// the segments.
  final GaugeAxisTransformer transformer;

  /// Progress bar drawn from [zero] to the current value. When null, no
  /// progress bar is rendered.
  final GaugeProgressBar? progressBar;

  /// Segments drawn along the gauge axis.
  final List<GaugeSegment> segments;

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
    double origin = 0.0,
    @Deprecated('Renamed to origin. Will be removed in 0.6.0.')
    double? zero,
    this.transformer = const GaugeAxisTransformer.noTransform(),
    this.segments = const [],
    double sweepDegrees = 180,
    @Deprecated('Renamed to sweepDegrees. Will be removed in 0.6.0.')
    double? degrees,
    this.pointer = defaultPointer,
    this.progressBar = defaultProgressBar,
    this.style = const GaugeAxisStyle(),
  })  : origin = zero ?? origin,
        sweepDegrees = degrees ?? sweepDegrees,
        assert(
          (degrees ?? sweepDegrees) >= 10 &&
              (degrees ?? sweepDegrees) <= 360,
          'sweepDegrees must be between 10 and 360, inclusive.',
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
    final List<GaugeSegment>? segments,
    final GaugePointer? pointer,
    final GaugeProgressBar? progressBar,
    final GaugeAxisTransformer? transformer,
    final double? sweepDegrees,
    @Deprecated('Renamed to sweepDegrees. Will be removed in 0.6.0.')
    final double? degrees,
    final double? min,
    final double? max,
    final double? origin,
    @Deprecated('Renamed to origin. Will be removed in 0.6.0.')
    final double? zero,
  }) =>
      GaugeAxis(
        min: min ?? this.min,
        max: max ?? this.max,
        origin: origin ?? zero ?? this.origin,
        sweepDegrees: sweepDegrees ?? degrees ?? this.sweepDegrees,
        segments: segments ?? this.segments,
        style: style ?? this.style,
        pointer: pointer ?? this.pointer,
        transformer: transformer ?? this.transformer,
        progressBar: progressBar ?? this.progressBar,
      );

  /// Returns a copy with overlapping segments merged into a continuous
  /// non-overlapping sequence.
  GaugeAxis flatten() => copyWith(
        segments: flattenSegments(
          segments,
          colorBlending: style.blendColors,
        ).toList(),
      );

  @override
  List<Object?> get props =>
      [pointer, style, segments, sweepDegrees, progressBar];

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
      late final List<GaugeSegment> transformedSegments;
      if (t == 1.0) {
        transformedSegments = end.segments;
      } else if (t == 0.0) {
        transformedSegments = begin.segments;
      } else {
        transformedSegments = List.generate(
          math.max(begin.segments.length, end.segments.length),
          (index) {
            final beginSegment =
                index < begin.segments.length ? begin.segments[index] : null;
            final endSegment =
                index < end.segments.length ? end.segments[index] : null;

            /// One segment is always present.
            return GaugeSegment.lerp(
              beginSegment ?? endSegment!.copyWith(from: endSegment.to),
              endSegment ?? beginSegment!.copyWith(to: beginSegment.from),
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
        segments: transformedSegments,
      );
    }
  }
}
