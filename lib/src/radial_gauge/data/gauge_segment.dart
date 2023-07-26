import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

@immutable
class GaugeSegment extends Equatable {
  final double from;
  final double to;
  final GaugeSegmentStyle style;

  const GaugeSegment({
    required this.from,
    required this.to,
    required this.style,
  });

  GaugeSegment copyWith({
    final double? from,
    final double? to,
    final Color? color,
    final GaugeSegmentStyle? style,
  }) =>
      GaugeSegment(
        from: from ?? this.from,
        to: to ?? this.to,
        style: style ?? this.style,
      );

  static GaugeSegment lerp(GaugeSegment begin, GaugeSegment end, double t) =>
      GaugeSegment(
        from: lerpDouble(begin.from, end.from, t),
        to: lerpDouble(begin.to, end.to, t),
        style: GaugeSegmentStyle.lerp(begin.style, end.style, t),
      );

  @override
  List<Object?> get props => [
        from,
        to,
        style,
      ];
}

class GaugeSegmentStyle {
  final Color? color;
  final GaugeAxisGradient? gradient;
  final GaugeBorder? border;
  final Shader? shader;
  final Radius? cornerRadius;
  final double? thickness;

  const GaugeSegmentStyle({
    this.color,
    this.gradient,
    this.border,
    this.shader,
    this.cornerRadius,
    this.thickness = 6.0,
  });

  // copyWith

  static GaugeSegmentStyle lerp(
    GaugeSegmentStyle begin,
    GaugeSegmentStyle end,
    double t,
  ) =>
      GaugeSegmentStyle(
        color: Color.lerp(begin.color, end.color, t),
        gradient: end.gradient,
        shader: end.shader,
        border: GaugeBorder.lerp(begin.border, end.border, t),
        cornerRadius: Radius.lerp(begin.cornerRadius, end.cornerRadius, t),
        thickness: lerpDouble(begin.thickness!, end.thickness!, t),
      );

  @override
  String toString() {
    return 'GaugeSegmentStyle{color: $color, gradient: $gradient, border: $border, shader: $shader, cornerRadius: $cornerRadius, thickness: $thickness}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GaugeSegmentStyle &&
          runtimeType == other.runtimeType &&
          color == other.color &&
          gradient == other.gradient &&
          border == other.border &&
          shader == other.shader &&
          cornerRadius == other.cornerRadius &&
          thickness == other.thickness;

  @override
  int get hashCode =>
      color.hashCode ^
      gradient.hashCode ^
      border.hashCode ^
      shader.hashCode ^
      cornerRadius.hashCode ^
      thickness.hashCode;

  GaugeSegmentStyle copyWith({
    Color? color,
    GaugeAxisGradient? gradient,
    GaugeBorder? border,
    Shader? shader,
    Radius? cornerRadius,
    double? thickness,
  }) =>
      GaugeSegmentStyle(
        color: color ?? this.color,
        gradient: gradient ?? this.gradient,
        border: border ?? this.border,
        shader: shader ?? this.shader,
        cornerRadius: cornerRadius ?? this.cornerRadius,
        thickness: thickness ?? this.thickness,
      );
}
