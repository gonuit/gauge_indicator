import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

/// Golden coverage for [GaugeZoneLabel] rendering inside zones. One case
/// per golden so a regression points straight at the failing scenario:
///
///  * Alignment — `start`, `center`, `end` anchor positions.
///  * Radial alignment — `-1` (inner edge), `0` (centerline), `+1` (outer).
///  * Content variants — text-only, icon-only, icon + text.
///  * Overflow — a long label clipped at a narrow zone boundary.
void main() {
  const labelStyle = TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  Future<void> pumpGauge(
    WidgetTester tester, {
    required List<GaugeZone> zones,
    double thickness = 26,
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
                  value: 0,
                  axis: GaugeAxis(
                    min: 0,
                    max: 100,
                    sweepDegrees: 180,
                    pointer: null,
                    progressBar: null,
                    style: GaugeAxisStyle(
                      thickness: thickness,
                      background: const Color(0xFFEEEEF2),
                      zoneSpacing: 4,
                      cornerRadius: const Radius.circular(6),
                    ),
                    zones: zones,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<GaugeZone> twoZonesWithAlignment(GaugeZoneLabelAlignment alignment) => [
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
      ];

  testWidgets('alignment: start', (tester) async {
    await pumpGauge(
      tester,
      zones: twoZonesWithAlignment(GaugeZoneLabelAlignment.start),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_zone_label_alignment_start.png'),
    );
  });

  testWidgets('alignment: center', (tester) async {
    await pumpGauge(
      tester,
      zones: twoZonesWithAlignment(GaugeZoneLabelAlignment.center),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_zone_label_alignment_center.png'),
    );
  });

  testWidgets('alignment: end', (tester) async {
    await pumpGauge(
      tester,
      zones: twoZonesWithAlignment(GaugeZoneLabelAlignment.end),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_zone_label_alignment_end.png'),
    );
  });

  List<GaugeZone> oneZoneWithRadial(double radialAlignment) => [
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
      ];

  testWidgets('radial alignment: inner (-1)', (tester) async {
    await pumpGauge(
      tester,
      zones: oneZoneWithRadial(-1.0),
      thickness: 36,
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_zone_label_radial_inner.png'),
    );
  });

  testWidgets('radial alignment: centerline (0)', (tester) async {
    await pumpGauge(
      tester,
      zones: oneZoneWithRadial(0.0),
      thickness: 36,
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(
          'goldens/radial_gauge_zone_label_radial_centerline.png'),
    );
  });

  testWidgets('radial alignment: outer (+1)', (tester) async {
    await pumpGauge(
      tester,
      zones: oneZoneWithRadial(1.0),
      thickness: 36,
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_zone_label_radial_outer.png'),
    );
  });

  testWidgets('content: text only', (tester) async {
    await pumpGauge(tester, zones: const [
      GaugeZone(
        from: 0,
        to: 100,
        color: Color(0xFF6FCF97),
        label: GaugeZoneLabel(text: 'TEXT', style: labelStyle),
      ),
    ]);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_zone_label_text_only.png'),
    );
  });

  testWidgets('content: icon only', (tester) async {
    await pumpGauge(tester, zones: const [
      GaugeZone(
        from: 0,
        to: 100,
        color: Color(0xFFF2994A),
        label: GaugeZoneLabel(icon: Icons.bolt, style: labelStyle),
      ),
    ]);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_zone_label_icon_only.png'),
    );
  });

  testWidgets('content: icon and text', (tester) async {
    await pumpGauge(tester, zones: const [
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
    ]);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_zone_label_icon_and_text.png'),
    );
  });

  testWidgets('overflow: long label clipped at narrow zone', (tester) async {
    await pumpGauge(tester, zones: const [
      GaugeZone(from: 0, to: 80, color: Color(0xFF828282)),
      GaugeZone(
        from: 80,
        to: 100,
        color: Color(0xFFEB5757),
        label: GaugeZoneLabel(
          text: 'OVERFLOW LABEL',
          style: labelStyle,
          padding: 2,
        ),
      ),
    ]);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_zone_label_overflow_clipped.png'),
    );
  });
}
