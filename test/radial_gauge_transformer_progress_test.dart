import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

void main() {
  Future<void> pumpGauge(
    WidgetTester tester, {
    required GaugeAxisTransformer transformer,
    bool blendColors = false,
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
                child: AnimatedRadialGauge(
                  duration: const Duration(milliseconds: 200),
                  value: 60,
                  axis: GaugeAxis(
                    min: 0,
                    max: 100,
                    sweepDegrees: 180,
                    pointer: null,
                    progressBar: null,
                    style: GaugeAxisStyle(
                      thickness: 22,
                      background: const Color(0xFFE5E7EB),
                      cornerRadius: const Radius.circular(11),
                      blendColors: blendColors,
                    ),
                    transformer: transformer,
                    zones: const [
                      GaugeZone(from: 0, to: 33, color: Color(0xFFD50000)),
                      GaugeZone(from: 34, to: 66, color: Color(0xFFFFEB3B)),
                      GaugeZone(from: 67, to: 100, color: Color(0xFF00C853)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  testWidgets('progress transformer recolors [origin, value]', (tester) async {
    await pumpGauge(
      tester,
      transformer: const GaugeAxisTransformer.progress(
        color: Color(0xFF1976D2),
      ),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(
          'goldens/radial_gauge_progress_transformer_default.png'),
    );
  });

  testWidgets(
      'progress transformer with reversed: true recolors the upper side',
      (tester) async {
    await pumpGauge(
      tester,
      transformer: const GaugeAxisTransformer.progress(
        color: Color(0xFF1976D2),
        reversed: true,
      ),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(
          'goldens/radial_gauge_progress_transformer_reversed.png'),
    );
  });

  testWidgets('progress transformer with blendColors: true', (tester) async {
    await pumpGauge(
      tester,
      blendColors: true,
      transformer: const GaugeAxisTransformer.progress(
        color: Color(0xFF1976D2),
        blendColors: true,
      ),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(
          'goldens/radial_gauge_progress_transformer_blended.png'),
    );
  });
}
