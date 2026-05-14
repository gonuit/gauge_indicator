import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

/// Air Quality Index (AQI) gauge showcasing per-zone colored drop shadows.
/// Each EPA category gets its own vivid hue and a matching glow underneath,
/// turning the dial into a soft halo of color that tracks the current value.
class AirQualityExample extends StatefulWidget {
  const AirQualityExample({super.key});

  @override
  State<AirQualityExample> createState() => _AirQualityExampleState();
}

class _AirQualityExampleState extends State<AirQualityExample> {
  double value = 78;

  @override
  Widget build(BuildContext context) {
    final category = _categoryFor(value);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0B1020), Color(0xFF161B33)],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x55000000),
                blurRadius: 32,
                offset: Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _CardHeader(),
              const SizedBox(height: 8),
              _Gauge(value: value, category: category),
              const SizedBox(height: 4),
              _CategoryPill(category: category),
              const SizedBox(height: 20),
              _ValueSlider(
                value: value,
                accent: category.color,
                onChanged: (v) => setState(() => value = v),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF1F2547),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.air,
            size: 20,
            color: Color(0xFF8EA0FF),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Downtown · live',
                style: TextStyle(
                  color: Color(0xFF8E97C5),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.4,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Air quality',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.more_horiz,
          color: Color(0xFF6470A0),
          size: 20,
        ),
      ],
    );
  }
}

class _Gauge extends StatelessWidget {
  final double value;
  final _AqiCategory category;

  const _Gauge({required this.value, required this.category});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 220,
      child: AnimatedRadialGauge(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        value: value,
        axis: GaugeAxis(
          min: 0,
          max: 500,
          sweepDegrees: 240,
          progressBar: null,
          pointer: GaugePointer.circle(
            radius: 9,
            color: category.color,
            border: const GaugePointerBorder(
              color: Colors.white,
              width: 3,
            ),
            shadow: Shadow(
              color: category.color.withValues(alpha: 0.9),
              blurRadius: 16,
            ),
          ),
          style: const GaugeAxisStyle(
            background: Colors.transparent,
            thickness: 16,
            zoneSpacing: 6,
            cornerRadius: Radius.circular(8),
          ),
          zones: _zones,
        ),
        builder: (context, _, value) => Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value.toStringAsFixed(0),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 56,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'AQI · US EPA',
                  style: TextStyle(
                    color: Color(0xFF6470A0),
                    fontSize: 10,
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

class _CategoryPill extends StatelessWidget {
  final _AqiCategory category;

  const _CategoryPill({required this.category});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: category.color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: category.color.withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: category.color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: category.color.withValues(alpha: 0.7),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            category.label,
            style: TextStyle(
              color: category.color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _ValueSlider extends StatelessWidget {
  final double value;
  final Color accent;
  final ValueChanged<double> onChanged;

  const _ValueSlider({
    required this.value,
    required this.accent,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
        activeTrackColor: accent,
        inactiveTrackColor: const Color(0xFF2A3061),
        thumbColor: accent,
        overlayColor: accent.withValues(alpha: 0.16),
      ),
      child: Slider(
        value: value,
        min: 0,
        max: 500,
        onChanged: onChanged,
      ),
    );
  }
}

/// EPA Air Quality Index categories — each band gets a vivid color plus a
/// matching `BoxShadow` that bleeds out from under the band as a soft glow.
const _zones = [
  GaugeZone(
    from: 0,
    to: 50,
    color: Color(0xFF34D399),
    cornerRadius: Radius.circular(8),
    shadow: BoxShadow(color: Color(0xCC34D399), blurRadius: 24),
  ),
  GaugeZone(
    from: 50,
    to: 100,
    color: Color(0xFFFACC15),
    cornerRadius: Radius.circular(8),
    shadow: BoxShadow(color: Color(0xCCFACC15), blurRadius: 24),
  ),
  GaugeZone(
    from: 100,
    to: 150,
    color: Color(0xFFFB923C),
    cornerRadius: Radius.circular(8),
    shadow: BoxShadow(color: Color(0xCCFB923C), blurRadius: 24),
  ),
  GaugeZone(
    from: 150,
    to: 200,
    color: Color(0xFFEF4444),
    cornerRadius: Radius.circular(8),
    shadow: BoxShadow(color: Color(0xCCEF4444), blurRadius: 24),
  ),
  GaugeZone(
    from: 200,
    to: 300,
    color: Color(0xFFA855F7),
    cornerRadius: Radius.circular(8),
    shadow: BoxShadow(color: Color(0xCCA855F7), blurRadius: 28),
  ),
  GaugeZone(
    from: 300,
    to: 500,
    color: Color(0xFF7E1E3A),
    cornerRadius: Radius.circular(8),
    shadow: BoxShadow(color: Color(0xCC7E1E3A), blurRadius: 28),
  ),
];

class _AqiCategory {
  final String label;
  final Color color;
  const _AqiCategory(this.label, this.color);
}

_AqiCategory _categoryFor(double v) {
  if (v <= 50) return const _AqiCategory('Good', Color(0xFF34D399));
  if (v <= 100) return const _AqiCategory('Moderate', Color(0xFFFACC15));
  if (v <= 150) {
    return const _AqiCategory('Unhealthy for sensitive', Color(0xFFFB923C));
  }
  if (v <= 200) return const _AqiCategory('Unhealthy', Color(0xFFEF4444));
  if (v <= 300) return const _AqiCategory('Very unhealthy', Color(0xFFA855F7));
  return const _AqiCategory('Hazardous', Color(0xFF7E1E3A));
}
