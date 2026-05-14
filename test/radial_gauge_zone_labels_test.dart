import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

/// Golden coverage for [GaugeZoneLabel] rendering inside zones.
///
/// Each test renders a row of small gauges so several cases land in one
/// golden image:
///  1. Alignment — `start`, `center`, `end` anchor positions.
///  2. Radial alignment — `-1` (inner edge), `0` (centerline), `+1` (outer).
///  3. Content variants — text only, icon only, icon + text, and a long
///     label clipped at a narrow zone boundary.
void main() {
  const labelStyle = TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  Future<void> pumpRow(
    WidgetTester tester, {
    required List<Widget> gauges,
    Size surfaceSize = const Size(900, 220),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: gauges,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('Zone label alignment: start, center, end', (tester) async {
    Widget gauge(GaugeZoneLabelAlignment alignment) => SizedBox(
          width: 260,
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
                thickness: 26,
                background: Color(0xFFEEEEF2),
                zoneSpacing: 4,
                cornerRadius: Radius.circular(6),
              ),
              zones: [
                GaugeZone(
                  from: 0,
                  to: 50,
                  color: const Color(0xFF6FCF97),
                  label: GaugeZoneLabel(
                    text: 'LOW',
                    style: labelStyle,
                    alignment: alignment,
                    padding: 6,
                  ),
                ),
                GaugeZone(
                  from: 50,
                  to: 100,
                  color: const Color(0xFFEB5757),
                  label: GaugeZoneLabel(
                    text: 'HIGH',
                    style: labelStyle,
                    alignment: alignment,
                    padding: 6,
                  ),
                ),
              ],
            ),
          ),
        );

    await pumpRow(tester, gauges: [
      gauge(GaugeZoneLabelAlignment.start),
      gauge(GaugeZoneLabelAlignment.center),
      gauge(GaugeZoneLabelAlignment.end),
    ]);

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_zone_labels_alignment.png'),
    );
  });

  testWidgets('Zone label radial alignment: inner, centerline, outer',
      (tester) async {
    Widget gauge(double radialAlignment) => SizedBox(
          width: 260,
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
                thickness: 36,
                background: Color(0xFFEEEEF2),
                zoneSpacing: 4,
                cornerRadius: Radius.circular(8),
              ),
              zones: [
                GaugeZone(
                  from: 0,
                  to: 100,
                  color: const Color(0xFF2D9CDB),
                  label: GaugeZoneLabel(
                    text: 'EDGE',
                    style: labelStyle,
                    radialAlignment: radialAlignment,
                  ),
                ),
              ],
            ),
          ),
        );

    await pumpRow(tester, gauges: [
      gauge(-1.0),
      gauge(0.0),
      gauge(1.0),
    ]);

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_zone_labels_radial.png'),
    );
  });

  testWidgets('Zone label content variants and overflow clipping',
      (tester) async {
    Widget gauge(List<GaugeZone> zones) => SizedBox(
          width: 280,
          height: 180,
          child: RadialGauge(
            value: 0,
            axis: GaugeAxis(
              min: 0,
              max: 100,
              sweepDegrees: 200,
              pointer: null,
              progressBar: null,
              style: const GaugeAxisStyle(
                thickness: 28,
                background: Color(0xFFEEEEF2),
                zoneSpacing: 4,
                cornerRadius: Radius.circular(6),
              ),
              zones: zones,
            ),
          ),
        );

    await pumpRow(
      tester,
      surfaceSize: const Size(960, 240),
      gauges: [
        // Text-only and icon-only side by side on the same gauge.
        gauge(const [
          GaugeZone(
            from: 0,
            to: 50,
            color: Color(0xFF6FCF97),
            label: GaugeZoneLabel(text: 'TEXT', style: labelStyle),
          ),
          GaugeZone(
            from: 50,
            to: 100,
            color: Color(0xFFF2994A),
            label: GaugeZoneLabel(icon: Icons.bolt, style: labelStyle),
          ),
        ]),
        // Combined icon + text label.
        gauge(const [
          GaugeZone(
            from: 0,
            to: 100,
            color: Color(0xFF9B51E0),
            label: GaugeZoneLabel(
              icon: Icons.star,
              text: 'RATED',
              iconGap: 4,
              style: labelStyle,
            ),
          ),
        ]),
        // Long label in a narrow zone — clipped at the zone boundary.
        gauge(const [
          GaugeZone(
            from: 0,
            to: 80,
            color: Color(0xFF828282),
          ),
          GaugeZone(
            from: 80,
            to: 100,
            color: Color(0xFFEB5757),
            label: GaugeZoneLabel(
              text: 'OVERFLOW LABEL',
              style: labelStyle,
              alignment: GaugeZoneLabelAlignment.center,
              padding: 2,
            ),
          ),
        ]),
      ],
    );

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_zone_labels_variants.png'),
    );
  });
}
