import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class TrianglePointer extends Equatable implements GaugePointer {
  final double width;
  final double height;

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
    required this.width,
    required this.height,
    required this.color,
    this.position = const GaugePointerPosition.surface(),
    this.borderRadius = 2,
    this.border,
  })  : path = roundedPoly([
          VertexDefinition(0, height), // bottom left
          VertexDefinition(width, height), // bottom right
          VertexDefinition(width / 2, 0), // top center
        ], borderRadius),
        size = Size(width, height);

  @override
  List<Object?> get props => [size, color, border, borderRadius, position];
}
