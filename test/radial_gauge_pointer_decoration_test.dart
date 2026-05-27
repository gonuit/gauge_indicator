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

  testWidgets('NeedlePointer renders a gradient fill', (tester) async {
    await pumpGauge(
      tester,
      pointer: const NeedlePointer(
        width: 16,
        height: 80,
        gradient: LinearGradient(
          colors: [Color(0xFF002E5F), Color(0xFF00C853)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        position: GaugePointerPosition.center(),
      ),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_pointer_needle_gradient.png'),
    );
  });

  testWidgets('TrianglePointer renders a gradient fill', (tester) async {
    await pumpGauge(
      tester,
      pointer: const TrianglePointer(
        width: 28,
        height: 28,
        gradient: LinearGradient(
          colors: [Color(0xFF002E5F), Color(0xFF00C853)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: 3,
        position: GaugePointerPosition.surface(offset: Offset(0, 8)),
      ),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_pointer_triangle_gradient.png'),
    );
  });

  testWidgets('CirclePointer renders a stroke around the fill', (tester) async {
    await pumpGauge(
      tester,
      pointer: const CirclePointer(
        radius: 12,
        color: Color(0xFF00C853),
        border: GaugePointerBorder(
          color: Color(0xFF002E5F),
          width: 2,
        ),
      ),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_pointer_circle_border.png'),
    );
  });
}
