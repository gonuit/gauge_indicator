import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

void main() {
  testWidgets(
    'Axis with min: -50 and max: 50 maps a negative value correctly',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

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
                  child: RadialGauge(
                    value: -20,
                    axis: GaugeAxis(
                      min: -50,
                      max: 50,
                      sweepDegrees: 180,
                      style: GaugeAxisStyle(
                        thickness: 18,
                        background: Color(0xFFE5E7EB),
                        cornerRadius: Radius.circular(9),
                      ),
                      progressBar: GaugeProgressBar.basic(
                        color: Color(0xFF00C853),
                      ),
                      zones: [],
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
        matchesGoldenFile('goldens/radial_gauge_negative_range.png'),
      );
    },
  );
}
