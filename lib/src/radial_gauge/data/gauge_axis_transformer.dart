import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import 'data.dart';

class GaugeRange {
  final double min;
  final double max;

  const GaugeRange(this.min, this.max);
}

abstract class GaugeAxisTransformer {
  const GaugeAxisTransformer();

  /// No transformation
  const factory GaugeAxisTransformer.noTransform() = _NoTransform;

  /// Gradually displays the colors of the segments.
  const factory GaugeAxisTransformer.colorFadeIn({
    required Interval interval,
    Color background,
  }) = _ColorFadeIn;

  /// Uses segments to display gauge value.
  /// Can be used as a progress bar.
  const factory GaugeAxisTransformer.progress({
    required Color color,
    bool blendColors,
    bool reversed,
  }) = _ProgressTransformer;

  /// Transform [axis] using [progress] value from (0-1).
  GaugeAxis transform(
    GaugeAxis axis,
    GaugeRange range,
    double progress,
    double value,

    /// Is it the first animation after the initial build of the widget.
    /// Value is increasing from 0 to value.
    // ignore: avoid_positional_boolean_parameters
    bool isInitial,
  );
}

class _NoTransform extends GaugeAxisTransformer {
  const _NoTransform();

  @override
  GaugeAxis transform(
    GaugeAxis axis,
    GaugeRange range,
    double progress,
    double value,
    bool isInitial,
  ) =>
      axis;
}

class _ColorFadeIn extends GaugeAxisTransformer {
  final Interval interval;
  final Color background;

  const _ColorFadeIn({
    required this.interval,
    this.background = Colors.transparent,
  });

  @override
  GaugeAxis transform(
    GaugeAxis axis,
    GaugeRange range,
    double progress,
    double value,
    bool isInitial,
  ) {
    if (isInitial) {
      final value = interval.transform(progress);
      final updatedSegments = axis.segments
          .map((s) => s.copyWith(
                color: Color.alphaBlend(
                  s.style.color!.withOpacity(value),
                  background,
                ),
              ))
          .toList();
      return axis.copyWith(segments: updatedSegments);
    } else {
      return axis;
    }
  }
}

class _ProgressTransformer extends GaugeAxisTransformer {
  /// Whether to blend the colors of the segments.
  final bool blendColors;
  final bool reversed;
  final Color color;

  const _ProgressTransformer({
    required this.color,
    this.blendColors = false,
    this.reversed = false,
  });

  @override
  GaugeAxis transform(
    GaugeAxis axis,
    GaugeRange range,
    double progress,
    double value,
    bool isInitial,
  ) {
    final segments = flattenSegments(
      [
        ...axis.segments,
        if (reversed)
          GaugeSegment(
              from: value,
              to: range.max,
              style: GaugeSegmentStyle(
                color: color,
                cornerRadius: axis.style.cornerRadius,
                thickness: axis.style.thickness,
              ))
        else
          GaugeSegment(
            from: range.min,
            to: value,
            style: GaugeSegmentStyle(
              color: color,
              cornerRadius: axis.style.cornerRadius,
              thickness: axis.style.thickness,
            ),
          ),
      ],
      colorBlending: blendColors,
    ).toList();

    return axis.copyWith(segments: segments);
  }
}
