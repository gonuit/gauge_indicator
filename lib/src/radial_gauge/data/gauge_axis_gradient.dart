import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';

class GaugeAxisGradient extends Equatable {
  final List<Color> colors;
  final List<double>? colorStops;
  final TileMode tileMode;

  const GaugeAxisGradient({
    required this.colors,
    this.tileMode = TileMode.clamp,
    this.colorStops,
  });

  @override
  List<Object?> get props => [colors, colorStops, tileMode];
}
