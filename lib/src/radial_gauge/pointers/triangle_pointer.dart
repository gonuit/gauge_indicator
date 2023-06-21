import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class TrianglePointer extends Equatable implements GaugePointer {
  final double width;
  final double height;

  @override
  final Size size;
  @override
  final Path path;
  @override
  final Color? color;
  @override
  final GaugePointerPosition position;
  @override
  final GaugePointerBorder? border;
  final double borderRadius;
  @override
  final Gradient? gradient;
  @override
  final Shadow? shadow;

  TrianglePointer({
    required this.width,
    required this.height,
    this.color,
    this.position = const GaugePointerPosition.surface(),
    this.borderRadius = 2,
    this.border,
    this.gradient,
    this.shadow,
  })  : path = roundedPoly([
          VertexDefinition(0, height), // bottom left
          VertexDefinition(width, height), // bottom right
          VertexDefinition(width / 2, 0), // top center
        ], borderRadius),
        size = Size(width, height),
        assert(
          (color != null && gradient == null) || (gradient != null && color == null),
          'Either color or gradient must be provided.',
        );

  @override
  List<Object?> get props => [size, color, border, borderRadius, position];
}
