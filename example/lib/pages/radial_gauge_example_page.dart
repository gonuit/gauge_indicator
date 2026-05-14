import 'package:example/widgets/color_picker.dart';
import 'package:example/widgets/config_section.dart';
import 'package:example/widgets/package_title.dart';
import 'package:example/widgets/segment_range_editor.dart';
import 'package:example/widgets/value_slider.dart';
import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

import 'dart:math' as math;

import 'gauge_data_controller.dart';

class RadialGaugeExamplePage extends StatefulWidget {
  const RadialGaugeExamplePage({super.key});

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
                duration: _controller.duration,
                curve: _controller.curve,
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
                    background: _controller.hasSurface
                        ? _controller.surfaceColor
                        : null,
                    segmentSpacing: _controller.spacing,
                    blendColors: false,
                    cornerRadius: Radius.circular(_controller.surfaceRadius),
                  ),
                  segments: _controller.segments
                      .map((e) => e.copyWith(
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
    super.key,
    required GaugeDataController controller,
  }) : _controller = controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Material(
              color: Colors.white,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFE3E8F2)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
                child: ValueSlider(
              label: "Value",
              min: 0,
              max: 100,
              value: _controller.sliderValue,
              onChanged: (val) {
                _controller.sliderValue =
                    double.parse(val.toStringAsFixed(2));
              },
              onChangeEnd: (newVal) {
                _controller.value = newVal;
              },
                ),
              ),
            ),
          ),
          ConfigSection(
            title: 'Animation',
            children: [
              LabeledDropdown<String>(
                label: 'Curve',
                value: _controller.curveName,
                items: availableCurves.keys.toList(),
                itemLabel: (s) => s,
                onChanged: (v) => _controller.curveName = v,
              ),
              ValueSlider(
                label: 'Duration',
                min: 100,
                max: 5000,
                value: _controller.duration.inMilliseconds.toDouble(),
                formatValue: (v) => '${v.round()} ms',
                onChanged: (v) => _controller.durationMs = v,
              ),
            ],
          ),
          ConfigSection(
            title: 'Layout',
            initiallyExpanded: true,
            children: [
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
                label: "Gauge radius",
                min: 50,
                max: 250,
                value: _controller.gaugeRadius,
                onChanged: (val) {
                  _controller.gaugeRadius =
                      double.parse(val.toStringAsFixed(2));
                },
              ),
              ValueSlider(
                label: "Parent height",
                min: 150,
                max: 500,
                value: _controller.parentHeight,
                onChanged: (val) {
                  _controller.parentHeight =
                      double.parse(val.toStringAsFixed(2));
                },
              ),
              ValueSlider(
                label: "Parent width",
                min: 150,
                max: 500,
                value: _controller.parentWidth,
                onChanged: (val) {
                  _controller.parentWidth =
                      double.parse(val.toStringAsFixed(2));
                },
              ),
            ],
          ),
          ConfigSection(
            title: 'Style',
            children: [
              ValueSlider(
                label: "Thickness",
                min: 5,
                max: 40,
                value: _controller.thickness,
                onChanged: (val) {
                  _controller.thickness =
                      double.parse(val.toStringAsFixed(2));
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
                label: "Segments radius",
                min: 0,
                max: 20,
                value: _controller.segmentsRadius,
                onChanged: (val) {
                  _controller.segmentsRadius =
                      double.parse(val.toStringAsFixed(2));
                },
              ),
              ValueSlider(
                label: "Font size",
                min: 8,
                max: 48,
                value: _controller.fontSize,
                onChanged: (val) {
                  _controller.fontSize =
                      double.parse(val.toStringAsFixed(2));
                },
              ),
            ],
          ),
          ConfigSection(
            title: 'Surface',
            children: [
              SwitchListTile(
                dense: true,
                title: const Text('Enabled',
                    style: TextStyle(fontSize: 13)),
                value: _controller.hasSurface,
                onChanged: (selected) {
                  _controller.hasSurface = selected;
                },
              ),
              if (_controller.hasSurface) ...[
                ValueSlider(
                  label: "Radius",
                  min: 0,
                  max: 20,
                  value: _controller.surfaceRadius,
                  onChanged: (val) {
                    _controller.surfaceRadius =
                        double.parse(val.toStringAsFixed(2));
                  },
                ),
                ColorField(
                  title: "Color",
                  color: _controller.surfaceColor,
                  onColorChanged: (c) => _controller.surfaceColor = c,
                ),
              ],
            ],
          ),
          ConfigSection(
            title: 'Segments',
            children: [
              SegmentRangeEditor(
                segments: _controller.segments,
                onBoundaryChanged: _controller.setSegmentBoundary,
              ),
              for (var i = 0; i < _controller.segments.length; i++)
                ColorField(
                  key: ValueKey('segment-$i'),
                  title: 'Segment ${i + 1}  ·  '
                      '${_controller.segments[i].from.toStringAsFixed(0)}'
                      '–${_controller.segments[i].to.toStringAsFixed(0)}',
                  color: _controller.segments[i].color,
                  onColorChanged: (c) => _controller.setSegmentColor(i, c),
                  onRemove: () => _controller.removeSegment(i),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _controller.canAddSegment
                          ? _controller.addSegment
                          : null,
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(_controller.canAddSegment
                          ? 'Add'
                          : 'Max ${GaugeDataController.maxSegments} segments'),
                    ),
                    const SizedBox(height: 8),
                    FilledButton.tonalIcon(
                      onPressed: _controller.segments.isEmpty
                          ? null
                          : _controller.randomizeSegments,
                      icon: const Icon(Icons.shuffle, size: 18),
                      label: const Text('Randomize'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ConfigSection(
            title: 'Progress bar',
            children: [
              SwitchListTile(
                dense: true,
                title: const Text('Enabled',
                    style: TextStyle(fontSize: 13)),
                value: _controller.hasProgressBar,
                onChanged: (selected) {
                  _controller.hasProgressBar = selected;
                },
              ),
              if (_controller.hasProgressBar) ...[
                LabeledSegmented<GaugeProgressPlacement>(
                  label: 'Placement',
                  value: _controller.progressBarPlacement,
                  values: GaugeProgressPlacement.values,
                  labelOf: (v) => v.name,
                  iconOf: (v) => switch (v) {
                    GaugeProgressPlacement.inside =>
                      Icons.center_focus_strong_outlined,
                    GaugeProgressPlacement.over => Icons.layers_outlined,
                  },
                  onChanged: (v) => _controller.progressBarPlacement = v,
                ),
                LabeledSegmented<ProgressBarType>(
                  label: 'Type',
                  value: _controller.progressBarType,
                  values: ProgressBarType.values,
                  labelOf: (v) => v.name,
                  iconOf: (v) => v == ProgressBarType.rounded
                      ? Icons.rounded_corner
                      : Icons.crop_square,
                  onChanged: (v) => _controller.progressBarType = v,
                ),
                ColorField(
                  title: "Color",
                  color: _controller.progressBarColor,
                  onColorChanged: (c) => _controller.progressBarColor = c,
                ),
              ],
            ],
          ),
          ConfigSection(
            title: 'Pointer',
            children: [
              SwitchListTile(
                dense: true,
                title: const Text('Enabled',
                    style: TextStyle(fontSize: 13)),
                value: _controller.hasPointer,
                onChanged: (selected) {
                  _controller.hasPointer = selected;
                },
              ),
              if (_controller.hasPointer) ...[
                LabeledSegmented<PointerType>(
                  label: 'Type',
                  value: _controller.pointerType,
                  values: PointerType.values,
                  labelOf: (v) => switch (v) {
                    PointerType.needle => 'Needle',
                    PointerType.triangle => 'Triangle',
                    PointerType.circle => 'Circle',
                  },
                  iconOf: (v) => switch (v) {
                    PointerType.needle => Icons.navigation_outlined,
                    PointerType.triangle => Icons.change_history,
                    PointerType.circle => Icons.circle_outlined,
                  },
                  onChanged: (v) => _controller.pointerType = v,
                ),
                ValueSlider(
                  label: "Pointer size",
                  min: 16,
                  max: 36,
                  value: _controller.pointerSize,
                  onChanged: (val) {
                    _controller.pointerSize = val;
                  },
                ),
                ColorField(
                  title: "Color",
                  color: _controller.pointerColor,
                  onColorChanged: (c) => _controller.pointerColor = c,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
