import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

void main() {
  group('ValueLabelProvider', () {
    test('formats with default zero fraction digits', () {
      const provider = ValueLabelProvider();
      expect(provider.getLabel(3.14159), equals('3'));
      expect(provider.getLabel(0), equals('0'));
      expect(provider.getLabel(-7.6), equals('-8'));
    });

    test('respects fractionDigits', () {
      const provider = ValueLabelProvider(fractionDigits: 2);
      expect(provider.getLabel(3.14159), equals('3.14'));
      expect(provider.getLabel(1), equals('1.00'));
    });
  });

  group('MapLabelProvider', () {
    test('delegates to the provided function', () {
      final provider = MapLabelProvider(
        toLabel: (v) => 'value=$v',
      );
      expect(provider.getLabel(42), equals('value=42.0'));
    });
  });

  group('CategoryLabelProvider', () {
    const categories = [
      LabelCategory(0, 33, 'low'),
      LabelCategory(34, 66, 'mid'),
      LabelCategory(67, 100, 'high'),
    ];

    test('returns the label of the matching category', () {
      const provider = CategoryLabelProvider(categories);
      expect(provider.getLabel(10), equals('low'));
      expect(provider.getLabel(50), equals('mid'));
      expect(provider.getLabel(90), equals('high'));
    });

    test('matches at exact boundary (inclusive)', () {
      const provider = CategoryLabelProvider(categories);
      expect(provider.getLabel(0), equals('low'));
      expect(provider.getLabel(33), equals('low'));
      expect(provider.getLabel(34), equals('mid'));
      expect(provider.getLabel(100), equals('high'));
    });

    test('returns first match when ranges overlap', () {
      const overlapping = [
        LabelCategory(0, 100, 'first'),
        LabelCategory(0, 100, 'second'),
      ];
      const provider = CategoryLabelProvider(overlapping);
      expect(provider.getLabel(50), equals('first'));
    });

    test('falls back to numeric label when no category matches', () {
      const provider = CategoryLabelProvider(categories);
      expect(provider.getLabel(-5), equals('-5'));
      expect(provider.getLabel(200), equals('200'));
    });

    test('fallback respects fractionDigits', () {
      const provider = CategoryLabelProvider(
        categories,
        fractionDigits: 1,
      );
      expect(provider.getLabel(150), equals('150.0'));
    });

    test('empty categories always falls back', () {
      const provider = CategoryLabelProvider([]);
      expect(provider.getLabel(42), equals('42'));
    });
  });
}
