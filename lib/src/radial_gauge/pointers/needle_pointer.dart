import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class NeedlePointer extends Equatable implements GaugePointer {
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
  final double borderRadius;
  @override
  final Gradient? gradient;
  @override
  final Shadow? shadow;

  NeedlePointer({
    required this.size,
    this.color,
    this.position = const GaugePointerPosition.center(),
    this.border,
    double? borderRadius,
    this.gradient,
    this.shadow,
  })  : borderRadius = borderRadius ?? size.width / 2,
        path = roundedPoly([
          VertexDefinition(0, size.height), // bottom left
          VertexDefinition(size.width, size.height), // bottom right
          VertexDefinition(size.width / 2, 0, radius: 0), // top center
        ], borderRadius ?? size.width / 2),
        assert(
            (color != null && gradient == null) ||
                (gradient != null && color == null),
            'Either color or gradient must be provided.');

  @override
  List<Object?> get props => [size, color, border, position, borderRadius];
}
