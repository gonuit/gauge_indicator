import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

/// Demonstrates a custom [GaugeAxisTransformer] that highlights only the
/// zone containing the current value — every other zone fades to a neutral
/// gray. The center label uses [GaugeLabelProvider.categories] to show a
/// different word per zone instead of the numeric value.
///
/// The gauge itself lives in [_Gauge] below — everything in this widget is
/// just the [Slider] wiring that drives it.
class ActiveZoneExample extends StatefulWidget {
  const ActiveZoneExample({super.key});

  @override
  State<ActiveZoneExample> createState() => _ActiveZoneExampleState();
}

class _ActiveZoneExampleState extends State<ActiveZoneExample> {
  double value = 90;

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

/// Each zone covers a range on the axis and paints it with its [color].
const _zones = [
  GaugeZone(from: 0, to: 60, color: Color(0xFF6FCF97)),
  GaugeZone(from: 60, to: 85, color: Color(0xFFF2C94C)),
  GaugeZone(from: 85, to: 100, color: Color(0xFFEB5757)),
];

/// One label per zone, matching the ranges in [_zones].
const _labelProvider = GaugeLabelProvider.categories([
  LabelCategory(0, 60, 'Low'),
  LabelCategory(60, 85, 'Medium'),
  LabelCategory(85, 100, 'High'),
]);

/// Recolors every zone that doesn't contain [value] to [inactiveColor].
class _ActiveZoneTransformer extends GaugeAxisTransformer {
  final Color inactiveColor;

  const _ActiveZoneTransformer({required this.inactiveColor});

  @override
  GaugeAxis transform(
    GaugeAxis axis,
    GaugeRange range,
    double progress,
    double value,
    bool isInitial,
  ) {
    final updated = axis.zones
        .map((z) => value >= z.from && value <= z.to
            ? z
            : z.copyWith(color: inactiveColor))
        .toList();
    return axis.copyWith(zones: updated);
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
        builder: (context, child, value) => RadialGaugeLabel(
          value: value,
          labelProvider: _labelProvider,
          style: const TextStyle(
            color: Color(0xFF193663),
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        axis: const GaugeAxis(
          min: 0,
          max: 100,
          sweepDegrees: 240,
          progressBar: null,
          transformer: _ActiveZoneTransformer(
            inactiveColor: Color(0xFFD9DEEB),
          ),
          style: GaugeAxisStyle(
            background: Colors.transparent,
            thickness: 24,
            zoneSpacing: 4,
          ),
          pointer: GaugePointer.triangle(
            width: 28,
            height: 28,
            color: Color(0xFF193663),
            borderRadius: 4,
            border: GaugePointerBorder(color: Colors.white, width: 2),
            position: GaugePointerPosition.surface(offset: Offset(0, 12)),
          ),
          zones: _zones,
        ),
      ),
    );
  }
}
