import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

/// Demonstrates a custom [GaugeAxisTransformer] that highlights only the
/// segment containing the current value — every other segment fades to a
/// neutral gray.
///
/// The gauge itself lives in [_Gauge] below — everything in this widget is
/// just the [Slider] wiring that drives it.
class ActiveZoneExample extends StatefulWidget {
  const ActiveZoneExample({super.key});

  @override
  State<ActiveZoneExample> createState() => _ActiveZoneExampleState();
}

class _ActiveZoneExampleState extends State<ActiveZoneExample> {
  double value = 45;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Gauge(value: value),
        const SizedBox(height: 24),
        SizedBox(
          width: 280,
          child: Slider(
            value: value,
            min: 0,
            max: 100,
            onChanged: (v) => setState(() => value = v),
          ),
        ),
      ],
    );
  }
}

/// Each segment covers a range on the axis and paints it with its [color].
const _segments = [
  GaugeSegment(from: 0, to: 60, color: Color(0xFF6FCF97)),
  GaugeSegment(from: 60, to: 85, color: Color(0xFFF2C94C)),
  GaugeSegment(from: 85, to: 100, color: Color(0xFFEB5757)),
];

/// Recolors every segment that doesn't contain [value] to [inactiveColor].
class _ActiveSegmentTransformer extends GaugeAxisTransformer {
  final Color inactiveColor;

  const _ActiveSegmentTransformer({required this.inactiveColor});

  @override
  GaugeAxis transform(
    GaugeAxis axis,
    GaugeRange range,
    double progress,
    double value,
    bool isInitial,
  ) {
    final updated = axis.segments
        .map((s) => value >= s.from && value <= s.to
            ? s
            : s.copyWith(color: inactiveColor))
        .toList();
    return axis.copyWith(segments: updated);
  }
}

class _Gauge extends StatelessWidget {
  final double value;

  const _Gauge({required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 240,
      child: AnimatedRadialGauge(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOut,
        value: value,
        axis: const GaugeAxis(
          min: 0,
          max: 100,
          degrees: 240,
          progressBar: null,
          transformer: _ActiveSegmentTransformer(
            inactiveColor: Color(0xFFD9DEEB),
          ),
          style: GaugeAxisStyle(
            background: Colors.transparent,
            thickness: 24,
            segmentSpacing: 4,
          ),
          pointer: GaugePointer.triangle(
            width: 28,
            height: 28,
            color: Color(0xFF193663),
            borderRadius: 4,
            border: GaugePointerBorder(color: Colors.white, width: 2),
            position: GaugePointerPosition.surface(offset: Offset(0, 12)),
          ),
          segments: _segments,
        ),
      ),
    );
  }
}
