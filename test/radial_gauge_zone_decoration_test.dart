import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

void main() {
  Future<void> pumpGauge(
    WidgetTester tester, {
    required List<GaugeZone> zones,
  }) async {
    await tester.binding.setSurfaceSize(const Size(320, 200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFFFFFFFF),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: SizedBox(
                width: 280,
                height: 160,
                child: RadialGauge(
                  value: 0,
                  axis: GaugeAxis(
                    min: 0,
                    max: 100,
                    sweepDegrees: 180,
                    pointer: null,
                    progressBar: null,
                    style: const GaugeAxisStyle(
                      thickness: 22,
                      background: Color(0xFFE5E7EB),
                      cornerRadius: Radius.circular(11),
                    ),
                    zones: zones,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('zone with sweep gradient', (tester) async {
    await pumpGauge(
      tester,
      zones: const [
        GaugeZone(
          from: 0,
          to: 100,
          color: Color(0xFF000000),
          gradient: GaugeAxisGradient(
            colors: [
              Color(0xFFD50000),
              Color(0xFFFFEB3B),
              Color(0xFF00C853),
            ],
            colorStops: [0, 0.5, 1],
          ),
        ),
      ],
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_zone_gradient.png'),
    );
  });

  testWidgets('zones with border stroke', (tester) async {
    await pumpGauge(
      tester,
      zones: const [
        GaugeZone(
          from: 0,
          to: 33,
          color: Color(0xFFD50000),
          border: GaugeBorder(color: Color(0xFF000000), width: 2),
        ),
        GaugeZone(
          from: 34,
          to: 66,
          color: Color(0xFFFFEB3B),
          border: GaugeBorder(color: Color(0xFF000000), width: 2),
        ),
        GaugeZone(
          from: 67,
          to: 100,
          color: Color(0xFF00C853),
          border: GaugeBorder(color: Color(0xFF000000), width: 2),
        ),
      ],
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_zone_border.png'),
    );
  });
}
