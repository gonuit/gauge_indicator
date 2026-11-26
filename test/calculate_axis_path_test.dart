import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_indicator/src/utils/calculate_axis_path.dart';

void main() {
  group('calculateAxisPath', () {
    final rect = Rect.fromCircle(center: const Offset(100, 100), radius: 100);
    const top = Offset(100, 10);
    const bottomGap = Offset(100, 190);

    test('covers the whole span when drawn forwards', () {
      final path = calculateAxisPath(
        rect,
        from: 0,
        to: 1,
        degrees: 270,
        thickness: 20,
      );

      expect(path.contains(top), isTrue);
      expect(path.contains(bottomGap), isFalse);
    });

    test('covers the whole span when drawn backwards', () {
      final path = calculateAxisPath(
        rect,
        from: 1,
        to: 0,
        degrees: 270,
        thickness: 20,
      );

      expect(path.contains(top), isTrue);
      expect(path.contains(bottomGap), isFalse);
    });

    test('keeps a short backwards span on the short side', () {
      final path = calculateAxisPath(
        rect,
        from: 0.6,
        to: 0.4,
        degrees: 270,
        thickness: 20,
      );

      expect(path.contains(top), isTrue);
      expect(path.contains(const Offset(10, 100)), isFalse);
    });
  });
}
