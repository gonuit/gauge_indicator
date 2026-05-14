import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

/// A self-driving gauge: a [Timer.periodic] runs a random walk on the BPM
/// value and [AnimatedRadialGauge] tweens between updates. The progress bar
/// uses a sweep [GaugeAxisGradient] so its color smoothly shifts from green
/// to red as the BPM climbs, and the heart icon pulses at the live BPM.
class LiveHeartRateExample extends StatefulWidget {
  const LiveHeartRateExample({super.key});

  @override
  State<LiveHeartRateExample> createState() => _LiveHeartRateExampleState();
}

class _LiveHeartRateExampleState extends State<LiveHeartRateExample>
    with SingleTickerProviderStateMixin {
  static const _min = 50.0;
  static const _max = 180.0;

  final _random = math.Random();
  late final Timer _timer;
  late final AnimationController _pulse;
  double _bpm = 72;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: _pulseDurationFor(_bpm),
    )..repeat(reverse: true);

    _timer = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      final delta = (_random.nextDouble() - 0.5) * 40;
      final next = (_bpm + delta).clamp(_min, _max);
      setState(() => _bpm = next);
      _pulse
        ..stop()
        ..duration = _pulseDurationFor(next)
        ..repeat(reverse: true);
    });
  }

  /// One half-cycle of the heart icon scale animation. Two halves (forward
  /// and reverse) make a full beat, so half-cycle = 30s / bpm.
  Duration _pulseDurationFor(double bpm) =>
      Duration(milliseconds: (30000 / bpm).round());

  @override
  void dispose() {
    _timer.cancel();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Gauge(value: _bpm, pulse: _pulse),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFFA114F),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'LIVE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
                color: Color(0xFF6B7691),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Names for each heart rate band, picked by the value's position on the axis.
const _zoneLabel = GaugeLabelProvider.categories([
  LabelCategory(50, 90, 'Resting'),
  LabelCategory(90, 130, 'Cardio'),
  LabelCategory(130, 180, 'Peak'),
]);

class _Gauge extends StatelessWidget {
  final double value;
  final Animation<double> pulse;

  const _Gauge({required this.value, required this.pulse});

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
          min: 50,
          max: 180,
          sweepDegrees: 240,
          pointer: null,

          /// A rounded progress bar with a sweep gradient — the colour at the
          /// tip reflects the current BPM zone without any extra logic.
          progressBar: GaugeProgressBar.rounded(
            placement: GaugeProgressPlacement.inside,
            gradient: GaugeAxisGradient(
              colors: [
                Color(0xFF34D399),
                Color(0xFFF59E0B),
                Color(0xFFFA114F),
              ],

              /// Stops align with the 90/130 BPM zone boundaries on the
              /// 50–180 axis: (90 - 50) / 130 ≈ 0.31, (130 - 50) / 130 ≈ 0.62.
              colorStops: [0.0, 0.31, 0.62],
            ),
          ),
          style: GaugeAxisStyle(
            background: Color(0xFFF3F4F8),
            thickness: 22,
            cornerRadius: Radius.circular(11),
          ),
        ),
        builder: (context, _, value) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: Tween<double>(begin: 0.85, end: 1.0).animate(
                  CurvedAnimation(parent: pulse, curve: Curves.easeInOut),
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Color(0xFFFA114F),
                  size: 28,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value.toStringAsFixed(0),
                style: const TextStyle(
                  color: Color(0xFF002E5F),
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'BPM · ${_zoneLabel.getLabel(value)}',
                style: const TextStyle(
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
