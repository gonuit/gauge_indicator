import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

/// Demonstrates a [GaugeZone] with a gradient fill — a cold-to-hot
/// thermometer over a negative-to-positive axis.
///
/// The gauge itself lives in [_Gauge] below — everything in this widget is
/// just the [Slider] wiring that drives it.
class ThermometerExample extends StatefulWidget {
  const ThermometerExample({super.key});

  @override
  State<ThermometerExample> createState() => _ThermometerExampleState();
}

class _ThermometerExampleState extends State<ThermometerExample> {
  double value = 22;

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
            min: -60,
            max: 60,
            onChanged: (v) => setState(() => value = v),
          ),
        ),
      ],
    );
  }
}

/// A single zone spans the whole axis and is painted with a sweep gradient
/// that runs from cold to hot.
const _zones = [
  GaugeZone(
    from: -60,
    to: 60,
    gradient: GaugeAxisGradient(
      colors: [
        Color(0xFF1E3A8A),
        Color(0xFF60A5FA),
        Color(0xFFE5E7EB),
        Color(0xFFF59E0B),
        Color(0xFFB91C1C),
      ],
      colorStops: [0.0, 0.3, 0.5, 0.7, 1.0],
    ),
  ),
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
        axis: const GaugeAxis(
          min: -60,
          max: 60,
          sweepDegrees: 240,
          progressBar: null,
          style: GaugeAxisStyle(
            background: Colors.transparent,
            thickness: 22,
          ),
          pointer: GaugePointer.triangle(
            width: 28,
            height: 28,
            color: Color(0xFF193663),
            borderRadius: 4,
            border: GaugePointerBorder(color: Colors.white, width: 2),
            position: GaugePointerPosition.surface(offset: Offset(0, 11)),
          ),
          zones: _zones,
        ),
        builder: (context, _, value) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${value.toStringAsFixed(0)} °C',
                style: const TextStyle(
                  color: Color(0xFF002E5F),
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'TEMPERATURE',
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
