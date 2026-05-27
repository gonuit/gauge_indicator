import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

void main() {
  group('GaugeBorder ==/hashCode', () {
    test('identical instances are equal', () {
      const a = GaugeBorder(color: Color(0xFF112233), width: 2);
      const b = GaugeBorder(color: Color(0xFF112233), width: 2);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('differs on color', () {
      expect(
        const GaugeBorder(color: Color(0xFF112233)),
        isNot(equals(const GaugeBorder(color: Color(0xFFAABBCC)))),
      );
    });

    test('differs on width', () {
      expect(
        const GaugeBorder(color: Color(0xFF112233), width: 1),
        isNot(equals(const GaugeBorder(color: Color(0xFF112233), width: 2))),
      );
    });
  });

  group('GaugeAxisGradient ==/hashCode', () {
    test('identical instances are equal', () {
      const a = GaugeAxisGradient(
        colors: [Color(0xFFAA0000), Color(0xFF00AA00)],
        colorStops: [0.0, 1.0],
        tileMode: TileMode.clamp,
      );
      const b = GaugeAxisGradient(
        colors: [Color(0xFFAA0000), Color(0xFF00AA00)],
        colorStops: [0.0, 1.0],
        tileMode: TileMode.clamp,
      );
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('differs on color order', () {
      expect(
        const GaugeAxisGradient(
          colors: [Color(0xFFAA0000), Color(0xFF00AA00)],
        ),
        isNot(equals(const GaugeAxisGradient(
          colors: [Color(0xFF00AA00), Color(0xFFAA0000)],
        ))),
      );
    });

    test('differs on colorStops', () {
      expect(
        const GaugeAxisGradient(
          colors: [Color(0xFFAA0000), Color(0xFF00AA00)],
          colorStops: [0.0, 1.0],
        ),
        isNot(equals(const GaugeAxisGradient(
          colors: [Color(0xFFAA0000), Color(0xFF00AA00)],
          colorStops: [0.25, 0.75],
        ))),
      );
    });

    test('null colorStops vs non-null is not equal', () {
      expect(
        const GaugeAxisGradient(colors: [Color(0xFFAA0000)]),
        isNot(equals(const GaugeAxisGradient(
          colors: [Color(0xFFAA0000)],
          colorStops: [0.5],
        ))),
      );
    });

    test('differs on tileMode', () {
      expect(
        const GaugeAxisGradient(
          colors: [Color(0xFFAA0000)],
          tileMode: TileMode.clamp,
        ),
        isNot(equals(const GaugeAxisGradient(
          colors: [Color(0xFFAA0000)],
          tileMode: TileMode.mirror,
        ))),
      );
    });
  });

  group('GaugeZone ==/hashCode', () {
    const baseline = GaugeZone(
      from: 0,
      to: 100,
      color: Color(0xFF112233),
      cornerRadius: Radius.circular(2),
      thickness: 10,
    );

    test('identical instances are equal', () {
      expect(baseline, equals(baseline.copyWith()));
      expect(baseline.hashCode, equals(baseline.copyWith().hashCode));
    });

    test('differs on from', () {
      expect(baseline, isNot(equals(baseline.copyWith(from: 5))));
    });

    test('differs on to', () {
      expect(baseline, isNot(equals(baseline.copyWith(to: 50))));
    });

    test('differs on color', () {
      expect(
        baseline,
        isNot(equals(baseline.copyWith(color: const Color(0xFFFFFFFF)))),
      );
    });

    test('differs on border', () {
      expect(
        baseline,
        isNot(equals(baseline.copyWith(
          border: const GaugeBorder(color: Color(0xFF000000)),
        ))),
      );
    });

    test('differs on cornerRadius', () {
      expect(
        baseline,
        isNot(
            equals(baseline.copyWith(cornerRadius: const Radius.circular(8)))),
      );
    });

    test('differs on thickness', () {
      expect(baseline, isNot(equals(baseline.copyWith(thickness: 20))));
    });

    test('differs on shadow', () {
      expect(
        baseline,
        isNot(equals(baseline.copyWith(
          shadow: const BoxShadow(blurRadius: 4),
        ))),
      );
    });
  });

  group('GaugeAxisStyle ==/hashCode', () {
    test('identical instances are equal', () {
      const a = GaugeAxisStyle();
      const b = GaugeAxisStyle();
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('differs on thickness', () {
      expect(
        const GaugeAxisStyle(thickness: 10),
        isNot(equals(const GaugeAxisStyle(thickness: 12))),
      );
    });

    test('differs on background', () {
      expect(
        const GaugeAxisStyle(background: Color(0xFFAAAAAA)),
        isNot(equals(const GaugeAxisStyle(background: Color(0xFFBBBBBB)))),
      );
    });

    test('differs on cornerRadius', () {
      expect(
        const GaugeAxisStyle(cornerRadius: Radius.circular(4)),
        isNot(equals(const GaugeAxisStyle(cornerRadius: Radius.circular(8)))),
      );
    });

    test('differs on zoneSpacing', () {
      expect(
        const GaugeAxisStyle(zoneSpacing: 0.0),
        isNot(equals(const GaugeAxisStyle(zoneSpacing: 0.1))),
      );
    });

    test('differs on zoneSpacingMode', () {
      expect(
        const GaugeAxisStyle(zoneSpacingMode: ZoneSpacingMode.uniform),
        isNot(equals(
            const GaugeAxisStyle(zoneSpacingMode: ZoneSpacingMode.local))),
      );
    });

    test('differs on blendColors', () {
      expect(
        const GaugeAxisStyle(blendColors: true),
        isNot(equals(const GaugeAxisStyle(blendColors: false))),
      );
    });
  });

  group('GaugeAxis ==/hashCode', () {
    test('identical instances are equal', () {
      const a = GaugeAxis();
      const b = GaugeAxis();
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('differs on sweepDegrees', () {
      expect(
        const GaugeAxis(sweepDegrees: 180),
        isNot(equals(const GaugeAxis(sweepDegrees: 270))),
      );
    });

    test('differs on style', () {
      expect(
        const GaugeAxis(style: GaugeAxisStyle(thickness: 10)),
        isNot(equals(const GaugeAxis(style: GaugeAxisStyle(thickness: 12)))),
      );
    });

    test('differs on zones (order matters)', () {
      const a = GaugeAxis(zones: [
        GaugeZone(from: 0, to: 50, color: Color(0xFF111111)),
        GaugeZone(from: 50, to: 100, color: Color(0xFF222222)),
      ]);
      const b = GaugeAxis(zones: [
        GaugeZone(from: 50, to: 100, color: Color(0xFF222222)),
        GaugeZone(from: 0, to: 50, color: Color(0xFF111111)),
      ]);
      expect(a, isNot(equals(b)));
    });

    test('equal when zone lists are structurally equal', () {
      const a = GaugeAxis(zones: [
        GaugeZone(from: 0, to: 50, color: Color(0xFF111111)),
      ]);
      const b = GaugeAxis(zones: [
        GaugeZone(from: 0, to: 50, color: Color(0xFF111111)),
      ]);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('differs on pointer', () {
      expect(
        const GaugeAxis(
          pointer: GaugePointer.circle(radius: 4, color: Color(0xFF000000)),
        ),
        isNot(equals(const GaugeAxis(
          pointer: GaugePointer.circle(radius: 8, color: Color(0xFF000000)),
        ))),
      );
    });

    test('differs on progressBar', () {
      expect(
        const GaugeAxis(
          progressBar: GaugeProgressBar.basic(color: Color(0xFF111111)),
        ),
        isNot(equals(const GaugeAxis(
          progressBar: GaugeProgressBar.basic(color: Color(0xFF222222)),
        ))),
      );
    });
  });

  group('GaugePointerPosition ==/hashCode', () {
    test('identical instances are equal', () {
      const a = GaugePointerPosition.surface();
      const b = GaugePointerPosition.surface();
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('differs on anchor (surface vs center)', () {
      expect(
        const GaugePointerPosition.surface(),
        isNot(equals(const GaugePointerPosition.center())),
      );
    });

    test('differs on offset', () {
      expect(
        const GaugePointerPosition.surface(offset: Offset.zero),
        isNot(equals(const GaugePointerPosition.surface(offset: Offset(1, 0)))),
      );
    });
  });

  group('GaugePointerBorder ==/hashCode', () {
    test('identical instances are equal', () {
      const a = GaugePointerBorder(color: Color(0xFF111111), width: 2);
      const b = GaugePointerBorder(color: Color(0xFF111111), width: 2);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('differs on color', () {
      expect(
        const GaugePointerBorder(color: Color(0xFF111111), width: 2),
        isNot(equals(
            const GaugePointerBorder(color: Color(0xFF222222), width: 2))),
      );
    });

    test('differs on width', () {
      expect(
        const GaugePointerBorder(color: Color(0xFF111111), width: 1),
        isNot(equals(
            const GaugePointerBorder(color: Color(0xFF111111), width: 2))),
      );
    });
  });

  group('NeedlePointer ==/hashCode', () {
    const baseline = NeedlePointer(
      width: 10,
      height: 20,
      color: Color(0xFF111111),
    );

    test('identical instances are equal', () {
      expect(
        baseline,
        equals(const NeedlePointer(
          width: 10,
          height: 20,
          color: Color(0xFF111111),
        )),
      );
      expect(
        baseline.hashCode,
        equals(const NeedlePointer(
          width: 10,
          height: 20,
          color: Color(0xFF111111),
        ).hashCode),
      );
    });

    test('differs on width', () {
      expect(
        baseline,
        isNot(equals(const NeedlePointer(
          width: 12,
          height: 20,
          color: Color(0xFF111111),
        ))),
      );
    });

    test('differs on height', () {
      expect(
        baseline,
        isNot(equals(const NeedlePointer(
          width: 10,
          height: 22,
          color: Color(0xFF111111),
        ))),
      );
    });

    test('differs on borderRadius', () {
      expect(
        const NeedlePointer(
          width: 10,
          height: 20,
          color: Color(0xFF111111),
          borderRadius: 2,
        ),
        isNot(equals(const NeedlePointer(
          width: 10,
          height: 20,
          color: Color(0xFF111111),
          borderRadius: 4,
        ))),
      );
    });

    test('differs on shadow (regression: previously omitted)', () {
      expect(
        baseline,
        isNot(equals(const NeedlePointer(
          width: 10,
          height: 20,
          color: Color(0xFF111111),
          shadow: Shadow(blurRadius: 2),
        ))),
      );
    });

    test('differs on gradient (regression: previously omitted)', () {
      expect(
        const NeedlePointer(
          width: 10,
          height: 20,
          gradient: LinearGradient(
            colors: [Color(0xFF000000), Color(0xFFFFFFFF)],
          ),
        ),
        isNot(equals(const NeedlePointer(
          width: 10,
          height: 20,
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFF000000)],
          ),
        ))),
      );
    });
  });

  group('CirclePointer ==/hashCode', () {
    const baseline = CirclePointer(radius: 5, color: Color(0xFF111111));

    test('identical instances are equal', () {
      expect(
        baseline,
        equals(const CirclePointer(radius: 5, color: Color(0xFF111111))),
      );
      expect(
        baseline.hashCode,
        equals(
            const CirclePointer(radius: 5, color: Color(0xFF111111)).hashCode),
      );
    });

    test('differs on radius', () {
      expect(
        baseline,
        isNot(equals(const CirclePointer(radius: 8, color: Color(0xFF111111)))),
      );
    });

    test('differs on color', () {
      expect(
        baseline,
        isNot(equals(const CirclePointer(radius: 5, color: Color(0xFF222222)))),
      );
    });

    test('differs on shadow', () {
      expect(
        baseline,
        isNot(equals(const CirclePointer(
          radius: 5,
          color: Color(0xFF111111),
          shadow: Shadow(blurRadius: 2),
        ))),
      );
    });
  });

  group('TrianglePointer ==/hashCode', () {
    const baseline = TrianglePointer(
      width: 10,
      height: 20,
      color: Color(0xFF111111),
    );

    test('identical instances are equal', () {
      expect(
        baseline,
        equals(const TrianglePointer(
          width: 10,
          height: 20,
          color: Color(0xFF111111),
        )),
      );
      expect(
        baseline.hashCode,
        equals(const TrianglePointer(
          width: 10,
          height: 20,
          color: Color(0xFF111111),
        ).hashCode),
      );
    });

    test('differs on shadow (regression: previously omitted)', () {
      expect(
        baseline,
        isNot(equals(const TrianglePointer(
          width: 10,
          height: 20,
          color: Color(0xFF111111),
          shadow: Shadow(blurRadius: 2),
        ))),
      );
    });

    test('differs on gradient (regression: previously omitted)', () {
      expect(
        const TrianglePointer(
          width: 10,
          height: 20,
          gradient: LinearGradient(
            colors: [Color(0xFF000000), Color(0xFFFFFFFF)],
          ),
        ),
        isNot(equals(const TrianglePointer(
          width: 10,
          height: 20,
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFF000000)],
          ),
        ))),
      );
    });

    test('NeedlePointer and TrianglePointer with same fields are not equal',
        () {
      const needle = NeedlePointer(
        width: 10,
        height: 20,
        color: Color(0xFF111111),
      );
      const triangle = TrianglePointer(
        width: 10,
        height: 20,
        color: Color(0xFF111111),
      );
      expect(needle, isNot(equals(triangle)));
    });
  });

  group('GaugeBasicProgressBar ==/hashCode', () {
    test('identical instances are equal', () {
      const a = GaugeBasicProgressBar(color: Color(0xFF111111));
      const b = GaugeBasicProgressBar(color: Color(0xFF111111));
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('differs on color', () {
      expect(
        const GaugeBasicProgressBar(color: Color(0xFF111111)),
        isNot(equals(const GaugeBasicProgressBar(color: Color(0xFF222222)))),
      );
    });

    test('differs on placement', () {
      expect(
        const GaugeBasicProgressBar(
          color: Color(0xFF111111),
          placement: GaugeProgressPlacement.over,
        ),
        isNot(equals(const GaugeBasicProgressBar(
          color: Color(0xFF111111),
          placement: GaugeProgressPlacement.inside,
        ))),
      );
    });

    test('not equal to GaugeRoundedProgressBar with same fields', () {
      expect(
        const GaugeBasicProgressBar(color: Color(0xFF111111)),
        isNot(equals(const GaugeRoundedProgressBar(color: Color(0xFF111111)))),
      );
    });
  });

  group('GaugeRoundedProgressBar ==/hashCode', () {
    test('identical instances are equal', () {
      const a = GaugeRoundedProgressBar(color: Color(0xFF111111));
      const b = GaugeRoundedProgressBar(color: Color(0xFF111111));
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('differs on placement', () {
      expect(
        const GaugeRoundedProgressBar(
          color: Color(0xFF111111),
          placement: GaugeProgressPlacement.over,
        ),
        isNot(equals(const GaugeRoundedProgressBar(
          color: Color(0xFF111111),
          placement: GaugeProgressPlacement.inside,
        ))),
      );
    });
  });
}
