import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class GaugeBorder extends Equatable {
  final Color color;
  final double width;

  const GaugeBorder({
    required this.color,
    this.width = 1.0,
  });

  @override
  List<Object?> get props => [color, width];

  static GaugeBorder? lerp(GaugeBorder? begin, GaugeBorder? end, double t) {
    if (end == null) return null;
    if (begin == null) return end;

    return GaugeBorder(
      color: Color.lerp(begin.color, end.color, t)!,
      width: lerpDouble(begin.width, end.width, t),
    );
  }
}
