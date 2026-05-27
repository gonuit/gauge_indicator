import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

/// Tests exercise `flattenZones` through the public `GaugeAxis.flatten` API.
void main() {
  group('GaugeAxis.flatten', () {
    test('passes non-overlapping zones through unchanged', () {
      const axis = GaugeAxis(zones: [
        GaugeZone(from: 0, to: 30, color: Color(0xFF111111)),
        GaugeZone(from: 30, to: 60, color: Color(0xFF222222)),
        GaugeZone(from: 60, to: 100, color: Color(0xFF333333)),
      ]);
      final result = axis.flatten().zones;
      expect(result, hasLength(3));
      expect(result[0].from, equals(0));
      expect(result[0].to, equals(30));
      expect(result[1].from, equals(30));
      expect(result[1].to, equals(60));
      expect(result[2].from, equals(60));
      expect(result[2].to, equals(100));
    });

    test('splits overlapping zones at break points', () {
      const axis = GaugeAxis(zones: [
        GaugeZone(from: 0, to: 60, color: Color(0xFF111111)),
        GaugeZone(from: 40, to: 100, color: Color(0xFF222222)),
      ]);
      final result = axis.flatten().zones.toList();
      expect(result, hasLength(3));
      expect(result[0].from, equals(0));
      expect(result[0].to, equals(40));
      expect(result[1].from, equals(40));
      expect(result[1].to, equals(60));
      expect(result[2].from, equals(60));
      expect(result[2].to, equals(100));
    });

    test('with blendColors=false, overlap region takes the last zone color',
        () {
      const axis = GaugeAxis(
        style: GaugeAxisStyle(blendColors: false),
        zones: [
          GaugeZone(from: 0, to: 60, color: Color(0xFFAA0000)),
          GaugeZone(from: 40, to: 100, color: Color(0xFF00AA00)),
        ],
      );
      final result = axis.flatten().zones.toList();
      expect(result[1].color, equals(const Color(0xFF00AA00)));
    });

    test('with blendColors=true, overlap region color is blended', () {
      const axis = GaugeAxis(
        style: GaugeAxisStyle(blendColors: true),
        zones: [
          GaugeZone(from: 0, to: 60, color: Color(0xFFAA0000)),
          GaugeZone(from: 40, to: 100, color: Color(0xFF00AA00)),
        ],
      );
      final result = axis.flatten().zones.toList();
      // Blended overlap is neither pure red nor pure green.
      expect(result[1].color, isNot(equals(const Color(0xFFAA0000))));
      expect(result[1].color, isNot(equals(const Color(0xFF00AA00))));
    });

    test('fully contained zone overrides the enclosing zone in its range', () {
      const axis = GaugeAxis(
        style: GaugeAxisStyle(blendColors: false),
        zones: [
          GaugeZone(from: 0, to: 100, color: Color(0xFF111111)),
          GaugeZone(from: 40, to: 60, color: Color(0xFF222222)),
        ],
      );
      final result = axis.flatten().zones.toList();
      expect(result, hasLength(3));
      expect(result[0].color, equals(const Color(0xFF111111)));
      expect(result[1].color, equals(const Color(0xFF222222)));
      expect(result[2].color, equals(const Color(0xFF111111)));
    });

    test('inherits last zone properties onto overlay segment', () {
      const axis = GaugeAxis(
        style: GaugeAxisStyle(blendColors: false),
        zones: [
          GaugeZone(from: 0, to: 100, color: Color(0xFF111111)),
          GaugeZone(
            from: 40,
            to: 60,
            color: Color(0xFF222222),
            cornerRadius: Radius.circular(6),
            border: GaugeBorder(color: Color(0xFF000000), width: 2),
          ),
        ],
      );
      final result = axis.flatten().zones.toList();
      final inner = result[1];
      expect(inner.cornerRadius, equals(const Radius.circular(6)));
      expect(inner.border?.width, equals(2));
    });

    test('empty zones list produces empty output', () {
      const axis = GaugeAxis(zones: []);
      expect(axis.flatten().zones, isEmpty);
    });
  });
}
