import 'package:equatable/equatable.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:flutter/widgets.dart';

class CirclePointer extends Equatable implements GaugePointer {
  final double radius;

  @override
  final GaugePointerPosition position;
  @override
  final Color? color;
  @override
  final GaugePointerBorder? border;
  @override
  final Gradient? gradient;
  @override
  final Shadow? shadow;

  @override
  Size get size => Size.fromRadius(radius);
  @override
  Path get path => Path()
    ..addOval(Rect.fromCircle(
      center: Offset(radius, radius),
      radius: radius,
    ));

  const CirclePointer({
    required this.radius,
    this.color,
    this.position = const GaugePointerPosition.surface(),
    this.border,
    this.gradient,
    this.shadow,
  }) : assert(
          (color != null && gradient == null) ||
              (gradient != null && color == null),
          'Either color or gradient must be provided.',
        );

  @override
  List<Object?> get props => [size, color, border, position, gradient, shadow];
}
