import 'package:equatable/equatable.dart';
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
abstract class GaugeProgressBar extends Equatable {
  const GaugeProgressBar();

  /// Describes how the progress bar will be rendered.
  GaugeProgressPlacement get placement;

  void paint(
    GaugeAxis axis,
    RadialGaugeLayout layout,
    Canvas canvas,
    double progress,
  );
}
