import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

void main() {
  group('GaugeBorder.lerp', () {
    test('returns null when end is null', () {
      expect(GaugeBorder.lerp(null, null, 0.5), isNull);
      expect(
        GaugeBorder.lerp(
          const GaugeBorder(color: Color(0xFF000000)),
          null,
          0.5,
        ),
        isNull,
      );
    });

    test('returns end when begin is null', () {
      const end = GaugeBorder(color: Color(0xFFFFFFFF), width: 4);
      expect(GaugeBorder.lerp(null, end, 0.5), equals(end));
    });

    test('interpolates color and width at t=0.5', () {
      final result = GaugeBorder.lerp(
        const GaugeBorder(color: Color(0xFF000000), width: 0),
        const GaugeBorder(color: Color(0xFFFFFFFF), width: 10),
        0.5,
      )!;
      expect(result.width, equals(5));
      expect(
        result.color,
        equals(
          Color.lerp(const Color(0xFF000000), const Color(0xFFFFFFFF), 0.5),
        ),
      );
    });

    test('returns begin values at t=0', () {
      final result = GaugeBorder.lerp(
        const GaugeBorder(color: Color(0xFF111111), width: 2),
        const GaugeBorder(color: Color(0xFF222222), width: 6),
        0,
      )!;
      expect(result.width, equals(2));
    });

    test('returns end values at t=1', () {
      final result = GaugeBorder.lerp(
        const GaugeBorder(color: Color(0xFF111111), width: 2),
        const GaugeBorder(color: Color(0xFF222222), width: 6),
        1,
      )!;
      expect(result.width, equals(6));
    });
  });

  group('GaugeZone.lerp', () {
    test('interpolates numeric fields at t=0.5', () {
      final result = GaugeZone.lerp(
        const GaugeZone(from: 0, to: 50, color: Color(0xFF000000)),
        const GaugeZone(from: 10, to: 70, color: Color(0xFFFFFFFF)),
        0.5,
      );
      expect(result.from, equals(5));
      expect(result.to, equals(60));
    });

    test('uses end gradient/shader/label (not blended)', () {
      const endGradient = GaugeAxisGradient(colors: [Color(0xFFAA0000)]);
      final result = GaugeZone.lerp(
        const GaugeZone(from: 0, to: 100, color: Color(0xFF000000)),
        const GaugeZone(
          from: 0,
          to: 100,
          color: Color(0xFFFFFFFF),
          gradient: endGradient,
        ),
        0.5,
      );
      expect(result.gradient, same(endGradient));
    });

    test('lerps cornerRadius', () {
      final result = GaugeZone.lerp(
        const GaugeZone(
          from: 0,
          to: 100,
          color: Color(0xFF000000),
          cornerRadius: Radius.circular(0),
        ),
        const GaugeZone(
          from: 0,
          to: 100,
          color: Color(0xFFFFFFFF),
          cornerRadius: Radius.circular(10),
        ),
        0.5,
      );
      expect(result.cornerRadius, equals(const Radius.circular(5)));
    });

    test('thickness lerps when both ends define it', () {
      final result = GaugeZone.lerp(
        const GaugeZone(
          from: 0,
          to: 100,
          color: Color(0xFF000000),
          thickness: 10,
        ),
        const GaugeZone(
          from: 0,
          to: 100,
          color: Color(0xFFFFFFFF),
          thickness: 20,
        ),
        0.5,
      );
      expect(result.thickness, equals(15));
    });

    test('thickness stays null when both ends are null', () {
      final result = GaugeZone.lerp(
        const GaugeZone(from: 0, to: 100, color: Color(0xFF000000)),
        const GaugeZone(from: 0, to: 100, color: Color(0xFFFFFFFF)),
        0.5,
      );
      expect(result.thickness, isNull);
    });

    test('thickness lerps from the defined side when one end is null', () {
      final result = GaugeZone.lerp(
        const GaugeZone(from: 0, to: 100, color: Color(0xFF000000)),
        const GaugeZone(
          from: 0,
          to: 100,
          color: Color(0xFFFFFFFF),
          thickness: 20,
        ),
        0.5,
      );
      expect(result.thickness, equals(20));
    });
  });

  group('GaugeAxisStyle.lerp', () {
    test('interpolates thickness, zoneSpacing, cornerRadius', () {
      final result = GaugeAxisStyle.lerp(
        const GaugeAxisStyle(
          thickness: 10,
          zoneSpacing: 0,
          cornerRadius: Radius.circular(0),
        ),
        const GaugeAxisStyle(
          thickness: 20,
          zoneSpacing: 0.2,
          cornerRadius: Radius.circular(10),
        ),
        0.5,
      );
      expect(result.thickness, equals(15));
      expect(result.zoneSpacing, closeTo(0.1, 1e-9));
      expect(result.cornerRadius, equals(const Radius.circular(5)));
    });

    test('uses end blendColors and zoneSpacingMode', () {
      final result = GaugeAxisStyle.lerp(
        const GaugeAxisStyle(
          blendColors: false,
          zoneSpacingMode: ZoneSpacingMode.uniform,
        ),
        const GaugeAxisStyle(
          blendColors: true,
          zoneSpacingMode: ZoneSpacingMode.local,
        ),
        0.5,
      );
      expect(result.blendColors, isTrue);
      expect(result.zoneSpacingMode, equals(ZoneSpacingMode.local));
    });
  });

  group('GaugeAxis.lerp', () {
    test('returns null when both ends are null', () {
      expect(GaugeAxis.lerp(null, null, 0.5), isNull);
    });

    test('returns end when begin is null', () {
      const end = GaugeAxis(sweepDegrees: 200);
      expect(GaugeAxis.lerp(null, end, 0.5), same(end));
    });

    test('returns begin when end is null', () {
      const begin = GaugeAxis(sweepDegrees: 200);
      expect(GaugeAxis.lerp(begin, null, 0.5), same(begin));
    });

    test('interpolates sweepDegrees', () {
      final result = GaugeAxis.lerp(
        const GaugeAxis(sweepDegrees: 180),
        const GaugeAxis(sweepDegrees: 360),
        0.5,
      )!;
      expect(result.sweepDegrees, equals(270));
    });

    test('lerp clamps sweepDegrees within [10, 360]', () {
      final result = GaugeAxis.lerp(
        const GaugeAxis(sweepDegrees: 10),
        const GaugeAxis(sweepDegrees: 360),
        1,
      )!;
      expect(result.sweepDegrees, lessThanOrEqualTo(360));
      expect(result.sweepDegrees, greaterThanOrEqualTo(10));
    });

    test('returns begin zones list at t=0', () {
      const begin = GaugeAxis(
        zones: [GaugeZone(from: 0, to: 50, color: Color(0xFF111111))],
      );
      const end = GaugeAxis(
        zones: [GaugeZone(from: 0, to: 50, color: Color(0xFF222222))],
      );
      final result = GaugeAxis.lerp(begin, end, 0)!;
      expect(result.zones, same(begin.zones));
    });

    test('returns end zones list at t=1', () {
      const begin = GaugeAxis(
        zones: [GaugeZone(from: 0, to: 50, color: Color(0xFF111111))],
      );
      const end = GaugeAxis(
        zones: [GaugeZone(from: 0, to: 50, color: Color(0xFF222222))],
      );
      final result = GaugeAxis.lerp(begin, end, 1)!;
      expect(result.zones, same(end.zones));
    });

    test('interpolates zones element-wise at intermediate t', () {
      const begin = GaugeAxis(
        zones: [GaugeZone(from: 0, to: 100, color: Color(0xFF000000))],
      );
      const end = GaugeAxis(
        zones: [GaugeZone(from: 0, to: 100, color: Color(0xFFFFFFFF))],
      );
      final result = GaugeAxis.lerp(begin, end, 0.5)!;
      expect(result.zones.length, equals(1));
      expect(
        result.zones.first.color,
        equals(
          Color.lerp(const Color(0xFF000000), const Color(0xFFFFFFFF), 0.5),
        ),
      );
    });

    test('handles differing zone counts by collapsing missing ends', () {
      const begin = GaugeAxis(
        zones: [
          GaugeZone(from: 0, to: 50, color: Color(0xFF111111)),
          GaugeZone(from: 50, to: 100, color: Color(0xFF222222)),
        ],
      );
      const end = GaugeAxis(
        zones: [GaugeZone(from: 0, to: 80, color: Color(0xFFAAAAAA))],
      );
      final result = GaugeAxis.lerp(begin, end, 0.5)!;
      expect(result.zones.length, equals(2));
    });
  });

  group('GaugeAxisTween', () {
    test('delegates to GaugeAxis.lerp', () {
      final tween = GaugeAxisTween(
        begin: const GaugeAxis(sweepDegrees: 180),
        end: const GaugeAxis(sweepDegrees: 360),
      );
      expect(tween.lerp(0)!.sweepDegrees, equals(180));
      expect(tween.lerp(1)!.sweepDegrees, equals(360));
      expect(tween.lerp(0.5)!.sweepDegrees, equals(270));
    });
  });
}
