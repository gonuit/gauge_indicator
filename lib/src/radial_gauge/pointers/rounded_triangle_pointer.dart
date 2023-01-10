import 'dart:ui';

import 'package:gauge_indicator/gauge_indicator.dart';

class RoundedTrianglePointer extends GaugePointer {
  @override
  final Size size;
  @override
  final Path path;
  @override
  final Color backgroundColor;
  @override
  final GaugePointerPosition position;
  @override
  final GaugePointerBorder? border;
  final double borderRadius;

  RoundedTrianglePointer({
    required double size,
    required this.backgroundColor,
    this.position = const GaugePointerPosition.surface(),
    this.borderRadius = 2,
    this.border,
  })  : path = roundedPoly([
          VertexDefinition(0, size), // bottom left
          VertexDefinition(size, size), // bottom right
          VertexDefinition(size / 2, 0), // top center
        ], borderRadius),
        size = Size.square(size);

  @override
  List<Object?> get props =>
      [size, backgroundColor, border, borderRadius, position];
}
