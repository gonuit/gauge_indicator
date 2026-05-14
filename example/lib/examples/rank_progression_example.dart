import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

/// Demonstrates [GaugeAxisTransformer.progress] with [ZoneSpacingMode.local].
/// Each tier is its own colored [GaugeZone]; a transparent-grey transformer
/// overlays the portion beyond the current value, so unearned tiers fade to
/// a neutral track while reached tiers keep their full colour.
///
/// The gauge itself lives in [_Gauge] below — everything in this widget is
/// just the [Slider] wiring that drives it.
class RankProgressionExample extends StatefulWidget {
  const RankProgressionExample({super.key});

  @override
  State<RankProgressionExample> createState() => _RankProgressionExampleState();
}

class _RankProgressionExampleState extends State<RankProgressionExample> {
  double value = 57;

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

/// Five rank tiers with uneven widths — early tiers are quick to clear,
/// later tiers take longer — so [ZoneSpacingMode.local] meaningfully keeps
/// the wide-tier gaps from collapsing around the narrow Bronze / Diamond
/// boundaries.
const _zones = [
  GaugeZone(
    from: 0,
    to: 15,
    color: Color(0xFFCD7F32),
    cornerRadius: Radius.circular(4),
  ),
  GaugeZone(
    from: 15,
    to: 35,
    color: Color(0xFF94A3B8),
    cornerRadius: Radius.circular(4),
  ),
  GaugeZone(
    from: 35,
    to: 60,
    color: Color(0xFFEAB308),
    cornerRadius: Radius.circular(4),
  ),
  GaugeZone(
    from: 60,
    to: 85,
    color: Color(0xFF0EA5E9),
    cornerRadius: Radius.circular(4),
  ),
  GaugeZone(
    from: 85,
    to: 100,
    color: Color(0xFFA855F7),
    cornerRadius: Radius.circular(4),
  ),
];

String _tierName(double value) {
  if (value < 15) return 'BRONZE';
  if (value < 35) return 'SILVER';
  if (value < 60) return 'GOLD';
  if (value < 85) return 'PLATINUM';
  return 'DIAMOND';
}

class _Gauge extends StatelessWidget {
  final double value;

  const _Gauge({required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 240,
      child: AnimatedRadialGauge(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOut,
        value: value,
        axis: const GaugeAxis(
          min: 0,
          max: 100,
          sweepDegrees: 240,
          pointer: null,
          progressBar: null,
          style: GaugeAxisStyle(
            thickness: 28,
            background: Color(0xFFF3F4F8),
            cornerRadius: Radius.circular(14),
            zoneSpacing: 4,
            zoneSpacingMode: ZoneSpacingMode.local,
          ),
          /// Overlay neutral grey on the un-reached portion so completed
          /// tiers keep their colour and future tiers read as placeholders.
          transformer: GaugeAxisTransformer.progress(
            color: Color(0xFFCBD5E1),
            reversed: true,
            blendColors: false,
          ),
          zones: _zones,
        ),
        builder: (context, _, value) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _tierName(value),
                style: const TextStyle(
                  color: Color(0xFF002E5F),
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 4,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${value.toStringAsFixed(0)} / 100',
                style: const TextStyle(
                  color: Color(0xFF6B7691),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
