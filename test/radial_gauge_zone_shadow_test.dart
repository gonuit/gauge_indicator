import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

/// Golden coverage for [GaugeZone.shadow]. Uses sharp (zero-blur) offset
/// drop shadows in contrasting colors so a regression that drops the shadow
/// paint is unmistakable in the diff.
void main() {
  Future<void> pumpGauge(
    WidgetTester tester, {
    required Widget gauge,
    Size surfaceSize = const Size(320, 240),
  }) async {
    await tester.binding.setSurfaceSize(surfaceSize);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFFFFFFFF),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(child: gauge),
          ),
        ),
      ),
    );
  }

  testWidgets('Zone shadow: drop shadow', (tester) async {
    await pumpGauge(
      tester,
      gauge: const SizedBox(
        width: 260,
        height: 200,
        child: RadialGauge(
          value: 0,
          axis: GaugeAxis(
            min: 0,
            max: 100,
            sweepDegrees: 180,
            pointer: null,
            progressBar: null,
            style: GaugeAxisStyle(
              thickness: 24,
              background: Color(0xFFFFFFFF),
              cornerRadius: Radius.circular(12),
            ),
            zones: [
              GaugeZone(
                from: 0,
                to: 100,
                color: Color(0xFF2D9CDB),
                cornerRadius: Radius.circular(12),
                shadow: BoxShadow(
                  color: Color(0xFF000000),
                  blurRadius: 0,
                  offset: Offset(0, 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_zone_shadow.png'),
    );
  });

  testWidgets('Zone shadow: baseline (no shadow)', (tester) async {
    await pumpGauge(
      tester,
      gauge: const SizedBox(
        width: 260,
        height: 200,
        child: RadialGauge(
          value: 0,
          axis: GaugeAxis(
            min: 0,
            max: 100,
            sweepDegrees: 180,
            pointer: null,
            progressBar: null,
            style: GaugeAxisStyle(
              thickness: 24,
              background: Color(0xFFFFFFFF),
              cornerRadius: Radius.circular(12),
            ),
            zones: [
              GaugeZone(
                from: 0,
                to: 100,
                color: Color(0xFF2D9CDB),
                cornerRadius: Radius.circular(12),
              ),
            ],
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_zone_shadow_baseline.png'),
    );
  });

  testWidgets('Per-zone shadow colors', (tester) async {
    await pumpGauge(
      tester,
      surfaceSize: const Size(420, 260),
      gauge: const SizedBox(
        width: 360,
        height: 220,
        child: RadialGauge(
          value: 0,
          axis: GaugeAxis(
            min: 0,
            max: 100,
            sweepDegrees: 220,
            pointer: null,
            progressBar: null,
            style: GaugeAxisStyle(
              thickness: 22,
              background: Color(0xFFFFFFFF),
              zoneSpacing: 6,
              cornerRadius: Radius.circular(11),
            ),
            zones: [
              // Each zone uses a high-contrast solid drop shadow in a
              // different direction so per-zone wiring is verifiable.
              GaugeZone(
                from: 0,
                to: 33,
                color: Color(0xFF6FCF97),
                cornerRadius: Radius.circular(11),
                shadow: BoxShadow(
                  color: Color(0xFF000000),
                  blurRadius: 0,
                  offset: Offset(-8, 8),
                ),
              ),
              GaugeZone(
                from: 33,
                to: 66,
                color: Color(0xFFF2C94C),
                cornerRadius: Radius.circular(11),
                shadow: BoxShadow(
                  color: Color(0xFF000000),
                  blurRadius: 0,
                  offset: Offset(0, 12),
                ),
              ),
              GaugeZone(
                from: 66,
                to: 100,
                color: Color(0xFF000000),
                cornerRadius: Radius.circular(11),
                shadow: BoxShadow(
                  color: Color(0xFFEB5757),
                  blurRadius: 0,
                  offset: Offset(8, 8),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_zone_shadow_per_zone.png'),
    );
  });
}
