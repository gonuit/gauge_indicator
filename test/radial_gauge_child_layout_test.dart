import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

void main() {
  testWidgets('child lays out when the gauge has no space', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: RadialGauge(value: 0.5, axis: GaugeAxis(), child: Text('x')),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.text('x')), Size.zero);
  });

  testWidgets('child lays out when the band is thicker than the radius', (
    tester,
  ) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: 30,
            child: RadialGauge(
              value: 0.5,
              axis: GaugeAxis(style: GaugeAxisStyle(thickness: 20)),
              child: Text('x'),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.text('x')), Size.zero);
  });
}
