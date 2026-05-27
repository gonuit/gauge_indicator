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

const availableCurves = <String, Curve>{
  'elasticOut': Curves.elasticOut,
  'elasticIn': Curves.elasticIn,
  'elasticInOut': Curves.elasticInOut,
  'easeOut': Curves.easeOut,
  'easeIn': Curves.easeIn,
  'easeInOut': Curves.easeInOut,
  'easeOutBack': Curves.easeOutBack,
  'easeInBack': Curves.easeInBack,
  'easeInOutBack': Curves.easeInOutBack,
  'bounceOut': Curves.bounceOut,
  'bounceIn': Curves.bounceIn,
  'bounceInOut': Curves.bounceInOut,
  'fastOutSlowIn': Curves.fastOutSlowIn,
  'decelerate': Curves.decelerate,
  'linear': Curves.linear,
};

class GaugeDataController extends ChangeNotifier {
  String _curveName = 'elasticOut';
  String get curveName => _curveName;
  Curve get curve => availableCurves[_curveName] ?? Curves.elasticOut;
  set curveName(String value) {
    if (value != _curveName && availableCurves.containsKey(value)) {
      _curveName = value;
      notifyListeners();
    }
  }

  Duration _duration = const Duration(milliseconds: 2000);
  Duration get duration => _duration;
  set durationMs(double ms) {
    final v = Duration(milliseconds: ms.round());
    if (v != _duration) {
      _duration = v;
      notifyListeners();
    }
  }

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

  double _zonesRadius = 8;
  double get zonesRadius => _zonesRadius;
  set zonesRadius(double value) {
    if (value != zonesRadius) {
      _zonesRadius = value;
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

  bool _hasSurface = false;
  bool get hasSurface => _hasSurface;
  set hasSurface(bool value) {
    if (value != hasSurface) {
      _hasSurface = value;
      notifyListeners();
    }
  }

  Color _surfaceColor = const Color(0xFFD9DEEB);
  Color get surfaceColor => _surfaceColor;
  set surfaceColor(Color value) {
    if (value != surfaceColor) {
      _surfaceColor = value;
      notifyListeners();
    }
  }

  double _surfaceRadius = 8;
  double get surfaceRadius => _surfaceRadius;
  set surfaceRadius(double value) {
    if (value != surfaceRadius) {
      _surfaceRadius = value;
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

  List<GaugeZone> get zones => _zones;
  set zones(List<GaugeZone> value) {
    if (value != zones) {
      _zones = value;
      notifyListeners();
    }
  }

  List<GaugeZone> _zones = <GaugeZone>[
    const GaugeZone(
      from: 0,
      to: 60.0,
      color: Color(0xFFD9DEEB),
      cornerRadius: Radius.zero,
    ),
    const GaugeZone(
      from: 60.0,
      to: 85.0,
      color: Color(0xFFD9DEEB),
      cornerRadius: Radius.zero,
    ),
    const GaugeZone(
      from: 85.0,
      to: 100,
      color: Color(0xFFD9DEEB),
      cornerRadius: Radius.zero,
    ),
  ];

  static const double minZoneSize = 2;

  void randomizeZones() {
    final count = zones.length;
    if (count == 0) return;
    final random = math.Random();
    const span = 100.0;
    final free = span - count * minZoneSize;
    final stops = <double>[0, free];
    for (var i = 0; i < count - 1; i++) {
      stops.add(random.nextDouble() * free);
    }
    stops.sort();
    zones = [
      for (var i = 0; i < count; i++)
        GaugeZone(
          from: stops[i] + i * minZoneSize,
          to: stops[i + 1] + (i + 1) * minZoneSize,
          color: colors[random.nextInt(colors.length)],
          cornerRadius: Radius.zero,
        ),
    ];
  }

  static const int maxZones = 10;

  bool get canAddZone => zones.length < maxZones;

  void addZone() {
    if (!canAddZone) return;
    final random = math.Random();
    final color = colors[random.nextInt(colors.length)];
    if (zones.isEmpty) {
      zones = [
        GaugeZone(from: 0, to: 100, color: color, cornerRadius: Radius.zero),
      ];
      return;
    }
    final n = zones.length;
    final scale = n / (n + 1);
    final start = zones.first.from;
    final end = zones.last.to;

    final next = <GaugeZone>[];
    var cursor = start;
    for (final s in zones) {
      final newSize = (s.to - s.from) * scale;
      next.add(s.copyWith(from: cursor, to: cursor + newSize));
      cursor += newSize;
    }
    next.add(
      GaugeZone(from: cursor, to: end, color: color, cornerRadius: Radius.zero),
    );
    zones = next;
  }

  void setZoneBoundary(int boundaryIndex, double position) {
    if (boundaryIndex < 0 || boundaryIndex >= zones.length - 1) return;
    final left = zones[boundaryIndex];
    final right = zones[boundaryIndex + 1];
    final clamped = position.clamp(left.from, right.to);
    zones = [
      ...zones.sublist(0, boundaryIndex),
      left.copyWith(to: clamped),
      right.copyWith(from: clamped),
      ...zones.sublist(boundaryIndex + 2),
    ];
  }

  void removeZone(int index) {
    RangeError.checkValidIndex(index, zones);
    if (zones.length == 1) {
      zones = const [];
      return;
    }
    final removed = zones[index];
    final next = [...zones]..removeAt(index);
    if (index > 0) {
      next[index - 1] = next[index - 1].copyWith(to: removed.to);
    } else {
      next[0] = next[0].copyWith(from: removed.from);
    }
    zones = next;
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

  void setZoneColor(int index, Color color) {
    RangeError.checkValidIndex(index, zones);

    zones[index] = zones[index].copyWith(color: color);

    notifyListeners();
  }
}
