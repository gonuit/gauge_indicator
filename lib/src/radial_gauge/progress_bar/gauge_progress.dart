import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

/// Describes how the progress bar will be rendered.
/// [inside] or [over] the axis segments.
enum GaugeProgressPlacement {
  /// The progress bar will be displayed inside the axis segments.
  inside,

  /// A progress bar will be displayed on top the axis segments.
  over,
}

@immutable
abstract class GaugeProgressBar {
  const GaugeProgressBar();

  /// Describes how the progress bar will be rendered.
  GaugeProgressPlacement get placement;

  void paint(
    GaugeAxis axis,
    RadialGaugeLayout layout,
    Canvas canvas,
    double from,
    double progress,
  );

  /// A progress bar that is rounded at both ends
  const factory GaugeProgressBar.rounded({
    Color? color,
    GaugeAxisGradient? gradient,
    Shader? shader,
    GaugeProgressPlacement placement,
  }) = GaugeRoundedProgressBar;

  /// A basic progress bar with no rounding at the ends
  const factory GaugeProgressBar.basic({
    Color? color,
    GaugeAxisGradient? gradient,
    Shader? shader,
    GaugeProgressPlacement placement,
  }) = GaugeBasicProgressBar;
}
