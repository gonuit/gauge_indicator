import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

/// Demonstrates composing multiple [AnimatedRadialGauge]s in a [Stack] to
/// build Apple-Activity-style concentric rings. Each ring is its own gauge
/// with a 360° sweep and a faded track behind a gradient progress bar.
///
/// The rings live in [_Rings] below — everything in this widget is just the
/// per-ring [Slider]s that drive them.
class ActivityRingsExample extends StatefulWidget {
  const ActivityRingsExample({super.key});

  @override
  State<ActivityRingsExample> createState() => _ActivityRingsExampleState();
}

class _ActivityRingsExampleState extends State<ActivityRingsExample> {
  double move = 78;
  double exercise = 55;
  double stand = 92;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Rings(move: move, exercise: exercise, stand: stand),
        const SizedBox(height: 24),
        SizedBox(
          width: 320,
          child: Column(
            children: [
              _RingSlider(
                label: 'Move',
                color: _moveColor,
                value: move,
                onChanged: (v) => setState(() => move = v),
              ),
              _RingSlider(
                label: 'Exercise',
                color: _exerciseColor,
                value: exercise,
                onChanged: (v) => setState(() => exercise = v),
              ),
              _RingSlider(
                label: 'Stand',
                color: _standColor,
                value: stand,
                onChanged: (v) => setState(() => stand = v),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

const _moveColor = Color(0xFFFA114F);
const _exerciseColor = Color(0xFF92E82A);
const _standColor = Color(0xFF1EEAEF);

class _Rings extends StatelessWidget {
  final double move;
  final double exercise;
  final double stand;

  const _Rings({
    required this.move,
    required this.exercise,
    required this.stand,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _Ring(value: move, color: _moveColor, size: 240),
          _Ring(value: exercise, color: _exerciseColor, size: 184),
          _Ring(value: stand, color: _standColor, size: 128),
        ],
      ),
    );
  }
}

class _Ring extends StatelessWidget {
  final double value;
  final Color color;
  final double size;

  const _Ring({required this.value, required this.color, required this.size});

  static const double _thickness = 22;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedRadialGauge(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOut,
        radius: size / 2,
        value: value,
        axis: GaugeAxis(
          min: 0,
          max: 100,
          sweepDegrees: 360,
          pointer: null,
          style: GaugeAxisStyle(
            thickness: _thickness,
            background: color.withValues(alpha: 0.2),
            cornerRadius: Radius.zero,
          ),
          progressBar: GaugeProgressBar.rounded(
            color: color,
            placement: GaugeProgressPlacement.over,
          ),
        ),
      ),
    );
  }
}

class _RingSlider extends StatelessWidget {
  final String label;
  final Color color;
  final double value;
  final ValueChanged<double> onChanged;

  const _RingSlider({
    required this.label,
    required this.color,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 64,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF002E5F),
            ),
          ),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: 0,
            max: 100,
            activeColor: color,
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 44,
          child: Text(
            '${value.toStringAsFixed(0)}%',
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              color: Color(0xFF6B7691),
            ),
          ),
        ),
      ],
    );
  }
}
