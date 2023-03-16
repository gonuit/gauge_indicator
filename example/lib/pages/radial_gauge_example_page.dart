import 'dart:math';

import 'package:example/widgets/color_picker.dart';
import 'package:example/widgets/package_title.dart';
import 'package:example/widgets/value_slider.dart';
import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

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

enum PointerType { needle, triangle, circle }

enum ProgressBarType { rounded, basic }

class RadialGaugeExamplePage extends StatefulWidget {
  const RadialGaugeExamplePage({Key? key}) : super(key: key);

  @override
  State<RadialGaugeExamplePage> createState() => _RadialGaugeExamplePageState();
}

class _RadialGaugeExamplePageState extends State<RadialGaugeExamplePage>
    with AutomaticKeepAliveClientMixin {
  double value = 65;
  double _sliderValue = 65;
  double _degree = 260;
  bool _hasPointer = true;
  bool _hasProgressBar = true;
  Color _progressBarColor = Colors.red;
  Color _backgroundColor = Colors.transparent;
  Color _pointerColor = const Color(0xFF002E5F);
  double _parentWidth = 270;
  double _parentHeight = 270;
  double _gaugeRadius = 250;
  double _thickness = 20;
  double _spacing = 4;
  double _fontSize = 46;
  double _pointerSize = 26;
  var _pointerType = PointerType.needle;
  var _progressBarPlacement = GaugeProgressPlacement.over;
  var _progressBarType = ProgressBarType.rounded;

  var _segments = <GaugeSegment>[
    const GaugeSegment(
      from: 0,
      to: 60.0,
      color: Color(0xFFD9DEEB),
    ),
    const GaugeSegment(
      from: 60.0,
      to: 85.0,
      color: Color(0xFFD9DEEB),
    ),
    const GaugeSegment(
      from: 85.0,
      to: 100,
      color: Color(0xFFD9DEEB),
    ),
  ];

  @override
  bool get wantKeepAlive => true;

  void _randomizeSegments() {
    final random = Random();
    final a = random.nextDouble() * 100;
    final b = random.nextDouble() * 100;
    final stops = a > b ? [b, a] : [a, b];
    setState(() {
      _segments = <GaugeSegment>[
        GaugeSegment(
          from: 0,
          to: stops[0],
          color: colors[random.nextInt(colors.length)],
        ),
        GaugeSegment(
          from: stops[0],
          to: stops[1],
          color: colors[random.nextInt(colors.length)],
        ),
        GaugeSegment(
          from: stops[1],
          to: 100,
          color: colors[random.nextInt(colors.length)],
        ),
      ];
    });
  }

  GaugePointer getPointer(PointerType pointerType) {
    switch (pointerType) {
      case PointerType.needle:
        return GaugePointer.needle(
          size: Size(_pointerSize * 0.625, _pointerSize * 4),
          color: _pointerColor,
          position: GaugePointerPosition.center(
            offset: Offset(0, _pointerSize * 0.3125),
          ),
        );
      case PointerType.triangle:
        return GaugePointer.triangle(
          size: _pointerSize,
          borderRadius: _pointerSize * 0.125,
          color: _pointerColor,
          position: GaugePointerPosition.surface(
            offset: Offset(0, _thickness * 0.6),
          ),
          border: GaugePointerBorder(
            color: Colors.white,
            width: _pointerSize * 0.125,
          ),
        );
      case PointerType.circle:
        return GaugePointer.circle(
          radius: _pointerSize * 0.5,
          color: _pointerColor,
          border: GaugePointerBorder(
            color: Colors.white,
            width: _pointerSize * 0.125,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border(right: BorderSide(color: Color(0xFFDDDDDD))),
              ),
              width: 350,
              child: Column(
                children: [
                  const PageTitle(title: 'gauge_indicator'),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      children: [
                        ValueSlider(
                          label: "Value",
                          min: 0,
                          max: 100,
                          value: _sliderValue,
                          onChanged: (val) {
                            setState(() {
                              _sliderValue =
                                  double.parse(val.toStringAsFixed(2));
                            });
                          },
                          onChangeEnd: (newVal) {
                            setState(() {
                              value = newVal;
                            });
                          },
                        ),
                        ValueSlider(
                          label: "Degrees",
                          min: 30,
                          max: 360,
                          value: _degree,
                          onChanged: (val) {
                            setState(() {
                              _degree = double.parse(val.toStringAsFixed(2));
                            });
                          },
                        ),
                        ValueSlider(
                          label: "Thickness",
                          min: 5,
                          max: 40,
                          value: _thickness,
                          onChanged: (val) {
                            setState(() {
                              _thickness = double.parse(val.toStringAsFixed(2));
                            });
                          },
                        ),
                        ValueSlider(
                          label: "Spacing",
                          min: 0,
                          max: 20,
                          value: _spacing,
                          onChanged: (val) {
                            setState(() {
                              _spacing = double.parse(val.toStringAsFixed(2));
                            });
                          },
                        ),
                        ValueSlider(
                          label: "Font size",
                          min: 8,
                          max: 48,
                          value: _fontSize,
                          onChanged: (val) {
                            setState(() {
                              _fontSize = double.parse(val.toStringAsFixed(2));
                            });
                          },
                        ),
                        ValueSlider(
                          label: "Gauge radius",
                          min: 50,
                          max: 250,
                          value: _gaugeRadius,
                          onChanged: (val) {
                            setState(() {
                              _gaugeRadius =
                                  double.parse(val.toStringAsFixed(2));
                            });
                          },
                        ),
                        ValueSlider(
                          label: "Parent height",
                          min: 150,
                          max: 500,
                          value: _parentHeight,
                          onChanged: (val) {
                            setState(() {
                              _parentHeight =
                                  double.parse(val.toStringAsFixed(2));
                            });
                          },
                        ),
                        ValueSlider(
                          label: "Parent width",
                          min: 150,
                          max: 500,
                          value: _parentWidth,
                          onChanged: (val) {
                            setState(() {
                              _parentWidth =
                                  double.parse(val.toStringAsFixed(2));
                            });
                          },
                        ),
                        const Divider(),
                        ColorField(
                          title: "Background color",
                          color: _backgroundColor,
                          onColorChanged: (c) => setState(() {
                            _backgroundColor = c;
                          }),
                        ),
                        ColorField(
                          title: "Segment 1 color",
                          color: _segments[0].color,
                          onColorChanged: (c) => setState(() {
                            _segments[0] = _segments[0].copyWith(
                              color: c,
                            );
                          }),
                        ),
                        ColorField(
                          title: "Segment 2 color",
                          color: _segments[1].color,
                          onColorChanged: (c) => setState(() {
                            _segments[1] = _segments[1].copyWith(
                              color: c,
                            );
                          }),
                        ),
                        ColorField(
                          title: "Segment 3 color",
                          color: _segments[2].color,
                          onColorChanged: (c) => setState(() {
                            _segments[2] = _segments[2].copyWith(
                              color: c,
                            );
                          }),
                        ),
                        const Divider(),
                        CheckboxListTile(
                            title: const Text("Has progress bar"),
                            value: _hasProgressBar,
                            onChanged: (selected) {
                              if (selected != null) {
                                setState(() {
                                  _hasProgressBar = selected;
                                });
                              }
                            }),
                        if (_hasProgressBar)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: DropdownButton<GaugeProgressPlacement>(
                              items: [
                                for (final val in GaugeProgressPlacement.values)
                                  DropdownMenuItem(
                                    child: Text("Placement: ${val.name}"),
                                    value: val,
                                  )
                              ],
                              value: _progressBarPlacement,
                              onChanged: (val) {
                                if (val == null) return;
                                setState(() {
                                  _progressBarPlacement = val;
                                });
                              },
                            ),
                          ),
                        if (_hasProgressBar)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: DropdownButton<ProgressBarType>(
                              items: [
                                for (final val in ProgressBarType.values)
                                  DropdownMenuItem(
                                    child: Text("Type: ${val.name}"),
                                    value: val,
                                  )
                              ],
                              value: _progressBarType,
                              onChanged: (val) {
                                if (val == null) return;
                                setState(() {
                                  _progressBarType = val;
                                });
                              },
                            ),
                          ),
                        if (_hasProgressBar)
                          ColorField(
                            title: "Select progress bar color",
                            color: _progressBarColor,
                            onColorChanged: (c) => setState(() {
                              _progressBarColor = c;
                            }),
                          ),
                        const Divider(),
                        CheckboxListTile(
                            title: const Text("Has pointer"),
                            value: _hasPointer,
                            onChanged: (selected) async {
                              if (selected != null) {
                                setState(() {
                                  _hasPointer = selected;
                                });
                              }
                            }),
                        if (_hasPointer)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: DropdownButton<PointerType>(
                              items: [
                                for (final val in PointerType.values)
                                  DropdownMenuItem(
                                    child: Text("Type: ${val.name}"),
                                    value: val,
                                  )
                              ],
                              value: _pointerType,
                              onChanged: (val) {
                                if (val == null) return;
                                setState(() {
                                  _pointerType = val;
                                });
                              },
                            ),
                          ),
                        if (_hasPointer)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: ValueSlider(
                              label: "Pointer size",
                              min: 16,
                              max: 36,
                              value: _pointerSize,
                              onChanged: (val) {
                                setState(() {
                                  _pointerSize = val;
                                });
                              },
                            ),
                          ),
                        if (_hasPointer)
                          ColorField(
                            title: "Pointer color",
                            color: _pointerColor,
                            onColorChanged: (c) => setState(() {
                              _pointerColor = c;
                            }),
                          ),
                        const Divider(),
                        Center(
                          child: ElevatedButton(
                            onPressed: _randomizeSegments,
                            child: const Text("Randomize segments"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFEFEFEF),
                      ),
                    ),
                    width: _parentWidth,
                    height: _parentHeight,
                    child: AnimatedRadialGauge(
                      radius: _gaugeRadius,
                      builder: _hasPointer && _pointerType == PointerType.needle
                          ? null
                          : (context, _, value) => RadialGaugeLabel(
                                style: TextStyle(
                                  color: const Color(0xFF002E5F),
                                  fontSize: _fontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                                value: value,
                              ),
                      duration: const Duration(milliseconds: 2000),
                      curve: Curves.elasticOut,
                      value: value,
                      progressBar: _hasProgressBar
                          ? _getProgressBar(_progressBarType)
                          : null,
                      axis: GaugeAxis(
                        degrees: _degree,
                        pointer: _hasPointer ? getPointer(_pointerType) : null,
                        transformer: const GaugeAxisTransformer.colorFadeIn(
                          interval: Interval(0.0, 0.3),
                          background: Color(0xFFD9DEEB),
                        ),
                        style: GaugeAxisStyle(
                          thickness: _thickness,
                          background: _backgroundColor,
                          segmentSpacing: _spacing,
                          blendColors: false,
                        ),
                        segments: _segments,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  GaugeProgressBar _getProgressBar(ProgressBarType progressBarType) {
    switch (progressBarType) {
      case ProgressBarType.rounded:
        return GaugeProgressBar.rounded(
          color: _progressBarColor,
          placement: _progressBarPlacement,
        );
      case ProgressBarType.basic:
        return GaugeProgressBar.basic(
          color: _progressBarColor,
          placement: _progressBarPlacement,
        );
    }
  }
}
