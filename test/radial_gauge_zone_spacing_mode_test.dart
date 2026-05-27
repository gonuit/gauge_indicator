import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

/// Visualises how [ZoneSpacingMode] handles narrow zones. The same row of
/// four gauges is rendered twice — once with [ZoneSpacingMode.uniform], once
/// with [ZoneSpacingMode.local] — so the difference is inspectable side by
/// side in the goldens.
///
/// Gauge layouts (left → right):
///  1. Four equal zones (baseline — both modes look the same).
///  2. One narrow zone in the middle.
///  3. One very narrow zone at the start.
///  4. One very narrow zone at the end.
void main() {
  Future<void> pumpRow(WidgetTester tester, ZoneSpacingMode mode) async {
    await tester.binding.setSurfaceSize(const Size(880, 200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    Widget gauge(List<GaugeZone> zones, {double zoneSpacing = 5}) => SizedBox(
      width: 200,
      height: 140,
      child: RadialGauge(
        value: 0,
        axis: GaugeAxis(
          min: 0,
          max: 100,
          sweepDegrees: 180,
          pointer: null,
          progressBar: null,
          style: GaugeAxisStyle(
            thickness: 18,
            background: const Color(0xFF000000),
            cornerRadius: const Radius.circular(9),
            zoneSpacing: zoneSpacing,
            zoneSpacingMode: mode,
          ),
          zones: zones,
        ),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFFFFFFFF),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                gauge(const [
                  GaugeZone(from: 0, to: 25, color: Color(0xFF6FCF97)),
                  GaugeZone(from: 25, to: 50, color: Color(0xFFF2C94C)),
                  GaugeZone(from: 50, to: 75, color: Color(0xFFEB5757)),
                  GaugeZone(from: 75, to: 100, color: Color(0xFF2D9CDB)),
                ]),
                gauge(const [
                  GaugeZone(from: 0, to: 30, color: Color(0xFF6FCF97)),
                  GaugeZone(from: 30, to: 50, color: Color(0xFFF2C94C)),
                  GaugeZone(from: 50, to: 51, color: Color(0xFFEB5757)),
                  GaugeZone(from: 51, to: 100, color: Color(0xFF2D9CDB)),
                ], zoneSpacing: 10),
                gauge(const [
                  GaugeZone(from: 0, to: 4, color: Color(0xFF6FCF97)),
                  GaugeZone(from: 4, to: 36, color: Color(0xFFF2C94C)),
                  GaugeZone(from: 36, to: 68, color: Color(0xFFEB5757)),
                  GaugeZone(from: 68, to: 100, color: Color(0xFF2D9CDB)),
                ], zoneSpacing: 15),
                gauge(const [
                  GaugeZone(from: 0, to: 32, color: Color(0xFF6FCF97)),
                  GaugeZone(from: 32, to: 64, color: Color(0xFFF2C94C)),
                  GaugeZone(from: 64, to: 96, color: Color(0xFFEB5757)),
                  GaugeZone(from: 96, to: 100, color: Color(0xFF2D9CDB)),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('Zone spacing mode: uniform — narrow zone tightens every gap', (
    tester,
  ) async {
    await pumpRow(tester, ZoneSpacingMode.uniform);

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_zone_spacing_uniform.png'),
    );
  });

  testWidgets('Zone spacing mode: local — only adjacent gaps tighten', (
    tester,
  ) async {
    await pumpRow(tester, ZoneSpacingMode.local);

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_zone_spacing_local.png'),
    );
  });
}
