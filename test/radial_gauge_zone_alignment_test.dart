import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

/// Reproduces the alignment concerns reported on
/// https://github.com/gonuit/gauge_indicator/issues/6 — zone caps tracing
/// the axis background and the rounded progress fill aligning inside the
/// zones when `placement: inside` is used.
void main() {
  testWidgets(
    'Zones align with axis background, rounded inside progress fits',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(488, 280));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: Color(0xFFFFFFFF),
            body: Padding(
              padding: EdgeInsets.all(24),
              child: SizedBox(
                width: 440,
                height: 232,
                child: RadialGauge(
                  value: 70,
                  axis: GaugeAxis(
                    min: 0,
                    max: 100,
                    sweepDegrees: 180,
                    style: GaugeAxisStyle(
                      thickness: 24,
                      zoneSpacing: 8,
                      blendColors: false,
                      cornerRadius: Radius.circular(20),
                      background: Color(0xFFFF00FF),
                    ),
                    progressBar: GaugeProgressBar.rounded(
                      placement: GaugeProgressPlacement.inside,
                      gradient: GaugeAxisGradient(
                        colors: [
                          Color(0xFF00C853),
                          Color(0xFFFFEB3B),
                          Color(0xFFD50000),
                        ],
                        colorStops: [0, 0.5, 1],
                      ),
                    ),
                    zones: [
                      GaugeZone(
                        from: 0,
                        to: 20,
                        color: Color(0xFFCCCCCC),
                        cornerRadius: Radius.circular(10),
                      ),
                      GaugeZone(
                        from: 20,
                        to: 40,
                        color: Color(0xFFCCCCCC),
                        cornerRadius: Radius.circular(10),
                      ),
                      GaugeZone(
                        from: 40,
                        to: 60,
                        color: Color(0xFFCCCCCC),
                        cornerRadius: Radius.circular(10),
                      ),
                      GaugeZone(
                        from: 60,
                        to: 80,
                        color: Color(0xFFCCCCCC),
                        cornerRadius: Radius.circular(10),
                      ),
                      GaugeZone(
                        from: 80,
                        to: 100,
                        color: Color(0xFFCCCCCC),
                        cornerRadius: Radius.circular(10),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/radial_gauge_zone_alignment.png'),
      );
    },
  );
}
