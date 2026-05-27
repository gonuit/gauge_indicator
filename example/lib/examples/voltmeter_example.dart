import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

/// Demonstrates [GaugeAxis.origin] anchored at the middle of the axis.
/// The progress bar fills *outward from the center* — leftward for negative
/// readings, rightward for positive — like a classic analog voltmeter.
///
/// The gauge itself lives in [_Gauge] below — everything in this widget is
/// just the [Slider] wiring that drives it.
class VoltmeterExample extends StatefulWidget {
  const VoltmeterExample({super.key});

  @override
  State<VoltmeterExample> createState() => _VoltmeterExampleState();
}

class _VoltmeterExampleState extends State<VoltmeterExample> {
  double value = 18;

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
            min: -50,
            max: 50,
            onChanged: (v) => setState(() => value = v),
          ),
        ),
      ],
    );
  }
}

class _Gauge extends StatelessWidget {
  final double value;

  const _Gauge({required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 220,
      child: AnimatedRadialGauge(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOut,
        value: value,
        axis: const GaugeAxis(
          min: -50,
          max: 50,

          /// Anchor the progress bar at the centre of the axis.
          origin: 0,
          sweepDegrees: 180,
          style: GaugeAxisStyle(
            thickness: 22,
            background: Color(0xFFE3E8F2),
            cornerRadius: Radius.circular(11),
          ),
          progressBar: GaugeProgressBar.rounded(
            color: Color(0xFF2563EB),
            placement: GaugeProgressPlacement.over,
          ),
          pointer: GaugePointer.needle(
            width: 12,
            height: 90,
            color: Color(0xFF193663),
          ),
        ),
        builder: (context, _, value) => Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${value < 0 ? '-' : '+'}'
                  '${value.abs().toStringAsFixed(1)} V',
                  style: const TextStyle(
                    color: Color(0xFF002E5F),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'VOLTAGE',
                  style: TextStyle(
                    color: Color(0xFF6B7691),
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
