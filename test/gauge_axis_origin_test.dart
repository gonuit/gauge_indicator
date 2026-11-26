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

  group('GaugeAxis.copyWith', () {
    test('a default origin follows a new min', () {
      final axis = const GaugeAxis(min: 0, max: 100).copyWith(min: 10);
      expect(axis.min, 10);
      expect(axis.origin, 10);
    });

    test('keeps an explicitly set origin', () {
      final axis = const GaugeAxis(
        min: 0,
        max: 100,
        origin: 50,
      ).copyWith(min: 10);
      expect(axis.origin, 50);
    });

    test('replaces the origin when one is given', () {
      final axis = const GaugeAxis(min: 0, max: 100).copyWith(origin: 25);
      expect(axis.origin, 25);
    });
  });

  group('GaugeAxis range', () {
    test('asserts when min equals max', () {
      expect(() => GaugeAxis(min: 1, max: 1), throwsAssertionError);
    });

    test('asserts when min is above max', () {
      expect(() => GaugeAxis(min: 2, max: 1), throwsAssertionError);
    });
  });
}
