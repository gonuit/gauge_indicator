import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gauge_indicator/src/internal.dart';

/// A colored slice of the gauge axis spanning `[from, to]`.
///
/// Provide [color], [gradient], or [shader] to fill the zone. Use
/// [cornerRadius] for rounded edges and [border] for a stroke.
@immutable
class GaugeZone extends Equatable {
  /// Lower bound of the zone, in axis units.
  final double from;

  /// Upper bound of the zone, in axis units.
  final double to;

  /// Solid fill color.
  final Color color;

  /// Optional gradient applied across the zone along the arc.
  final GaugeAxisGradient? gradient;

  /// Optional border drawn around the zone.
  final GaugeBorder? border;

  /// Optional custom shader (e.g. a `FragmentShader`).
  final Shader? shader;

  /// Corner radius applied to the zone's ends.
  final Radius cornerRadius;

  /// Optional label drawn inside the zone band.
  final GaugeZoneLabel? label;

  /// Optional drop shadow drawn behind the zone fill. `spreadRadius` is
  /// ignored.
  final BoxShadow? shadow;

  /// Band width for this zone, in logical pixels. When null, fills the axis
  /// style thickness. Clamped to `[0, GaugeAxisStyle.thickness]` so the zone
  /// always fits inside the axis surface; smaller values produce a thinner
  /// zone centered within the band.
  final double? thickness;

  /// Creates a gauge zone.
  const GaugeZone({
    required this.from,
    required this.to,
    this.color = const Color(0x00000000),
    this.gradient,
    this.border,
    this.shader,
    this.cornerRadius = Radius.zero,
    this.label,
    this.shadow,
    this.thickness,
  });

  /// Returns a copy of this zone with the given fields replaced.
  GaugeZone copyWith({
    final double? from,
    final double? to,
    final Color? color,
    GaugeAxisGradient? gradient,
    Shader? shader,
    GaugeBorder? border,
    Radius? cornerRadius,
    GaugeZoneLabel? label,
    BoxShadow? shadow,
    double? thickness,
  }) =>
      GaugeZone(
        from: from ?? this.from,
        to: to ?? this.to,
        color: color ?? this.color,
        gradient: gradient ?? this.gradient,
        shader: shader ?? this.shader,
        border: border ?? this.border,
        cornerRadius: cornerRadius ?? this.cornerRadius,
        label: label ?? this.label,
        shadow: shadow ?? this.shadow,
        thickness: thickness ?? this.thickness,
      );

  /// Linearly interpolates between two zones at fraction [t].
  static GaugeZone lerp(GaugeZone begin, GaugeZone end, double t) =>
      GaugeZone(
        from: lerpDouble(begin.from, end.from, t),
        to: lerpDouble(begin.to, end.to, t),
        color: Color.lerp(begin.color, end.color, t)!,
        gradient: end.gradient,
        shader: end.shader,
        border: GaugeBorder.lerp(begin.border, end.border, t),
        cornerRadius: Radius.lerp(begin.cornerRadius, end.cornerRadius, t)!,
        label: end.label,
        shadow: BoxShadow.lerp(begin.shadow, end.shadow, t),
        thickness: begin.thickness == null && end.thickness == null
            ? null
            : lerpDouble(
                begin.thickness ?? end.thickness!,
                end.thickness ?? begin.thickness!,
                t,
              ),
      );

  @override
  List<Object?> get props => [
        from,
        to,
        color,
        gradient,
        shader,
        cornerRadius,
        border,
        label,
        shadow,
        thickness,
      ];
}
