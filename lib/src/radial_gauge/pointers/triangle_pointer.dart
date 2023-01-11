import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class TrianglePointer extends Equatable implements GaugePointer {
  @override
  final Size size;
  @override
  final Path path;
  @override
  final Color color;
  @override
  final GaugePointerPosition position;
  @override
  final GaugePointerBorder? border;
  final double borderRadius;

  TrianglePointer({
    required double size,
    required this.color,
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
  List<Object?> get props => [size, color, border, borderRadius, position];
}
