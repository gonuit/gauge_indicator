import 'dart:ui';

import 'package:gauge_indicator/gauge_indicator.dart';

class NeedlePointer extends GaugePointer {
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
  final double borderRadius;

  NeedlePointer({
    required this.size,
    required this.backgroundColor,
    this.position = const GaugePointerPosition.center(),
    this.border,
    this.borderRadius = 4,
  }) : path = roundedPoly([
          VertexDefinition(0, size.height), // bottom left
          VertexDefinition(size.width, size.height), // bottom right
          VertexDefinition(size.width / 2, 0, radius: 0), // top center
        ], borderRadius);

  @override
  List<Object?> get props => [size, backgroundColor, border, position];
}
