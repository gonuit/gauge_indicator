import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gauge_indicator/src/internal.dart';

/// A [GaugeProgressBar] with flat ends.
///
/// Exactly one of [color], [gradient], or [shader] must be provided.
///
/// ```dart
/// GaugeProgressBar.basic(color: Colors.blue)
/// ```
class GaugeBasicProgressBar implements GaugeProgressBar {
  /// {@template gauge_indicator.GaugeProgressBar.color}
  /// Solid fill color. Mutually exclusive with [gradient] and [shader].
  /// {@endtemplate}
  final Color? color;

  /// {@template gauge_indicator.GaugeProgressBar.gradient}
  /// Sweep gradient applied along the arc. Mutually exclusive with [color]
  /// and [shader].
  /// {@endtemplate}
  final GaugeAxisGradient? gradient;

  /// {@template gauge_indicator.GaugeProgressBar.shader}
  /// Custom shader used for the fill (e.g. a `FragmentShader`). Mutually
  /// exclusive with [color] and [gradient].
  /// {@endtemplate}
  final Shader? shader;

  /// {@macro gauge_indicator.GaugeProgressBar.placement}
  @override
  final GaugeProgressPlacement placement;

  /// Creates a basic progress bar. Provide exactly one of [color],
  /// [gradient], or [shader].
  const GaugeBasicProgressBar({
    this.color,
    this.gradient,
    this.shader,
    this.placement = GaugeProgressPlacement.over,
  }) : assert(
         color != null || gradient != null || shader != null,
         'color, gradient or shader is required',
       );

  @override
  void paint(
    GaugeAxis axis,
    RadialGaugeLayout layout,
    Canvas canvas,
    double from,
    double progress,
  ) {
    final progressBar = calculateAxisPath(
      layout.circleRect,
      from: from,
      to: progress,
      degrees: axis.sweepDegrees,
      thickness: axis.style.thickness,
    );

    final paint = Paint()..style = PaintingStyle.fill;

    if (shader != null) {
      paint.shader = shader!;
    } else if (gradient != null) {
      const rotationDifference = 270;
      final degrees = axis.sweepDegrees.clamp(10.0, 360.0);
      final rotationAngle = toRadians(rotationDifference - degrees / 2);

      paint.shader = ui.Gradient.sweep(
        layout.circleRect.center,
        gradient!.colors,
        gradient!.colorStops,
        gradient!.tileMode,
        0.0,
        toRadians(axis.sweepDegrees),
        GradientRotation(rotationAngle).transform(layout.circleRect).storage,
      );
    } else if (color != null) {
      paint.color = color!;
    }

    canvas.drawPath(progressBar, paint);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GaugeBasicProgressBar &&
        runtimeType == other.runtimeType &&
        other.color == color &&
        other.gradient == gradient &&
        other.shader == shader &&
        other.placement == placement;
  }

  @override
  int get hashCode => Object.hash(color, gradient, shader, placement);
}
