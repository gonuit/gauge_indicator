import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

/// Demonstrates per-zone [GaugeZone.thickness]. Each zone can be slimmer
/// than the axis surface; values are clamped to `GaugeAxisStyle.thickness`
/// so zones always sit inside the surface band. The progress bar uses the
/// surface thickness, so it covers each zone at the surface size and the
/// zone's own thickness shows through where progress hasn't reached.
class ZoneThicknessExample extends StatefulWidget {
  const ZoneThicknessExample({super.key});

  @override
  State<ZoneThicknessExample> createState() => _ZoneThicknessExampleState();
}

class _ZoneThicknessExampleState extends State<ZoneThicknessExample> {
  double value = 28;
  double midThickness = 8;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Gauge(value: value, midThickness: midThickness),
        const SizedBox(height: 24),
        SizedBox(
          width: 320,
          child: Column(
            children: [
              const Text('value'),
              Slider(
                value: value,
                min: 0,
                max: 100,
                onChanged: (v) => setState(() => value = v),
              ),
              const Text('middle zone thickness'),
              Slider(
                value: midThickness,
                min: 2,
                max: 48,
                onChanged: (v) => setState(() => midThickness = v),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Gauge extends StatelessWidget {
  final double value;
  final double midThickness;

  const _Gauge({required this.value, required this.midThickness});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      height: 260,
      child: AnimatedRadialGauge(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOut,
        value: value,
        axis: GaugeAxis(
          min: 0,
          max: 100,
          sweepDegrees: 220,
          progressBar: const GaugeProgressBar.basic(
            color: Color(0xFF193663),
            placement: GaugeProgressPlacement.inside,
          ),
          pointer: null,
          style: const GaugeAxisStyle(
            background: Color(0xFFF1F2F6),
            thickness: 48,
            zoneSpacing: 4,
            cornerRadius: Radius.circular(24),
          ),
          zones: [
            // Inherits surface — fills the full 48 px band.
            const GaugeZone(
              from: 0,
              to: 33,
              color: Color(0x806FCF97),
              cornerRadius: Radius.circular(24),
            ),
            // Driven by the slider so you can watch it shrink/grow inside
            // the surface band; clamped to surface thickness.
            GaugeZone(
              from: 33,
              to: 66,
              color: const Color(0x80F2C94C),
              cornerRadius: Radius.circular(midThickness / 2),
              thickness: midThickness,
            ),
            // Pinned to half the surface — stays slim regardless of style.
            const GaugeZone(
              from: 66,
              to: 100,
              color: Color(0x80EB5757),
              cornerRadius: Radius.circular(12),
              thickness: 24,
            ),
          ],
        ),
      ),
    );
  }
}
