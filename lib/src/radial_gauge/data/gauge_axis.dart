import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

@immutable
class GaugeAxisStyle extends Equatable {
  final double thickness;
  final double segmentSpacing;
  final Color? background;

  /// Whether to blend the colors of the segments.
  final bool blendColors;

  const GaugeAxisStyle({
    this.thickness = 10,
    this.background,
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
  final GaugePointer? pointer;
  final double min;
  final double max;
  final GaugeAxisStyle style;
  final double degrees;
  final GaugeAxisTransformer transformer;

  final List<GaugeSegment> segments;

  const GaugeAxis({
    this.min = 0.0,
    this.max = 100.0,
    this.transformer = const GaugeAxisTransformer.noTransform(),
    this.segments = const [],
    this.degrees = 180,
    this.pointer,
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
    final GaugeAxisTransformer? transformer,
    final double? degrees,
    final double? min,
    final double? max,
    final double? value,
  }) =>
      GaugeAxis(
        min: min ?? this.min,
        max: max ?? this.max,
        degrees: degrees ?? this.degrees,
        segments: segments ?? this.segments,
        style: style ?? this.style,
        pointer: pointer ?? this.pointer,
        transformer: transformer ?? this.transformer,
      );

  GaugeAxis flatten() => copyWith(
        segments: flattenSegments(
          segments,
          colorBlending: style.blendColors,
        ).toList(),
      );

  @override
  List<Object?> get props => [pointer, style, segments, degrees];

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
        transformer: end.transformer,
        segments: transformedSegments,
      );
    }
  }
}
