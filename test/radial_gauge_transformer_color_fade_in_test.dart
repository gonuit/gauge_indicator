import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

void main() {
  testWidgets('colorFadeIn at 50% of the initial animation', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    const duration = Duration(milliseconds: 800);

    await tester.pumpWidget(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Color(0xFFFFFFFF),
          body: Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: SizedBox(
                width: 280,
                height: 160,
                child: AnimatedRadialGauge(
                  duration: duration,
                  value: 100,
                  axis: GaugeAxis(
                    min: 0,
                    max: 100,
                    sweepDegrees: 180,
                    pointer: null,
                    progressBar: null,
                    style: GaugeAxisStyle(
                      thickness: 22,
                      background: Color(0xFFE5E7EB),
                      cornerRadius: Radius.circular(11),
                    ),
                    transformer: GaugeAxisTransformer.colorFadeIn(
                      interval: Interval(0, 1),
                      background: Color(0xFFE5E7EB),
                    ),
                    zones: [
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

    await tester.pump(duration ~/ 2);

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_color_fade_in_mid.png'),
    );
  });
}
