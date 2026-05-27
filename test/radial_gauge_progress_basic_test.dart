import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

void main() {
  Future<void> pumpGauge(
    WidgetTester tester, {
    required double value,
    required GaugeProgressBar progressBar,
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
                  value: value,
                  axis: GaugeAxis(
                    min: 0,
                    max: 100,
                    sweepDegrees: 180,
                    style: const GaugeAxisStyle(
                      thickness: 18,
                      background: Color(0xFFE5E7EB),
                      cornerRadius: Radius.circular(9),
                    ),
                    progressBar: progressBar,
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

  testWidgets('basic progress at value 0 paints nothing on the bar', (
    tester,
  ) async {
    await pumpGauge(
      tester,
      value: 0,
      progressBar: const GaugeProgressBar.basic(color: Color(0xFF00C853)),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_progress_basic_0.png'),
    );
  });

  testWidgets('basic progress at value 50 fills half the arc', (tester) async {
    await pumpGauge(
      tester,
      value: 50,
      progressBar: const GaugeProgressBar.basic(color: Color(0xFF00C853)),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_progress_basic_50.png'),
    );
  });

  testWidgets('basic progress at value 100 fills the full arc', (tester) async {
    await pumpGauge(
      tester,
      value: 100,
      progressBar: const GaugeProgressBar.basic(color: Color(0xFF00C853)),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_progress_basic_100.png'),
    );
  });

  testWidgets('basic progress with sweep gradient', (tester) async {
    await pumpGauge(
      tester,
      value: 70,
      progressBar: const GaugeProgressBar.basic(
        gradient: GaugeAxisGradient(
          colors: [Color(0xFF00C853), Color(0xFFFFEB3B), Color(0xFFD50000)],
          colorStops: [0, 0.5, 1],
        ),
      ),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_progress_basic_gradient.png'),
    );
  });
}
