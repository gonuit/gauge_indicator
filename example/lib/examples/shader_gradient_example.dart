import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class ShaderGradientExample extends StatefulWidget {
  const ShaderGradientExample({super.key});

  @override
  State<ShaderGradientExample> createState() => _ShaderGradientExampleState();
}

class _ShaderGradientExampleState extends State<ShaderGradientExample>
    with SingleTickerProviderStateMixin {
  double value = 65;
  ui.FragmentShader? _shader;
  late final Ticker _ticker;
  Duration _lastElapsed = Duration.zero;
  double _scroll = 0;
  double _time = 0;

  @override
  void initState() {
    super.initState();
    _loadShader();
    _ticker = createTicker((elapsed) {
      final dt = (elapsed - _lastElapsed).inMicroseconds / 1000000.0;
      _lastElapsed = elapsed;
      final t = (value / 100).clamp(0.0, 1.0);
      final speed = 8.0 * (0.2 * t + 0.8 * math.pow(t, 6).toDouble());
      _scroll += dt * 6.0 * speed;
      _time += dt * 0.3 * speed;
      setState(() {});
    })
      ..start();
  }

  Future<void> _loadShader() async {
    final program = await ui.FragmentProgram.fromAsset('shaders/space.frag');
    if (!mounted) return;
    setState(() => _shader = program.fragmentShader());
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shader = _shader;
    const gaugeSize = 320.0;

    if (shader != null) {
      shader
        ..setFloat(0, gaugeSize)
        ..setFloat(1, gaugeSize)
        ..setFloat(2, _time)
        ..setFloat(3, _scroll);
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: gaugeSize,
            height: gaugeSize,
            child: AnimatedRadialGauge(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              radius: gaugeSize / 2,
              value: value,
              axis: GaugeAxis(
                min: 0,
                max: 100,
                degrees: 270,
                style: const GaugeAxisStyle(
                  thickness: 48,
                  background: Color(0xFF0B1024),
                  cornerRadius: Radius.circular(24),
                ),
                progressBar: shader != null
                    ? GaugeProgressBar.basic(
                        shader: shader,
                        placement: GaugeProgressPlacement.inside,
                      )
                    : const GaugeProgressBar.basic(
                        color: Color(0xFF6C7AFA),
                        placement: GaugeProgressPlacement.inside,
                      ),
                pointer: const SpaceshipPointer(
                  width: 32,
                  height: 56,
                  color: Color(0xFFFFFFFF),
                  shadow: Shadow(
                    color: Color(0x66000000),
                    offset: Offset(2, 4),
                    blurRadius: 8,
                  ),
                ),
              ),
              builder: (context, child, value) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      value.toStringAsFixed(0),
                      style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'HYPERDRIVE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF000000),
                        letterSpacing: 4,
                      ),
                    ),
                    const Text(
                      '% LIGHTSPEED',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF000000),
                        letterSpacing: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Slider(
              value: value,
              min: 0,
              max: 100,
              onChanged: (v) => setState(() => value = v),
            ),
          ),
        ],
      ),
    );
  }
}

class SpaceshipPointer implements GaugePointer {
  final double width;
  final double height;
  @override
  final Color? color;
  @override
  final Gradient? gradient;
  @override
  final GaugePointerBorder? border;
  @override
  final Shadow? shadow;
  @override
  final GaugePointerPosition position;

  const SpaceshipPointer({
    this.width = 36,
    this.height = 60,
    this.color,
    this.gradient,
    this.border,
    this.shadow,
    this.position = const GaugePointerPosition.surface(),
  });

  @override
  Size get size => Size(width, height);

  @override
  Path get path {
    final w = width;
    final h = height;
    return Path()
      ..moveTo(w * 0.5, 0)
      ..quadraticBezierTo(w * 0.55, h * 0.18, w * 0.62, h * 0.36)
      ..lineTo(w * 0.92, h * 0.66)
      ..lineTo(w, h * 0.74)
      ..lineTo(w * 0.74, h * 0.78)
      ..lineTo(w * 0.62, h * 0.84)
      ..lineTo(w * 0.60, h)
      ..lineTo(w * 0.40, h)
      ..lineTo(w * 0.38, h * 0.84)
      ..lineTo(w * 0.26, h * 0.78)
      ..lineTo(0, h * 0.74)
      ..lineTo(w * 0.08, h * 0.66)
      ..lineTo(w * 0.38, h * 0.36)
      ..quadraticBezierTo(w * 0.45, h * 0.18, w * 0.5, 0)
      ..close();
  }
}
