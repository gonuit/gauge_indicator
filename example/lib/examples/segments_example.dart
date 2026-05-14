import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

/// Demonstrates [GaugeSegment]s as colored threshold zones — a classic
/// dial-meter look where each range carries its own meaning.
///
/// The gauge itself lives in [_Gauge] below — everything in this widget is
/// just the [Slider] wiring that drives it.
class ThresholdZonesExample extends StatefulWidget {
  const ThresholdZonesExample({super.key});

  @override
  State<ThresholdZonesExample> createState() => _ThresholdZonesExampleState();
}

class _ThresholdZonesExampleState extends State<ThresholdZonesExample> {
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
          sweepDegrees: 240,
          progressBar: null,
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
