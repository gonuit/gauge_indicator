import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

/// Demonstrates labels rendered inside [GaugeZone]s. Each zone carries an
/// optional [GaugeZoneLabel] (text and/or icon) that follows the arc tangent
/// and clips to the zone's path when the band is too narrow.
///
/// Drag the slider down to shrink the red zone and watch its label clip
/// gracefully at the boundary instead of overflowing the next zone.
class ZoneLabelsExample extends StatefulWidget {
  const ZoneLabelsExample({super.key});

  @override
  State<ZoneLabelsExample> createState() => _ZoneLabelsExampleState();
}

class _ZoneLabelsExampleState extends State<ZoneLabelsExample> {
  double redCutoff = 75;
  double value = 67;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Gauge(value: value, redCutoff: redCutoff),
        const SizedBox(height: 24),
        SizedBox(
          width: 280,
          child: Column(
            children: [
              const Text('value'),
              Slider(
                value: value,
                min: 0,
                max: 100,
                onChanged: (v) => setState(() => value = v),
              ),
              const Text('red zone start (shrinks the red zone)'),
              Slider(
                value: redCutoff,
                min: 60,
                max: 100,
                onChanged: (v) => setState(() => redCutoff = v),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

const _labelStyle = TextStyle(
  color: Colors.white,
  fontSize: 11,
  fontWeight: FontWeight.w600,
);

class _Gauge extends StatelessWidget {
  final double value;
  final double redCutoff;

  const _Gauge({required this.value, required this.redCutoff});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 260,
      child: AnimatedRadialGauge(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOut,
        value: value,
        axis: GaugeAxis(
          min: 0,
          max: 100,
          sweepDegrees: 240,
          progressBar: null,
          style: const GaugeAxisStyle(
            background: Colors.transparent,
            thickness: 28,
            zoneSpacing: 4,
          ),
          pointer: const GaugePointer.triangle(
            width: 28,
            height: 28,
            color: Color(0xFF193663),
            borderRadius: 4,
            border: GaugePointerBorder(color: Colors.white, width: 2),
            position: GaugePointerPosition.surface(offset: Offset(0, 12)),
          ),
          zones: [
            GaugeZone(
              from: 0,
              to: 60,
              color: const Color(0xFF6FCF97),
              label: const GaugeZoneLabel(
                icon: Icons.thumb_up,
                text: 'Low',
                style: _labelStyle,
                alignment: GaugeZoneLabelAlignment.end,
                padding: 8,
              ),
            ),
            GaugeZone(
              from: 60,
              to: redCutoff,
              color: const Color(0xFFF2C94C),
              label: const GaugeZoneLabel(
                text: 'Medium',
                style: _labelStyle,
                padding: 8,
              ),
            ),
            GaugeZone(
              from: redCutoff,
              to: 100,
              color: const Color(0xFFEB5757),
              label: const GaugeZoneLabel(
                icon: Icons.warning_amber,
                text: 'High',
                style: _labelStyle,
                alignment: GaugeZoneLabelAlignment.start,
                padding: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
