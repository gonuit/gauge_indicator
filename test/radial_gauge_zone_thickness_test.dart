import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

/// Golden coverage for per-zone [GaugeZone.thickness]. Zones are clamped to
/// `[0, GaugeAxisStyle.thickness]` and centered on the axis centerline; null
/// fills the full surface.
void main() {
  Future<void> pumpGauge(
    WidgetTester tester, {
    required Widget gauge,
    Size surfaceSize = const Size(360, 240),
  }) async {
    await tester.binding.setSurfaceSize(surfaceSize);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFFFFFFFF),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(child: gauge),
          ),
        ),
      ),
    );
  }

  testWidgets('Zone thickness: de-emphasized middle zone', (tester) async {
    await pumpGauge(
      tester,
      gauge: const SizedBox(
        width: 300,
        height: 200,
        child: RadialGauge(
          value: 0,
          axis: GaugeAxis(
            min: 0,
            max: 100,
            sweepDegrees: 200,
            pointer: null,
            progressBar: null,
            style: GaugeAxisStyle(
              thickness: 24,
              background: Color(0xFFEEEEF2),
              zoneSpacing: 4,
              cornerRadius: Radius.circular(12),
            ),
            zones: [
              GaugeZone(
                from: 0,
                to: 33,
                color: Color(0xFF6FCF97),
                cornerRadius: Radius.circular(12),
              ),
              GaugeZone(
                from: 33,
                to: 66,
                color: Color(0xFFEB5757),
                cornerRadius: Radius.circular(4),
                thickness: 8,
              ),
              GaugeZone(
                from: 66,
                to: 100,
                color: Color(0xFF6FCF97),
                cornerRadius: Radius.circular(12),
              ),
            ],
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_zone_thickness_emphasis.png'),
    );
  });

  testWidgets('Zone thickness: descending profile', (tester) async {
    await pumpGauge(
      tester,
      gauge: const SizedBox(
        width: 320,
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
              thickness: 24,
              background: Color(0xFFEEEEF2),
              zoneSpacing: 4,
              cornerRadius: Radius.circular(12),
            ),
            zones: [
              GaugeZone(
                from: 0,
                to: 25,
                color: Color(0xFF2D9CDB),
                cornerRadius: Radius.circular(12),
                thickness: 24,
              ),
              GaugeZone(
                from: 25,
                to: 50,
                color: Color(0xFF2D9CDB),
                cornerRadius: Radius.circular(9),
                thickness: 18,
              ),
              GaugeZone(
                from: 50,
                to: 75,
                color: Color(0xFF2D9CDB),
                cornerRadius: Radius.circular(6),
                thickness: 12,
              ),
              GaugeZone(
                from: 75,
                to: 100,
                color: Color(0xFF2D9CDB),
                cornerRadius: Radius.circular(3),
                thickness: 6,
              ),
            ],
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_zone_thickness_ascending.png'),
    );
  });

  // Progress bar always uses GaugeAxisStyle.thickness — it does not adopt
  // per-zone thickness. With zones clamped ≤ surface, the progress fully
  // covers the surface band and zones sit within it.
  testWidgets('Zone thickness with progress bar inside', (tester) async {
    await pumpGauge(
      tester,
      surfaceSize: const Size(400, 280),
      gauge: const SizedBox(
        width: 340,
        height: 240,
        child: RadialGauge(
          value: 50,
          axis: GaugeAxis(
            min: 0,
            max: 100,
            sweepDegrees: 200,
            pointer: null,
            progressBar: GaugeProgressBar.basic(
              color: Color(0xFF193663),
              placement: GaugeProgressPlacement.inside,
            ),
            style: GaugeAxisStyle(
              thickness: 48,
              background: Color(0xFFEEEEF2),
              zoneSpacing: 4,
              cornerRadius: Radius.circular(24),
            ),
            zones: [
              // Inherits surface — fills the whole 48px band.
              GaugeZone(
                from: 0,
                to: 33,
                color: Color(0x806FCF97),
                cornerRadius: Radius.circular(24),
              ),
              GaugeZone(
                from: 33,
                to: 66,
                color: Color(0x80EB5757),
                cornerRadius: Radius.circular(4),
                thickness: 8,
              ),
              // Explicit 24 so it stays slim regardless of the surface.
              GaugeZone(
                from: 66,
                to: 100,
                color: Color(0x806FCF97),
                cornerRadius: Radius.circular(12),
                thickness: 24,
              ),
            ],
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(
        'goldens/radial_gauge_zone_thickness_progress_inside.png',
      ),
    );
  });

  testWidgets('Zone thickness with progress bar over', (tester) async {
    await pumpGauge(
      tester,
      gauge: const SizedBox(
        width: 300,
        height: 200,
        child: RadialGauge(
          value: 50,
          axis: GaugeAxis(
            min: 0,
            max: 100,
            sweepDegrees: 200,
            pointer: null,
            progressBar: GaugeProgressBar.basic(
              color: Color(0xFF193663),
              placement: GaugeProgressPlacement.over,
            ),
            style: GaugeAxisStyle(
              thickness: 24,
              background: Color(0xFFEEEEF2),
              zoneSpacing: 4,
              cornerRadius: Radius.circular(12),
            ),
            zones: [
              GaugeZone(
                from: 0,
                to: 33,
                color: Color(0xFF6FCF97),
                cornerRadius: Radius.circular(12),
              ),
              GaugeZone(
                from: 33,
                to: 66,
                color: Color(0xFFEB5757),
                cornerRadius: Radius.circular(4),
                thickness: 8,
              ),
              GaugeZone(
                from: 66,
                to: 100,
                color: Color(0xFF6FCF97),
                cornerRadius: Radius.circular(12),
              ),
            ],
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(
        'goldens/radial_gauge_zone_thickness_progress_over.png',
      ),
    );
  });

  testWidgets('Zone thickness: baseline (all inherit)', (tester) async {
    await pumpGauge(
      tester,
      gauge: const SizedBox(
        width: 300,
        height: 200,
        child: RadialGauge(
          value: 0,
          axis: GaugeAxis(
            min: 0,
            max: 100,
            sweepDegrees: 200,
            pointer: null,
            progressBar: null,
            style: GaugeAxisStyle(
              thickness: 24,
              background: null,
              zoneSpacing: 4,
              cornerRadius: Radius.circular(12),
            ),
            zones: [
              GaugeZone(
                from: 0,
                to: 33,
                color: Color(0xFF6FCF97),
                cornerRadius: Radius.circular(12),
              ),
              GaugeZone(
                from: 33,
                to: 66,
                color: Color(0xFFEB5757),
                cornerRadius: Radius.circular(12),
              ),
              GaugeZone(
                from: 66,
                to: 100,
                color: Color(0xFF6FCF97),
                cornerRadius: Radius.circular(12),
              ),
            ],
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_zone_thickness_baseline.png'),
    );
  });
}
