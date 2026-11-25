import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:gauge_indicator/src/internal.dart';

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
}
