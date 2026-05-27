import 'package:flutter/rendering.dart';
import 'package:gauge_indicator/src/internal.dart';

/// A stroke painted around a [GaugeZone].
class GaugeBorder {
  /// Stroke color.
  final Color color;

  /// Stroke width in logical pixels.
  final double width;

  /// Creates a zone border.
  const GaugeBorder({required this.color, this.width = 1.0});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GaugeBorder &&
        runtimeType == other.runtimeType &&
        other.color == color &&
        other.width == width;
  }

  @override
  int get hashCode => Object.hash(color, width);

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
