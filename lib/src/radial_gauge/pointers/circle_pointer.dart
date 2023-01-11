import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class CirclePointer extends Equatable implements GaugePointer {
  @override
  final Size size;
  @override
  final Path path;
  @override
  final GaugePointerPosition position;
  @override
  final Color color;
  @override
  final GaugePointerBorder? border;

  CirclePointer({
    required double radius,
    required this.color,
    this.position = const GaugePointerPosition.surface(),
    this.border,
  })  : path = Path()
          ..addOval(Rect.fromCircle(
            center: Offset(radius, radius),
            radius: radius,
          )),
        size = Size.fromRadius(radius);

  @override
  List<Object?> get props => [size, color, border, position];
}
