import 'package:equatable/equatable.dart';
import 'package:gauge_indicator/src/internal.dart';
import 'package:flutter/widgets.dart';

/// A circular [GaugePointer] that marks the current value with a filled
/// circle.
class CirclePointer extends Equatable implements GaugePointer {
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
    ..addOval(Rect.fromCircle(
      center: Offset(radius, radius),
      radius: radius,
    ));

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
  List<Object?> get props => [size, color, border, position, gradient, shadow];
}
