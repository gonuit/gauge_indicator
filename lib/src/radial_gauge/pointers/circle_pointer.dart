import 'package:equatable/equatable.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:flutter/widgets.dart';

class CirclePointer extends Equatable implements GaugePointer {
  @override
  final Size size;
  @override
  final Path path;
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

  CirclePointer({
    required double radius,
    this.color,
    this.position = const GaugePointerPosition.surface(),
    this.border,
    this.gradient,
    this.shadow,
  })  : path = Path()
          ..addOval(Rect.fromCircle(
            center: Offset(radius, radius),
            radius: radius,
          )),
        size = Size.fromRadius(radius),
        assert(
          (color != null && gradient == null) ||
              (gradient != null && color == null),
          'Either color or gradient must be provided.',
        );

  @override
  List<Object?> get props => [size, color, border, position, gradient, shadow];
}
