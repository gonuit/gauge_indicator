import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

@immutable
class GaugeAxisStyle extends Equatable {
  final double thickness;
  final double segmentSpacing;

  /// Corner radius of the axis core segment
  final Radius cornerRadius;
  final Color? background;

  /// Whether to blend the colors of the segments.
  final bool blendColors;

  const GaugeAxisStyle({
    this.thickness = 20,
    this.background = const Color(0xFFf0f0f0),
    this.cornerRadius = const Radius.circular(10),
    this.segmentSpacing = 0,
    this.blendColors = true,
  });

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
      [thickness, segmentSpacing, background, blendColors];
}

class GaugeAxisTween extends Tween<GaugeAxis?> {
  GaugeAxisTween({GaugeAxis? begin, GaugeAxis? end})
      : super(begin: begin, end: end);

  @override
  GaugeAxis? lerp(double t) => GaugeAxis.lerp(begin, end, t);
}

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

  /// The zero value the gauge can display.
  ///
  /// Defaults to 0.0. Must be greater or equal to [min].
  final double zero;

  /// Determines the degree of arc of the gauge axis.
  ///
  /// Defaults to 180.
  final double degrees;

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

  final GaugeProgressBar? progressBar;

  /// Segments to be drawn on the gauge axis.
  final List<GaugeSegment> segments;

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

  static const defaultProgressBar =
      GaugeProgressBar.basic(color: Color(0xFF9fec6d));

  const GaugeAxis({
    this.min = 0.0,
    this.max = 1.0,
    this.zero = 0.0,
    this.transformer = const GaugeAxisTransformer.noTransform(),
    this.segments = const [],
    this.degrees = 180,
    this.pointer = defaultPointer,
    this.progressBar = defaultProgressBar,
    this.style = const GaugeAxisStyle(),
  }) : assert(
          degrees >= 10 && degrees <= 360,
          'The axis degree value must be between 10 and 360, inclusive.',
        );

  GaugeAxis transform({
    required GaugeRange range,
    required double progress,
    required double value,
    required bool isInitial,
  }) =>
      transformer.transform(this, range, progress, value, isInitial);

  GaugeAxis copyWith({
    final GaugeAxisStyle? style,
    final List<GaugeSegment>? segments,
    final GaugePointer? pointer,
    final GaugeProgressBar? progressBar,
    final GaugeAxisTransformer? transformer,
    final double? degrees,
    final double? min,
    final double? max,
    final double? zero,
  }) =>
      GaugeAxis(
        min: min ?? this.min,
        max: max ?? this.max,
        zero: zero ?? this.zero,
        degrees: degrees ?? this.degrees,
        segments: segments ?? this.segments,
        style: style ?? this.style,
        pointer: pointer ?? this.pointer,
        transformer: transformer ?? this.transformer,
        progressBar: progressBar ?? this.progressBar,
      );

  GaugeAxis flatten() => copyWith(
        segments: flattenSegments(
          segments,
          colorBlending: style.blendColors,
        ).toList(),
      );

  @override
  List<Object?> get props => [pointer, style, segments, degrees, progressBar];

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
        degrees: lerpDouble(begin.degrees, end.degrees, t).clamp(10.0, 360.0),
        style: GaugeAxisStyle.lerp(begin.style, end.style, t),
        pointer: end.pointer,
        progressBar: end.progressBar,
        transformer: end.transformer,
        segments: transformedSegments,
      );
    }
  }
}
