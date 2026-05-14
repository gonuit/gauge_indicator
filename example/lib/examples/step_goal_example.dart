import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

/// Demonstrates a [GaugeProgressBar] with `placement: inside` clipped to
/// many small [GaugeZone]s — the unfilled zones stay gray, and the green
/// progress fill is masked into the zone shapes as the value rises.
///
/// The gauge itself lives in [_Gauge] below — everything in this widget is
/// just the [Slider] wiring that drives it.
class StepGoalExample extends StatefulWidget {
  const StepGoalExample({super.key});

  @override
  State<StepGoalExample> createState() => _StepGoalExampleState();
}

class _StepGoalExampleState extends State<StepGoalExample> {
  double value = 6800;

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
            max: 10000,
            onChanged: (v) => setState(() => value = v),
          ),
        ),
      ],
    );
  }
}

/// Twenty small zones across the 0..10 000 axis act as a tick-like track
/// for the progress bar to fill.
final _zones = [
  for (var i = 0; i < 20; i++)
    GaugeZone(from: i * 500.0, to: (i + 1) * 500.0, color: Color(0xFFE3E8F2)),
];

class _Gauge extends StatelessWidget {
  final double value;

  const _Gauge({required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 260,
      child: AnimatedRadialGauge(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOut,
        value: value,
        axis: GaugeAxis(
          min: 0,
          max: 10000,
          sweepDegrees: 240,
          style: GaugeAxisStyle(
            background: null,
            thickness: 18,
            zoneSpacing: 4,
            cornerRadius: Radius.circular(4),
          ),
          progressBar: GaugeProgressBar.basic(
            placement: GaugeProgressPlacement.inside,
            color: Color(0xFF34D399),
          ),
          zones: _zones,
        ),
        builder: (context, _, value) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value.toStringAsFixed(0),
                style: const TextStyle(
                  color: Color(0xFF002E5F),
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'STEPS / 10 000',
                style: TextStyle(
                  color: Color(0xFF6B7691),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
