import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/src/internal.dart';

/// A triangular [GaugePointer] that points outward from the gauge center.
class TrianglePointer implements GaugePointer {
  /// Base width of the triangle in logical pixels.
  final double width;

  /// Height of the triangle (base to tip) in logical pixels.
  final double height;

  @override
  Size get size => Size(width, height);
  @override
  Path get path => roundedPoly([
    VertexDefinition(0, height), // bottom left
    VertexDefinition(width, height), // bottom right
    VertexDefinition(width / 2, 0), // top center
  ], borderRadius);

  /// {@macro gauge_indicator.GaugePointer.color}
  @override
  final Color? color;

  /// {@macro gauge_indicator.GaugePointer.position}
  @override
  final GaugePointerPosition position;

  /// {@macro gauge_indicator.GaugePointer.border}
  @override
  final GaugePointerBorder? border;

  /// Corner radius applied to the triangle's vertices.
  final double borderRadius;

  /// {@macro gauge_indicator.GaugePointer.gradient}
  @override
  final Gradient? gradient;

  /// {@macro gauge_indicator.GaugePointer.shadow}
  @override
  final Shadow? shadow;

  /// Creates a triangle pointer. Exactly one of [color] or [gradient]
  /// must be provided.
  const TrianglePointer({
    required this.width,
    required this.height,
    this.color,
    this.position = const GaugePointerPosition.surface(),
    this.borderRadius = 2,
    this.border,
    this.gradient,
    this.shadow,
  }) : assert(
         (color != null && gradient == null) ||
             (gradient != null && color == null),
         'Either color or gradient must be provided.',
       );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TrianglePointer &&
        runtimeType == other.runtimeType &&
        other.width == width &&
        other.height == height &&
        other.color == color &&
        other.border == border &&
        other.borderRadius == borderRadius &&
        other.position == position &&
        other.gradient == gradient &&
        other.shadow == shadow;
  }

  @override
  int get hashCode => Object.hash(
    width,
    height,
    color,
    border,
    borderRadius,
    position,
    gradient,
    shadow,
  );
}
