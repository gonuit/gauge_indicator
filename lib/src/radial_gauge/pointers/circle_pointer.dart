import 'package:gauge_indicator/src/internal.dart';
import 'package:flutter/widgets.dart';

/// A circular [GaugePointer] that marks the current value with a filled
/// circle.
class CirclePointer implements GaugePointer {
  /// Radius of the circle in logical pixels.
  final double radius;

  /// {@macro gauge_indicator.GaugePointer.position}
  @override
  final GaugePointerPosition position;

  /// {@macro gauge_indicator.GaugePointer.color}
  @override
  final Color? color;

  /// {@macro gauge_indicator.GaugePointer.border}
  @override
  final GaugePointerBorder? border;

  /// {@macro gauge_indicator.GaugePointer.gradient}
  @override
  final Gradient? gradient;

  /// {@macro gauge_indicator.GaugePointer.shadow}
  @override
  final Shadow? shadow;

  @override
  Size get size => Size.fromRadius(radius);
  @override
  Path get path => Path()
    ..addOval(Rect.fromCircle(center: Offset(radius, radius), radius: radius));

  /// Creates a circle pointer. Exactly one of [color] or [gradient] must
  /// be provided.
  const CirclePointer({
    required this.radius,
    this.color,
    this.position = const GaugePointerPosition.surface(),
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
    return other is CirclePointer &&
        runtimeType == other.runtimeType &&
        other.radius == radius &&
        other.color == color &&
        other.border == border &&
        other.position == position &&
        other.gradient == gradient &&
        other.shadow == shadow;
  }

  @override
  int get hashCode =>
      Object.hash(radius, color, border, position, gradient, shadow);
}
