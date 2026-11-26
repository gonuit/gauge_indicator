import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:gauge_indicator/src/radial_gauge/internal/internal.dart';

void main() {
  test('zone angles account for the spacing on both sides', () {
    final layout = RadialGaugeLayout.calculate(
      BoxConstraints.tight(const Size(200, 100)),
      RadialGaugeSizeRatios.fromDegrees(180),
    );
    const axis = GaugeAxis(
      style: GaugeAxisStyle(thickness: 20, zoneSpacing: 18),
      zones: [
        GaugeZone(from: 0, to: 0.25),
        GaugeZone(from: 0.25, to: 0.75),
        GaugeZone(from: 0.75, to: 1),
      ],
    );

    final zones = RadialGaugeAxisDefinition.calculate(layout, axis).zones;

    const halfSpacing = 9 / 90;
    expect(zones[0].startAngle, closeTo(-math.pi, 1e-9));
    expect(zones[0].sweepAngle, closeTo(math.pi / 4 - halfSpacing, 1e-9));
    expect(zones[1].startAngle, closeTo(-math.pi * 3 / 4 + halfSpacing, 1e-9));
    expect(zones[1].sweepAngle, closeTo(math.pi / 2 - 2 * halfSpacing, 1e-9));
    expect(zones[2].startAngle, closeTo(-math.pi / 4 + halfSpacing, 1e-9));
    expect(zones[2].sweepAngle, closeTo(math.pi / 4 - halfSpacing, 1e-9));
  });
}
