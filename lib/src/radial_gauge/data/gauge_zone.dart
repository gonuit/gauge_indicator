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

  /// Creates a gauge zone.
  const GaugeZone({
    required this.from,
    required this.to,
    this.color = const Color(0x00000000),
    this.gradient,
    this.border,
    this.shader,
    this.cornerRadius = Radius.zero,
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
  }) =>
      GaugeZone(
        from: from ?? this.from,
        to: to ?? this.to,
        color: color ?? this.color,
        gradient: gradient ?? this.gradient,
        shader: shader ?? this.shader,
        border: border ?? this.border,
        cornerRadius: cornerRadius ?? this.cornerRadius,
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
      );

  @override
  List<Object?> get props =>
      [from, to, color, gradient, shader, cornerRadius, border];
}
