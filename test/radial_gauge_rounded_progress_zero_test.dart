import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

/// Regression coverage for https://github.com/gonuit/gauge_indicator/issues/13
///
/// The rounded progress bar's cap radius is scaled down (like segment corner
/// radii) when the arc is shorter than the diameter of its caps. At value 0
/// nothing is drawn; small values render a thin full-height sliver.
void main() {
  Future<void> pump(WidgetTester tester, double value) async {
    await tester.binding.setSurfaceSize(const Size(744, 240));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_pumpRow(value: value));
  }

  testWidgets('value 0', (tester) async {
    await pump(tester, 0);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_rounded_progress_zero.png'),
    );
  });

  testWidgets('near-zero value', (tester) async {
    await pump(tester, 1);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_rounded_progress_near_zero.png'),
    );
  });

  testWidgets('25% value', (tester) async {
    await pump(tester, 37.5);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_rounded_progress_25.png'),
    );
  });

  testWidgets('50% value', (tester) async {
    await pump(tester, 75);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_rounded_progress_50.png'),
    );
  });

  testWidgets('100% value', (tester) async {
    await pump(tester, 150);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/radial_gauge_rounded_progress_100.png'),
    );
  });
}

Widget _pumpRow({required double value}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _Gauge(
              value: value,
              placement: GaugeProgressPlacement.over,
              roundedAxis: true,
            ),
            _Gauge(
              value: value,
              placement: GaugeProgressPlacement.inside,
              roundedAxis: true,
            ),
            _Gauge(
              value: value,
              placement: GaugeProgressPlacement.over,
              roundedAxis: false,
            ),
          ],
        ),
      ),
    ),
  );
}

class _Gauge extends StatelessWidget {
  final double value;
  final GaugeProgressPlacement placement;
  final bool roundedAxis;

  const _Gauge({
    required this.value,
    required this.placement,
    required this.roundedAxis,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 192,
      child: RadialGauge(
        value: value,
        axis: GaugeAxis(
          min: 0,
          max: 150,
          degrees: 250,
          style: GaugeAxisStyle(
            thickness: 14,
            background: const Color(0xFFDFE2EC),
            cornerRadius: roundedAxis ? const Radius.circular(7) : Radius.zero,
          ),
          progressBar: GaugeProgressBar.rounded(
            placement: placement,
            color: const Color(0xFF4CAF50),
          ),
          segments: const [
            GaugeSegment(
              from: 0,
              to: 150,
              color: Color(0xFFDFE2EC),
            ),
          ],
        ),
      ),
    );
  }
}
