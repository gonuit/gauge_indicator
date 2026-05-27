import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

/// A sweep gradient applied along the gauge arc.
class GaugeAxisGradient {
  /// Colors swept across the gauge.
  final List<Color> colors;

  /// Optional stops in `[0, 1]` matching [colors]. When null, colors are
  /// distributed evenly.
  final List<double>? colorStops;

  /// How the gradient repeats outside the gauge arc.
  final TileMode tileMode;

  /// Creates a sweep gradient configuration.
  const GaugeAxisGradient({
    required this.colors,
    this.tileMode = TileMode.clamp,
    this.colorStops,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GaugeAxisGradient &&
        runtimeType == other.runtimeType &&
        listEquals(other.colors, colors) &&
        listEquals(other.colorStops, colorStops) &&
        other.tileMode == tileMode;
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAll(colors),
        colorStops == null ? null : Object.hashAll(colorStops!),
        tileMode,
      );
}
