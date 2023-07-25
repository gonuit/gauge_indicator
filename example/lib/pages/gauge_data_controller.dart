import 'dart:math' as math show Random;

import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

enum PointerType { needle, triangle, circle }

enum ProgressBarType { rounded, basic }

const colors = [
  Colors.green,
  Color(0xFF34C759),
  Colors.amber,
  Colors.red,
  Colors.blue,
  Colors.blueAccent,
  Colors.lightBlue,
  Colors.grey,
  Colors.black,
  Color(0xFFD9DEEB),
];

class GaugeDataController extends ChangeNotifier {
  double _value = 65;
  double get value => _value;
  set value(double val) {
    if (val != value) {
      _value = val;
      notifyListeners();
    }
  }

  double _sliderValue = 65;
  double get sliderValue => _sliderValue;
  set sliderValue(double value) {
    if (sliderValue != value) {
      _sliderValue = value;
      notifyListeners();
    }
  }

  double _degree = 260;
  double get degree => _degree;
  set degree(double value) {
    if (degree != value) {
      _degree = value;
      notifyListeners();
    }
  }

  bool _hasPointer = true;
  bool get hasPointer => _hasPointer;
  set hasPointer(bool value) {
    if (value != hasPointer) {
      _hasPointer = value;
      notifyListeners();
    }
  }

  bool _hasProgressBar = true;
  bool get hasProgressBar => _hasProgressBar;
  set hasProgressBar(bool value) {
    if (value != hasProgressBar) {
      _hasProgressBar = value;
      notifyListeners();
    }
  }

  double _segmentsRadius = 8;
  double get segmentsRadius => _segmentsRadius;
  set segmentsRadius(double value) {
    if (value != segmentsRadius) {
      _segmentsRadius = value;
      notifyListeners();
    }
  }

  Color _progressBarColor = Colors.purple;
  Color get progressBarColor => _progressBarColor;
  set progressBarColor(Color value) {
    if (value != progressBarColor) {
      _progressBarColor = value;
      notifyListeners();
    }
  }

  Color _backgroundColor = Colors.transparent;
  Color get backgroundColor => _backgroundColor;
  set backgroundColor(Color value) {
    if (value != backgroundColor) {
      _backgroundColor = value;
      notifyListeners();
    }
  }

  Color _pointerColor = const Color(0xFF002E5F);
  Color get pointerColor => _pointerColor;
  set pointerColor(Color value) {
    if (value != pointerColor) {
      _pointerColor = value;
      notifyListeners();
    }
  }

  double _parentWidth = 500;
  double get parentWidth => _parentWidth;
  set parentWidth(double value) {
    if (value != parentWidth) {
      _parentWidth = value;
      notifyListeners();
    }
  }

  double _parentHeight = 500;
  double get parentHeight => _parentHeight;
  set parentHeight(double value) {
    if (value != parentHeight) {
      _parentHeight = value;
      notifyListeners();
    }
  }

  double _gaugeRadius = 150;
  double get gaugeRadius => _gaugeRadius;
  set gaugeRadius(double value) {
    if (value != gaugeRadius) {
      _gaugeRadius = value;
      notifyListeners();
    }
  }

  double _thickness = 35;
  double get thickness => _thickness;
  set thickness(double value) {
    if (value != thickness) {
      _thickness = value;
      notifyListeners();
    }
  }

  double _spacing = 8;
  double get spacing => _spacing;
  set spacing(double value) {
    if (value != spacing) {
      _spacing = value;
      notifyListeners();
    }
  }

  double _fontSize = 46;
  double get fontSize => _fontSize;
  set fontSize(double value) {
    if (value != fontSize) {
      _fontSize = value;
      notifyListeners();
    }
  }

  double _pointerSize = 26;
  double get pointerSize => _pointerSize;
  set pointerSize(double value) {
    if (value != pointerSize) {
      _pointerSize = value;
      notifyListeners();
    }
  }

  PointerType _pointerType = PointerType.needle;
  PointerType get pointerType => _pointerType;
  set pointerType(PointerType value) {
    if (value != pointerType) {
      _pointerType = value;
      notifyListeners();
    }
  }

  GaugeProgressPlacement _progressBarPlacement = GaugeProgressPlacement.inside;
  GaugeProgressPlacement get progressBarPlacement => _progressBarPlacement;
  set progressBarPlacement(GaugeProgressPlacement value) {
    if (value != progressBarPlacement) {
      _progressBarPlacement = value;
      notifyListeners();
    }
  }

  ProgressBarType _progressBarType = ProgressBarType.basic;
  ProgressBarType get progressBarType => _progressBarType;
  set progressBarType(ProgressBarType value) {
    if (value != progressBarType) {
      _progressBarType = value;
      notifyListeners();
    }
  }

  GaugePointer getPointer(PointerType pointerType) {
    switch (pointerType) {
      case PointerType.needle:
        return GaugePointer.needle(
          width: pointerSize * 0.625,
          height: pointerSize * 4,
          color: pointerColor,
          position: GaugePointerPosition.center(
            offset: Offset(0, pointerSize * 0.3125),
          ),
        );
      case PointerType.triangle:
        return GaugePointer.triangle(
          width: pointerSize,
          height: pointerSize,
          borderRadius: pointerSize * 0.125,
          color: pointerColor,
          position: GaugePointerPosition.surface(
            offset: Offset(0, thickness * 0.6),
          ),
          border: GaugePointerBorder(
            color: Colors.white,
            width: pointerSize * 0.125,
          ),
        );
      case PointerType.circle:
        return GaugePointer.circle(
          radius: pointerSize * 0.5,
          color: pointerColor,
          border: GaugePointerBorder(
            color: Colors.white,
            width: pointerSize * 0.125,
          ),
        );
    }
  }

  List<GaugeSegment> get segments => _segments;
  set segments(List<GaugeSegment> value) {
    if (value != segments) {
      _segments = value;
      notifyListeners();
    }
  }

  List<GaugeSegment> _segments = <GaugeSegment>[
    const GaugeSegment(
      from: 0,
      to: 60.0,
      color: Color(0xFFD9DEEB),
      cornerRadius: Radius.zero,
    ),
    const GaugeSegment(
      from: 60.0,
      to: 85.0,
      color: Color(0xFFD9DEEB),
      cornerRadius: Radius.zero,
    ),
    const GaugeSegment(
      from: 85.0,
      to: 100,
      color: Color(0xFFD9DEEB),
      cornerRadius: Radius.zero,
    ),
  ];

  void randomizeSegments() {
    final random = math.Random();
    final a = random.nextDouble() * 100;
    final b = random.nextDouble() * 100;
    final stops = a > b ? [b, a] : [a, b];
    segments = <GaugeSegment>[
      GaugeSegment(
        from: 0,
        to: stops[0],
        color: colors[random.nextInt(colors.length)],
        cornerRadius: Radius.zero,
      ),
      GaugeSegment(
        from: stops[0],
        to: stops[1],
        color: colors[random.nextInt(colors.length)],
        cornerRadius: Radius.zero,
      ),
      GaugeSegment(
        from: stops[1],
        to: 100,
        color: colors[random.nextInt(colors.length)],
        cornerRadius: Radius.zero,
      ),
    ];
  }

  GaugeProgressBar getProgressBar(ProgressBarType progressBarType) {
    switch (progressBarType) {
      case ProgressBarType.rounded:
        return GaugeProgressBar.rounded(
          color: progressBarColor,
          placement: progressBarPlacement,
        );
      case ProgressBarType.basic:
        return GaugeProgressBar.basic(
          color: progressBarColor,
          placement: progressBarPlacement,
        );
    }
  }

  void setSegmentColor(int index, Color color) {
    RangeError.checkValidIndex(index, segments);

    segments[index] = segments[index].copyWith(
      color: color,
    );

    notifyListeners();
  }
}
