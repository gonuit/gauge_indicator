import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

/// A minimal, runnable starter example for [AnimatedRadialGauge].
///
/// The gauge itself lives in [_Gauge] below — everything in this widget is
/// just the [Slider] wiring that drives it.
class GettingStartedExample extends StatefulWidget {
  const GettingStartedExample({super.key});

  @override
  State<GettingStartedExample> createState() => _GettingStartedExampleState();
}

class _GettingStartedExampleState extends State<GettingStartedExample> {
  double value = 65;

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

class _Gauge extends StatelessWidget {
  final double value;

  const _Gauge({required this.value});

  @override
  Widget build(BuildContext context) {
    /// The gauge fills its parent. Give it a bounded size with a
    /// [SizedBox], or pass an explicit `radius` to the gauge itself.
    return SizedBox(
      width: 280,
      height: 200,
      child: AnimatedRadialGauge(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOut,
        value: value,
        axis: const GaugeAxis(
          min: 0,
          max: 100,
          sweepDegrees: 180,
          style: GaugeAxisStyle(thickness: 20, background: Color(0xFFDFE2EC)),
          pointer: GaugePointer.needle(
            width: 16,
            height: 100,
            color: Color(0xFF193663),
          ),
          progressBar: GaugeProgressBar.rounded(color: Color(0xFFB4C2F8)),
        ),
      ),
    );
  }
}
