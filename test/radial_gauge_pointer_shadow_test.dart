import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

/// Regression coverage for https://github.com/gonuit/gauge_indicator/issues/14
///
/// The pointer's [Shadow.offset] must shift the rendered shadow relative to
/// the pointer. Previously the shadow was drawn at the pointer path directly,
/// so the offset was silently ignored.
void main() {
  testWidgets(
    'Needle pointer shadow is drawn with Shadow.offset applied',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(288, 188));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: Color(0xFFFFFFFF),
            body: Padding(
              padding: EdgeInsets.all(24),
              child: SizedBox(
                width: 240,
                height: 140,
                child: RadialGauge(
                  value: 50,
                  axis: GaugeAxis(
                    min: 0,
                    max: 100,
                    sweepDegrees: 180,
                    style: GaugeAxisStyle(
                      thickness: 14,
                      background: Color(0xFFDFE2EC),
                      cornerRadius: Radius.circular(7),
                    ),
                    progressBar: GaugeProgressBar.basic(
                      placement: GaugeProgressPlacement.inside,
                      color: Color(0xFF673AB7),
                    ),
                    zones: [
                      GaugeZone(
                        from: 0,
                        to: 100,
                        color: Color(0xFFDFE2EC),
                        cornerRadius: Radius.circular(7),
                      ),
                    ],
                    pointer: NeedlePointer(
                      width: 16,
                      height: 80,
                      color: Color(0xFF002E5F),
                      shadow: Shadow(
                        color: Color(0x80FF0000),
                        offset: Offset(12, 12),
                        blurRadius: 0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/radial_gauge_pointer_shadow_offset.png'),
      );
    },
  );
}
