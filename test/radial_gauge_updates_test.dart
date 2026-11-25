import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:gauge_indicator/src/radial_gauge/widgets/radial_gauge_render_box.dart';

RadialGaugeRenderBox _renderBox(WidgetTester tester) =>
    tester.renderObject<RadialGaugeRenderBox>(find.byType(RadialGauge));

void main() {
  testWidgets('RadialGauge applies a changed axis range', (tester) async {
    Widget build(double max) => Center(
      child: SizedBox(
        width: 200,
        child: RadialGauge(value: 50, axis: GaugeAxis(max: max)),
      ),
    );

    await tester.pumpWidget(build(100));
    await tester.pumpWidget(build(200));

    expect(_renderBox(tester).axis.max, 200);
  });

  testWidgets('AnimatedRadialGauge applies a changed axis range', (
    tester,
  ) async {
    Widget build(double max) => Center(
      child: SizedBox(
        width: 200,
        child: AnimatedRadialGauge(
          duration: const Duration(milliseconds: 100),
          value: 50,
          axis: GaugeAxis(max: max),
        ),
      ),
    );

    await tester.pumpWidget(build(100));
    await tester.pumpAndSettle();
    await tester.pumpWidget(build(200));
    await tester.pumpAndSettle();

    expect(_renderBox(tester).axis.max, 200);
  });

  testWidgets('AnimatedRadialGauge applies a changed transformer', (
    tester,
  ) async {
    Widget build(GaugeAxisTransformer transformer) => Center(
      child: SizedBox(
        width: 200,
        child: AnimatedRadialGauge(
          duration: const Duration(milliseconds: 100),
          value: 0.5,
          axis: GaugeAxis(transformer: transformer),
        ),
      ),
    );

    await tester.pumpWidget(build(const GaugeAxisTransformer.noTransform()));
    await tester.pumpAndSettle();
    expect(_renderBox(tester).axis.zones, isEmpty);

    await tester.pumpWidget(
      build(const GaugeAxisTransformer.progress(color: Color(0xFF2196F3))),
    );
    await tester.pumpAndSettle();

    expect(_renderBox(tester).axis.zones, hasLength(1));
  });

  testWidgets('AnimatedRadialGauge accepts a radius after having none', (
    tester,
  ) async {
    Widget build(double? radius) => Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: AnimatedRadialGauge(
          duration: const Duration(milliseconds: 100),
          value: 0.5,
          radius: radius,
        ),
      ),
    );

    await tester.pumpWidget(build(null));
    await tester.pumpAndSettle();
    await tester.pumpWidget(build(50));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(_renderBox(tester).radius, 50);

    await tester.pumpWidget(build(null));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(_renderBox(tester).radius, isNull);
  });
}
