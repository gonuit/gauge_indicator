import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/src/internal.dart';

/// A radial gauge that draws a value along a circular axis.
///
/// The gauge is configured through a [GaugeAxis] (range, sweep, zones,
/// pointer, progress bar). The current [value] is drawn against that axis.
/// An optional [child] is centered inside the gauge for labels or icons.
///
/// For implicitly animated transitions between values, use
/// [AnimatedRadialGauge].
///
/// ```dart
/// RadialGauge(
///   value: 72,
///   axis: const GaugeAxis(
///     min: 0,
///     max: 100,
///     sweepDegrees: 270,
///     style: GaugeAxisStyle(
///       thickness: 14,
///       background: Color(0xFFDFE2EC),
///     ),
///     progressBar: GaugeProgressBar.rounded(color: Color(0xFF4CAF50)),
///   ),
///   child: const Text('72'),
/// )
/// ```
class RadialGauge extends SingleChildRenderObjectWidget {
  /// {@template gauge_indicator.RadialGauge.value}
  /// The value to display on the gauge. Clamped to the range defined by
  /// [GaugeAxis.min] and [GaugeAxis.max].
  /// {@endtemplate}
  final double value;

  /// {@template gauge_indicator.RadialGauge.radius}
  /// The outer radius of the gauge in logical pixels. When null, the gauge
  /// fills the available space while preserving its aspect ratio.
  /// {@endtemplate}
  final double? radius;

  /// {@template gauge_indicator.RadialGauge.axis}
  /// Configures the gauge's value range, sweep angle, visual style, zones,
  /// pointer, and progress bar. Only a single axis is supported.
  /// {@endtemplate}
  final GaugeAxis axis;

  /// {@template gauge_indicator.RadialGauge.alignment}
  /// How to position the gauge inside its allotted area when the available
  /// space is larger than the gauge.
  /// {@endtemplate}
  final Alignment alignment;

  /// {@template gauge_indicator.RadialGauge.debug}
  /// When true, the gauge paints colored overlays for its source, target, and
  /// circle rects to help diagnose layout issues.
  /// {@endtemplate}
  final bool debug;

  /// {@template gauge_indicator.RadialGauge.repaint}
  /// A [Listenable] that triggers a repaint whenever it notifies, without
  /// rebuilding the widget tree. Useful for driving shader uniforms or other
  /// paint-time state from an external ticker.
  /// {@endtemplate}
  final Listenable? repaint;

  /// Creates a radial gauge. [value] and [axis] are required.
  const RadialGauge({
    required this.value,
    required this.axis,
    this.radius,
    this.alignment = Alignment.center,
    this.debug = false,
    this.repaint,
    super.child,
    super.key,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RadialGaugeRenderBox(
      alignment: alignment,
      axis: axis,
      value: value,
      radius: radius,
      debug: debug,
      repaint: repaint,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RadialGaugeRenderBox renderObject,
  ) {
    renderObject
      ..alignment = alignment
      ..axis = axis
      ..value = value
      ..radius = radius
      ..debug = debug
      ..repaint = repaint;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('value', value));
    properties.add(DoubleProperty('radius', radius));
    properties.add(DiagnosticsProperty<GaugeAxis>('axis', axis));
    properties.add(DiagnosticsProperty<Alignment>('alignment', alignment));
    properties.add(DiagnosticsProperty<bool>('debug', debug));
    properties.add(DiagnosticsProperty<Listenable?>('repaint', repaint));
  }
}
