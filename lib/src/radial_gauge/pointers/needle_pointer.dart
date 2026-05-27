import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/src/internal.dart';

/// A tapered needle [GaugePointer] that points outward from the gauge
/// center at the current value.
class NeedlePointer implements GaugePointer {
  /// Base width of the needle in logical pixels.
  final double width;

  /// Length of the needle from base to tip in logical pixels.
  final double height;

  /// {@macro gauge_indicator.GaugePointer.position}
  @override
  final GaugePointerPosition position;

  /// {@macro gauge_indicator.GaugePointer.color}
  @override
  final Color? color;

  /// {@macro gauge_indicator.GaugePointer.border}
  @override
  final GaugePointerBorder? border;

  /// Corner radius applied to the needle's base. Defaults to half the
  /// [width] so the base is fully rounded.
  final double borderRadius;

  /// {@macro gauge_indicator.GaugePointer.gradient}
  @override
  final Gradient? gradient;

  /// {@macro gauge_indicator.GaugePointer.shadow}
  @override
  final Shadow? shadow;

  @override
  Size get size => Size(width, height);
  @override
  Path get path => roundedPoly([
    VertexDefinition(0, height), // bottom left
    VertexDefinition(width, height), // bottom right
    VertexDefinition(width / 2, 0, radius: 0), // top center
  ], borderRadius);

  /// Creates a needle pointer. Exactly one of [color] or [gradient] must
  /// be provided.
  const NeedlePointer({
    required this.width,
    required this.height,
    this.color,
    this.position = const GaugePointerPosition.center(),
    this.border,
    double? borderRadius,
    this.gradient,
    this.shadow,
  }) : borderRadius = borderRadius ?? width / 2,
       assert(
         (color != null && gradient == null) ||
             (gradient != null && color == null),
         'Either color or gradient must be provided.',
       );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NeedlePointer &&
        runtimeType == other.runtimeType &&
        other.width == width &&
        other.height == height &&
        other.color == color &&
        other.border == border &&
        other.position == position &&
        other.borderRadius == borderRadius &&
        other.gradient == gradient &&
        other.shadow == shadow;
  }

  @override
  int get hashCode => Object.hash(
    width,
    height,
    color,
    border,
    position,
    borderRadius,
    gradient,
    shadow,
  );
}
