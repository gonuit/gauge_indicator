import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

void main() {
  Future<void> pumpGauge(
    WidgetTester tester, {
    required GaugePointer pointer,
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
                  value: 50,
                  axis: GaugeAxis(
                    min: 0,
                    max: 100,
                    sweepDegrees: 180,
                    style: const GaugeAxisStyle(
                      thickness: 18,
                      background: Color(0xFFE5E7EB),
                      cornerRadius: Radius.circular(9),
                    ),
                    progressBar: null,
                    zones: const [],
                    pointer: pointer,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('NeedlePointer renders a tapered needle at center anchor', (
    tester,
  ) async {
    await pumpGauge(
      tester,
      pointer: const NeedlePointer(
        width: 16,
        height: 80,
        color: Color(0xFF002E5F),
        position: GaugePointerPosition.center(),
      ),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_pointer_needle.png'),
    );
  });

  testWidgets('TrianglePointer renders the default surface-anchored triangle', (
    tester,
  ) async {
    await pumpGauge(
      tester,
      pointer: const TrianglePointer(
        width: 24,
        height: 24,
        color: Color(0xFF002E5F),
        borderRadius: 3,
        position: GaugePointerPosition.surface(offset: Offset(0, 8)),
      ),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_pointer_triangle.png'),
    );
  });

  testWidgets('CirclePointer renders a filled circle on the axis surface', (
    tester,
  ) async {
    await pumpGauge(
      tester,
      pointer: const CirclePointer(radius: 10, color: Color(0xFF002E5F)),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_pointer_circle.png'),
    );
  });
}
