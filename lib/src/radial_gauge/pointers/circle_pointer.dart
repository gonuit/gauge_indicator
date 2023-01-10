import 'dart:ui';

import 'package:gauge_indicator/gauge_indicator.dart';

class CirclePointer extends GaugePointer {
  @override
  final Size size;
  @override
  final Path path;
  @override
  final GaugePointerPosition position;
  @override
  final Color backgroundColor;
  @override
  final GaugePointerBorder? border;

  CirclePointer({
    required double radius,
    required this.backgroundColor,
    this.position = const GaugePointerPosition.surface(),
    this.border,
  })  : path = Path()
          ..addOval(Rect.fromCircle(
            center: Offset(radius, radius),
            radius: radius,
          )),
        size = Size.fromRadius(radius);

  @override
  List<Object?> get props => [size, backgroundColor, border, position];
}
