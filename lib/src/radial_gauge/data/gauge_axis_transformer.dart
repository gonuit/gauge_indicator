import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import 'data.dart';

/// A numeric `[min, max]` range used by [GaugeAxisTransformer].
class GaugeRange {
  /// Lower bound of the range.
  final double min;

  /// Upper bound of the range.
  final double max;

  /// Creates a range from [min] to [max].
  const GaugeRange(this.min, this.max);
}

/// Transforms a [GaugeAxis] per animation frame, enabling effects like
/// color fade-in or value-driven zone overrides.
///
/// Use the factory constructors for built-in transformations; subclass to
/// implement a custom one.
abstract class GaugeAxisTransformer {
  /// Base constructor for subclasses.
  const GaugeAxisTransformer();

  /// No transformation
  const factory GaugeAxisTransformer.noTransform() = _NoTransform;

  /// Gradually displays the colors of the zones.
  const factory GaugeAxisTransformer.colorFadeIn({
    required Interval interval,
    Color background,
  }) = _ColorFadeIn;

  /// Uses zones to display gauge value.
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
      final updatedZones = axis.zones
          .map((s) => s.copyWith(
                color: Color.alphaBlend(
                  s.color.withValues(alpha: value),
                  background,
                ),
              ))
          .toList();
      return axis.copyWith(zones: updatedZones);
    } else {
      return axis;
    }
  }
}

class _ProgressTransformer extends GaugeAxisTransformer {
  /// Whether to blend the colors of the zones.
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
    /// One overlay per underlying zone, clipped to the recoloured side of
    /// [value] and inheriting that zone's [GaugeZone.cornerRadius] and other
    /// properties. When there are no zones, fall back to a single overlay
    /// across the recoloured range so the transformer still produces a fill
    /// on a bare axis.
    final overlays = <GaugeZone>[];
    if (axis.zones.isEmpty) {
      overlays.add(
        reversed
            ? GaugeZone(from: value, to: range.max, color: color)
            : GaugeZone(from: range.min, to: value, color: color),
      );
    } else {
      for (final zone in axis.zones) {
        final overlayFrom = reversed ? math.max(value, zone.from) : zone.from;
        final overlayTo = reversed ? zone.to : math.min(value, zone.to);
        if (overlayTo <= overlayFrom) continue;
        overlays.add(zone.copyWith(
          from: overlayFrom,
          to: overlayTo,
          color: color,
        ));
      }
    }

    final zones = flattenZones(
      [...axis.zones, ...overlays],
      colorBlending: blendColors,
    ).toList();

    return axis.copyWith(zones: zones);
  }
}
