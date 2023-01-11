import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class NeedlePointer extends Equatable implements GaugePointer {
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
  final double borderRadius;

  NeedlePointer({
    required this.size,
    required this.color,
    this.position = const GaugePointerPosition.center(),
    this.border,
    double? borderRadius,
  })  : borderRadius = borderRadius ?? size.width / 2,
        path = roundedPoly([
          VertexDefinition(0, size.height), // bottom left
          VertexDefinition(size.width, size.height), // bottom right
          VertexDefinition(size.width / 2, 0, radius: 0), // top center
        ], borderRadius ?? size.width / 2);

  @override
  List<Object?> get props => [size, color, border, position, borderRadius];
}
