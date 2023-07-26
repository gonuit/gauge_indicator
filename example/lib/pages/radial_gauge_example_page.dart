import 'package:example/widgets/color_picker.dart';
import 'package:example/widgets/package_title.dart';
import 'package:example/widgets/value_slider.dart';
import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

import 'dart:math' as math;

import 'gauge_data_controller.dart';

class RadialGaugeExamplePage extends StatefulWidget {
  const RadialGaugeExamplePage({Key? key}) : super(key: key);

  @override
  State<RadialGaugeExamplePage> createState() => _RadialGaugeExamplePageState();
}

class _RadialGaugeExamplePageState extends State<RadialGaugeExamplePage> {
  final _controller = GaugeDataController();

  @override
  Widget build(BuildContext context) {
    final viewSize = MediaQuery.sizeOf(context);
    final isMobile = viewSize.width < 700;

    return Scaffold(
      body: Builder(builder: (context) {
        final gaugeWidget = Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFEFEFEF),
                ),
              ),
              width: _controller.parentWidth,
              height: _controller.parentHeight,
              child: AnimatedRadialGauge(
                radius: _controller.gaugeRadius,
                builder: _controller.hasPointer &&
                        _controller.pointerType == PointerType.needle
                    ? null
                    : (context, _, value) => RadialGaugeLabel(
                          style: TextStyle(
                            color: const Color(0xFF002E5F),
                            fontSize: _controller.fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                          value: value,
                        ),
                duration: const Duration(milliseconds: 2000),
                curve: Curves.elasticOut,
                value: _controller.value,
                axis: GaugeAxis(
                  min: 0,
                  max: 100,
                  degrees: _controller.degree,
                  pointer: _controller.hasPointer
                      ? _controller.getPointer(_controller.pointerType)
                      : null,
                  progressBar: _controller.hasProgressBar
                      ? _controller.getProgressBar(_controller.progressBarType)
                      : null,
                  transformer: const GaugeAxisTransformer.colorFadeIn(
                    interval: Interval(0.0, 0.3),
                    background: Color(0xFFD9DEEB),
                  ),
                  style: GaugeAxisStyle(
                    thickness: _controller.thickness,
                    background: _controller.backgroundColor,
                    segmentSpacing: _controller.spacing,
                    blendColors: false,
                    cornerRadius: Radius.circular(_controller.segmentsRadius),
                  ),
                  segments: _controller.segments
                      .map((e) => e
                        ..style.copyWith(
                            cornerRadius:
                                Radius.circular(_controller.segmentsRadius)))
                      .toList(),
                ),
              ),
            ),
          ),
        );

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const PageTitle(title: 'gauge_indicator', isSmall: true),
              Expanded(
                child: gaugeWidget,
              ),
              SizedBox(
                height: math.min(viewSize.height * 0.6, 400),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border:
                        const Border(top: BorderSide(color: Color(0xFFDDDDDD))),
                  ),
                  child: GaugeConfigPanel(controller: _controller),
                ),
              ),
            ],
          );
        } else {
          return Row(
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
                      child: GaugeConfigPanel(controller: _controller),
                    ),
                  ],
                ),
              ),
              Expanded(child: gaugeWidget),
            ],
          );
        }
      }),
    );
  }
}

class GaugeConfigPanel extends StatelessWidget {
  final GaugeDataController _controller;

  const GaugeConfigPanel({
    Key? key,
    required GaugeDataController controller,
  })  : _controller = controller,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => ListView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        children: [
          ValueSlider(
            label: "Value",
            min: 0,
            max: 100,
            value: _controller.sliderValue,
            onChanged: (val) {
              _controller.sliderValue = double.parse(val.toStringAsFixed(2));
            },
            onChangeEnd: (newVal) {
              _controller.value = newVal;
            },
          ),
          ValueSlider(
            label: "Degrees",
            min: 30,
            max: 360,
            value: _controller.degree,
            onChanged: (val) {
              _controller.degree = double.parse(val.toStringAsFixed(2));
            },
          ),
          ValueSlider(
            label: "Segments radius",
            min: 0,
            max: 20,
            value: _controller.segmentsRadius,
            onChanged: (val) {
              _controller.segmentsRadius = double.parse(val.toStringAsFixed(2));
            },
          ),
          ValueSlider(
            label: "Thickness",
            min: 5,
            max: 40,
            value: _controller.thickness,
            onChanged: (val) {
              _controller.thickness = double.parse(val.toStringAsFixed(2));
            },
          ),
          ValueSlider(
            label: "Spacing",
            min: 0,
            max: 20,
            value: _controller.spacing,
            onChanged: (val) {
              _controller.spacing = double.parse(val.toStringAsFixed(2));
            },
          ),
          ValueSlider(
            label: "Font size",
            min: 8,
            max: 48,
            value: _controller.fontSize,
            onChanged: (val) {
              _controller.fontSize = double.parse(val.toStringAsFixed(2));
            },
          ),
          ValueSlider(
            label: "Gauge radius",
            min: 50,
            max: 250,
            value: _controller.gaugeRadius,
            onChanged: (val) {
              _controller.gaugeRadius = double.parse(val.toStringAsFixed(2));
            },
          ),
          ValueSlider(
            label: "Parent height",
            min: 150,
            max: 500,
            value: _controller.parentHeight,
            onChanged: (val) {
              _controller.parentHeight = double.parse(val.toStringAsFixed(2));
            },
          ),
          ValueSlider(
            label: "Parent width",
            min: 150,
            max: 500,
            value: _controller.parentWidth,
            onChanged: (val) {
              _controller.parentWidth = double.parse(val.toStringAsFixed(2));
            },
          ),
          const Divider(),
          ColorField(
            title: "Background color",
            color: _controller.backgroundColor,
            onColorChanged: (c) => _controller.backgroundColor = c,
          ),
          ColorField(
            title: "Segment 1 color",
            color: _controller.segments[0].style.color!,
            onColorChanged: (c) => _controller.setSegmentColor(0, c),
          ),
          ColorField(
            title: "Segment 2 color",
            color: _controller.segments[1].style.color!,
            onColorChanged: (c) => _controller.setSegmentColor(1, c),
          ),
          ColorField(
            title: "Segment 3 color",
            color: _controller.segments[2].style.color!,
            onColorChanged: (c) => _controller.setSegmentColor(2, c),
          ),
          const Divider(),
          CheckboxListTile(
              title: const Text("Has progress bar"),
              value: _controller.hasProgressBar,
              onChanged: (selected) {
                if (selected != null) {
                  _controller.hasProgressBar = selected;
                }
              }),
          if (_controller.hasProgressBar)
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
                value: _controller.progressBarPlacement,
                onChanged: (val) {
                  if (val == null) return;
                  _controller.progressBarPlacement = val;
                },
              ),
            ),
          if (_controller.hasProgressBar)
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
                value: _controller.progressBarType,
                onChanged: (val) {
                  if (val == null) return;
                  _controller.progressBarType = val;
                },
              ),
            ),
          if (_controller.hasProgressBar)
            ColorField(
              title: "Select progress bar color",
              color: _controller.progressBarColor,
              onColorChanged: (c) => _controller.progressBarColor = c,
            ),
          const Divider(),
          CheckboxListTile(
              title: const Text("Has pointer"),
              value: _controller.hasPointer,
              onChanged: (selected) async {
                if (selected != null) {
                  _controller.hasPointer = selected;
                }
              }),
          if (_controller.hasPointer)
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
                value: _controller.pointerType,
                onChanged: (val) {
                  if (val == null) return;

                  _controller.pointerType = val;
                },
              ),
            ),
          if (_controller.hasPointer)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ValueSlider(
                label: "Pointer size",
                min: 16,
                max: 36,
                value: _controller.pointerSize,
                onChanged: (val) {
                  _controller.pointerSize = val;
                },
              ),
            ),
          if (_controller.hasPointer)
            ColorField(
              title: "Pointer color",
              color: _controller.pointerColor,
              onColorChanged: (c) => _controller.pointerColor = c,
            ),
          const Divider(),
          Center(
            child: ElevatedButton(
              onPressed: _controller.randomizeSegments,
              child: const Text("Randomize segments"),
            ),
          ),
        ],
      ),
    );
  }
}
