import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

/// Renders a radial gauge.
class RadialGauge extends SingleChildRenderObjectWidget {
  final double value;
  final double? radius;

  /// For now we are only supporting single axis.
  final GaugeAxis axis;
  final Alignment alignment;
  final bool debug;

  const RadialGauge({
    required this.value,
    required this.axis,
    this.radius,
    this.alignment = Alignment.center,
    this.debug = false,
    Widget? child,
    Key? key,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RadialGaugeRenderBox(
      alignment: alignment,
      axis: axis,
      value: value,
      radius: radius,
      debug: debug,
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
      ..debug = debug;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('value', value));
    properties.add(DoubleProperty('radius', radius));
    properties.add(DiagnosticsProperty<GaugeAxis>('axis', axis));
    properties.add(DiagnosticsProperty<Alignment>('alignment', alignment));
    properties.add(DiagnosticsProperty<bool>('debug', debug));
  }
}
