import 'dart:ui' as ui;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class GaugeBasicProgressBar extends Equatable implements GaugeProgressBar {
  final Color? color;
  final GaugeAxisGradient? gradient;
  final Shader? shader;
  @override
  final GaugeProgressPlacement placement;

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
      degrees: axis.degrees,
      thickness: axis.style.thickness,
    );

    final paint = Paint()..style = PaintingStyle.fill;

    if (shader != null) {
      paint.shader = shader!;
    } else if (gradient != null) {
      const rotationDifference = 270;
      final degrees = axis.degrees.clamp(10.0, 360.0);
      final rotationAngle = toRadians(rotationDifference - degrees / 2);

      paint.shader = ui.Gradient.sweep(
        layout.circleRect.center,
        gradient!.colors,
        gradient!.colorStops,
        gradient!.tileMode,
        0.0,
        toRadians(axis.degrees),
        GradientRotation(rotationAngle).transform(layout.circleRect).storage,
      );
    } else if (color != null) {
      paint.color = color!;
    }

    canvas.drawPath(progressBar, paint);
  }

  @override
  List<Object?> get props => [color, gradient, shader, placement];
}
