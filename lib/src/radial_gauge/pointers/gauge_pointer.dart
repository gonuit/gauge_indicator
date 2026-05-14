import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'needle_pointer.dart';
import 'circle_pointer.dart';
import 'triangle_pointer.dart';

/// Where a [GaugePointer] is anchored relative to the gauge.
///
/// Used by [GaugePointerPosition] and [GaugePointer].
enum GaugePointerAnchor {
  /// The pointer is placed in the center of the indicator widget.
  center,

  /// The pointer is positioned above the surface of the indicator zones.
  surface,
}

/// Describes the pointer position with [anchor] and [offset].
class GaugePointerPosition extends Equatable {
  /// Position in which the indicator is anchored.
  final GaugePointerAnchor anchor;

  /// The offset of the indicator in x,y coordinates.
  ///
  /// This is applied before the indicator is rotated. Defaults to
  /// [Offset.zero].
  final Offset offset;

  /// Creates a pointer position with the given [anchor] and [offset].
  const GaugePointerPosition({
    this.anchor = GaugePointerAnchor.surface,
    this.offset = Offset.zero,
  });

  /// Places the pointer in the center of the indicator widget.
  const GaugePointerPosition.center({
    this.offset = Offset.zero,
  }) : anchor = GaugePointerAnchor.center;

  /// Places the pointer above the surface of the indicator zones.
  ///
  /// Use [offset] to push the pointer above or below the zones — for
  /// instance, by the axis thickness:
  /// ```dart
  /// GaugePointerPosition.surface(
  ///   offset: Offset(0.0, axisThickness),  // below the zones
  /// );
  /// GaugePointerPosition.surface(
  ///   offset: Offset(0.0, -axisThickness), // above the zones
  /// )
  /// ```
  const GaugePointerPosition.surface({
    this.offset = Offset.zero,
  }) : anchor = GaugePointerAnchor.surface;

  @override
  List<Object?> get props => [anchor, offset];
}

/// A stroke painted around a [GaugePointer].
@immutable
class GaugePointerBorder extends Equatable {
  /// The stroke color.
  final Color color;

  /// The stroke width in logical pixels. Must be greater than 0.
  final double width;

  /// Creates a pointer border with the given [color] and [width].
  const GaugePointerBorder({
    required this.color,
    required this.width,
  }) : assert(width > 0, 'Width must be larger than 0.');

  @override
  List<Object?> get props => [color, width];
}

/// A pointer drawn on the gauge at the current value.
///
/// Subclass to build a custom pointer by providing a [path] and [size]. Use
/// the factory constructors ([GaugePointer.needle], [GaugePointer.triangle],
/// [GaugePointer.circle]) for the built-in shapes.
@immutable
abstract class GaugePointer {
  /// The pointer's outline. Drawn rotated to face the current value.
  Path get path;

  /// The intrinsic size of the [path].
  Size get size;

  /// {@template gauge_indicator.GaugePointer.position}
  /// Where the pointer is anchored (gauge center or axis surface) and its
  /// offset from that anchor.
  /// {@endtemplate}
  GaugePointerPosition get position;

  /// {@template gauge_indicator.GaugePointer.color}
  /// Fill color of the pointer. Either [color] or [gradient] must be set.
  /// {@endtemplate}
  Color? get color;

  /// {@template gauge_indicator.GaugePointer.gradient}
  /// Gradient fill of the pointer. Either [color] or [gradient] must be set.
  /// {@endtemplate}
  Gradient? get gradient;

  /// {@template gauge_indicator.GaugePointer.shadow}
  /// Optional drop shadow painted behind the pointer. When null, no shadow is
  /// rendered.
  /// {@endtemplate}
  Shadow? get shadow;

  /// {@template gauge_indicator.GaugePointer.border}
  /// Optional stroke painted around the pointer. When null, no border is
  /// rendered.
  /// {@endtemplate}
  GaugePointerBorder? get border;

  /// Creates a [NeedlePointer] — a tapered needle pointing outward.
  const factory GaugePointer.needle({
    required double width,
    required double height,
    required Color color,
    GaugePointerPosition position,
    GaugePointerBorder? border,
    double? borderRadius,
    Gradient? gradient,
    Shadow? shadow,
  }) = NeedlePointer;

  /// Creates a [CirclePointer] — a filled circle marker.
  const factory GaugePointer.circle({
    required double radius,
    Color? color,
    GaugePointerPosition position,
    GaugePointerBorder? border,
    Gradient? gradient,
    Shadow? shadow,
  }) = CirclePointer;

  /// Creates a [TrianglePointer] — a triangular marker.
  const factory GaugePointer.triangle({
    required double width,
    required double height,
    Color? color,
    GaugePointerPosition position,
    GaugePointerBorder? border,
    double borderRadius,
    Gradient? gradient,
    Shadow? shadow,
  }) = TrianglePointer;
}
