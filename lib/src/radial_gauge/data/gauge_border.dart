import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import 'package:gauge_indicator/src/internal.dart';

/// A stroke painted around a [GaugeSegment].
class GaugeBorder extends Equatable {
  /// Stroke color.
  final Color color;

  /// Stroke width in logical pixels.
  final double width;

  /// Creates a segment border.
  const GaugeBorder({
    required this.color,
    this.width = 1.0,
  });

  @override
  List<Object?> get props => [color, width];

  /// Linearly interpolates between two borders at fraction [t]. Returns null
  /// when [end] is null.
  static GaugeBorder? lerp(GaugeBorder? begin, GaugeBorder? end, double t) {
    if (end == null) return null;
    if (begin == null) return end;

    return GaugeBorder(
      color: Color.lerp(begin.color, end.color, t)!,
      width: lerpDouble(begin.width, end.width, t),
    );
  }
}
