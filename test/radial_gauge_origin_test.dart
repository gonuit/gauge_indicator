import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

void main() {
  Future<void> pumpGauge(WidgetTester tester, double value) async {
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
                  value: value,
                  axis: GaugeAxis(
                    min: -50,
                    max: 50,
                    origin: 0,
                    sweepDegrees: 180,
                    style: const GaugeAxisStyle(
                      thickness: 18,
                      background: Color(0xFFE5E7EB),
                      cornerRadius: Radius.circular(9),
                    ),
                    progressBar: const GaugeProgressBar.basic(
                      color: Color(0xFF00C853),
                    ),
                    zones: const [],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('Positive value fills from origin toward max', (tester) async {
    await pumpGauge(tester, 30);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_origin_centered.png'),
    );
  });

  testWidgets('Negative value fills from origin toward min', (tester) async {
    await pumpGauge(tester, -30);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_origin_centered_negative.png'),
    );
  });
}
