import 'package:flutter/animation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

void main() {
  group('GaugeAxisTransformer.noTransform', () {
    const transformer = GaugeAxisTransformer.noTransform();
    const axis = GaugeAxis(
      zones: [GaugeZone(from: 0, to: 100, color: Color(0xFF111111))],
    );
    const range = GaugeRange(0, 100);

    test('returns the axis unchanged regardless of progress', () {
      expect(transformer.transform(axis, range, 0, 0, true), same(axis));
      expect(transformer.transform(axis, range, 0.5, 50, false), same(axis));
      expect(transformer.transform(axis, range, 1, 100, false), same(axis));
    });
  });

  group('GaugeAxisTransformer.colorFadeIn', () {
    const transformer = GaugeAxisTransformer.colorFadeIn(
      interval: Interval(0, 1),
    );
    const range = GaugeRange(0, 100);
    const axis = GaugeAxis(
      zones: [GaugeZone(from: 0, to: 100, color: Color(0xFFFF0000))],
    );

    test('fades zone colors toward transparent during initial animation', () {
      final mid = transformer.transform(axis, range, 0.5, 50, true);
      expect(mid.zones.first.color, isNot(equals(const Color(0xFFFF0000))));
      expect(mid.zones.first.color.a, lessThan(1.0));
    });

    test('returns the axis unchanged once initial animation is over', () {
      final result = transformer.transform(axis, range, 0.5, 50, false);
      expect(result, same(axis));
    });

    test('reaches full color at progress=1', () {
      final result = transformer.transform(axis, range, 1, 100, true);
      expect(result.zones.first.color.a, equals(1.0));
    });
  });

  group('GaugeAxisTransformer.progress', () {
    const range = GaugeRange(0, 100);
    const overlayColor = Color(0xFF00FF00);

    test('produces a single overlay matching value when axis has no zones', () {
      const transformer = GaugeAxisTransformer.progress(color: overlayColor);
      const axis = GaugeAxis();
      final result = transformer.transform(axis, range, 0.5, 50, false);
      expect(result.zones, isNotEmpty);
      expect(result.zones.any((z) => z.color == overlayColor), isTrue);
    });

    test('overlays the recolored portion of each zone', () {
      const transformer = GaugeAxisTransformer.progress(color: overlayColor);
      const axis = GaugeAxis(
        style: GaugeAxisStyle(blendColors: false),
        zones: [GaugeZone(from: 0, to: 100, color: Color(0xFF111111))],
      );
      final result = transformer.transform(axis, range, 0.5, 50, false);
      // The portion [0, 50] should be recolored to the overlay color,
      // and [50, 100] should keep the original zone color.
      final recolored = result.zones.firstWhere(
        (z) => z.from == 0 && z.to == 50,
      );
      final original = result.zones.firstWhere(
        (z) => z.from == 50 && z.to == 100,
      );
      expect(recolored.color, equals(overlayColor));
      expect(original.color, equals(const Color(0xFF111111)));
    });

    test('reversed=true recolors the upper side instead of the lower side', () {
      const transformer = GaugeAxisTransformer.progress(
        color: overlayColor,
        reversed: true,
      );
      const axis = GaugeAxis(
        style: GaugeAxisStyle(blendColors: false),
        zones: [GaugeZone(from: 0, to: 100, color: Color(0xFF111111))],
      );
      final result = transformer.transform(axis, range, 0.5, 50, false);
      final recolored = result.zones.firstWhere(
        (z) => z.from == 50 && z.to == 100,
      );
      expect(recolored.color, equals(overlayColor));
    });

    test('value at min produces no recolored overlay', () {
      const transformer = GaugeAxisTransformer.progress(color: overlayColor);
      const axis = GaugeAxis(
        zones: [GaugeZone(from: 0, to: 100, color: Color(0xFF111111))],
      );
      final result = transformer.transform(axis, range, 0, 0, false);
      expect(result.zones.every((z) => z.color != overlayColor), isTrue);
    });
  });
}
