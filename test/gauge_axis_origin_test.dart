import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

void main() {
  group('GaugeAxis.origin', () {
    test('defaults to min when omitted', () {
      expect(const GaugeAxis(min: 50, max: 180).origin, 50);
    });

    test('keeps an explicitly set in-range origin', () {
      expect(const GaugeAxis(min: 0, max: 100, origin: 25).origin, 25);
    });

    test('accepts the boundaries (origin == min, origin == max)', () {
      expect(const GaugeAxis(min: 50, max: 180, origin: 50).origin, 50);
      expect(const GaugeAxis(min: 50, max: 180, origin: 180).origin, 180);
    });

    test('asserts when origin is below min', () {
      expect(
        () => GaugeAxis(min: 50, max: 180, origin: 0),
        throwsAssertionError,
      );
    });

    test('asserts when origin is above max', () {
      expect(
        () => GaugeAxis(min: 0, max: 100, origin: 150),
        throwsAssertionError,
      );
    });
  });
}
