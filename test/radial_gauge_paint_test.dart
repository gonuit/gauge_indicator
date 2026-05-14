import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

/// Regression coverage for https://github.com/gonuit/gauge_indicator/issues/17
///
/// Bare [RadialGauge] (no [RepaintBoundary] above it) is painted with a
/// non-zero canvas offset whenever it is not at its parent's (0, 0). The
/// segments must follow that offset together with the axis surface.
void main() {
  testWidgets(
    'RadialGauge segments follow parent offset (Padding)',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(408, 248));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: Color(0xFFFFFFFF),
            body: Padding(
              padding: EdgeInsets.fromLTRB(144, 84, 24, 24),
              child: SizedBox(
                width: 240,
                height: 140,
                child: RadialGauge(
                  value: 50,
                  axis: GaugeAxis(
                    min: 0,
                    max: 100,
                    degrees: 180,
                    style: GaugeAxisStyle(
                      thickness: 14,
                      background: Color(0xFFDFE2EC),
                    ),
                    segments: [
                      GaugeSegment(from: 0, to: 50, color: Color(0xFF673AB7)),
                      GaugeSegment(from: 50, to: 100, color: Color(0xFFE91E63)),
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
        matchesGoldenFile('goldens/radial_gauge_in_padding.png'),
      );
    },
  );

  testWidgets(
    'RadialGauge segments follow parent offset (Row of two gauges)',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(508, 188));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: Color(0xFFFFFFFF),
            body: Padding(
              padding: EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 220,
                    height: 140,
                    child: RadialGauge(
                      value: 60,
                      axis: GaugeAxis(
                        min: 0,
                        max: 100,
                        degrees: 180,
                        style: GaugeAxisStyle(
                          thickness: 12,
                          background: Color(0xFFE0E4EE),
                        ),
                        segments: [
                          GaugeSegment(
                              from: 0, to: 25, color: Color(0xFF2196F3)),
                          GaugeSegment(
                              from: 25, to: 50, color: Color(0xFF4CAF50)),
                          GaugeSegment(
                              from: 50, to: 75, color: Color(0xFFFFEB3B)),
                          GaugeSegment(
                              from: 75, to: 100, color: Color(0xFFF44336)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  SizedBox(
                    width: 220,
                    height: 140,
                    child: RadialGauge(
                      value: 80,
                      axis: GaugeAxis(
                        min: 0,
                        max: 120,
                        degrees: 180,
                        style: GaugeAxisStyle(
                          thickness: 12,
                          background: Color(0xFFE0E4EE),
                        ),
                        segments: [
                          GaugeSegment(
                              from: 0, to: 30, color: Color(0xFF9C27B0)),
                          GaugeSegment(
                              from: 30, to: 60, color: Color(0xFFFF9800)),
                          GaugeSegment(
                              from: 60, to: 90, color: Color(0xFFE91E63)),
                          GaugeSegment(
                              from: 90, to: 120, color: Color(0xFF009688)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/radial_gauge_in_row.png'),
      );
    },
  );
}
