import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/src/internal.dart';

/// How a [GaugeProgressBar] is drawn relative to the axis segments.
enum GaugeProgressPlacement {
  /// The progress bar is drawn inside the gauge, clipped to the axis surface
  /// (and segments, if any).
  inside,

  /// The progress bar is drawn on top of the axis segments.
  over,
}

/// A progress indicator drawn along the gauge axis from [GaugeAxis.zero] to
/// the current value.
///
/// Use [GaugeProgressBar.basic] for flat ends and [GaugeProgressBar.rounded]
/// for rounded ends. Subclass to implement a custom shape — override [paint]
/// and [placement].
@immutable
abstract class GaugeProgressBar {
  /// Base constructor for subclasses.
  const GaugeProgressBar();

  /// {@template gauge_indicator.GaugeProgressBar.placement}
  /// How the progress bar is drawn relative to the axis segments. See
  /// [GaugeProgressPlacement].
  /// {@endtemplate}
  GaugeProgressPlacement get placement;

  /// Paints the progress bar on [canvas] for the given [layout].
  ///
  /// [from] is the normalised position of [GaugeAxis.zero] within the axis
  /// range; [progress] is the normalised position of the current value.
  void paint(
    GaugeAxis axis,
    RadialGaugeLayout layout,
    Canvas canvas,
    double from,
    double progress,
  );

  /// Creates a [GaugeRoundedProgressBar] — rounded ends. The cap radius
  /// shrinks for small arcs so the shape stays valid near zero.
  const factory GaugeProgressBar.rounded({
    Color? color,
    GaugeAxisGradient? gradient,
    Shader? shader,
    GaugeProgressPlacement placement,
  }) = GaugeRoundedProgressBar;

  /// Creates a [GaugeBasicProgressBar] — flat ends.
  const factory GaugeProgressBar.basic({
    Color? color,
    GaugeAxisGradient? gradient,
    Shader? shader,
    GaugeProgressPlacement placement,
  }) = GaugeBasicProgressBar;
}
