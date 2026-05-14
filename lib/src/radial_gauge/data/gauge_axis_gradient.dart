import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';

/// A sweep gradient applied along the gauge arc.
class GaugeAxisGradient extends Equatable {
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
  List<Object?> get props => [colors, colorStops, tileMode];
}
