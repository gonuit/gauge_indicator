import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

void main() {
  Future<void> pumpGauge(
    WidgetTester tester, {
    required double sweepDegrees,
    required double value,
    required Size surface,
    required Size content,
  }) async {
    await tester.binding.setSurfaceSize(surface);
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
                width: content.width,
                height: content.height,
                child: RadialGauge(
                  value: value,
                  axis: GaugeAxis(
                    min: 0,
                    max: 100,
                    sweepDegrees: sweepDegrees,
                    style: const GaugeAxisStyle(
                      thickness: 18,
                      background: Color(0xFFE5E7EB),
                      cornerRadius: Radius.circular(9),
                    ),
                    progressBar: const GaugeProgressBar.rounded(
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

  testWidgets('sweepDegrees: 90 renders a narrow arc', (tester) async {
    await pumpGauge(
      tester,
      sweepDegrees: 90,
      value: 60,
      surface: const Size(240, 240),
      content: const Size(200, 200),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_sweep_90.png'),
    );
  });

  testWidgets('sweepDegrees: 270 renders a three-quarter arc', (tester) async {
    await pumpGauge(
      tester,
      sweepDegrees: 270,
      value: 50,
      surface: const Size(280, 280),
      content: const Size(240, 240),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_sweep_270.png'),
    );
  });

  testWidgets('sweepDegrees: 360 tapers caps near the seam at high progress', (
    tester,
  ) async {
    await pumpGauge(
      tester,
      sweepDegrees: 360,
      value: 90,
      surface: const Size(280, 280),
      content: const Size(240, 240),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_sweep_360.png'),
    );
  });
}
