import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/src/internal.dart';

/// Builds the centered content of an [AnimatedRadialGauge] with access to
/// the current animated [value]. The [child] is the gauge's optional child
/// widget, passed through unchanged.
typedef GaugeLabelBuilder = Widget Function(
  BuildContext context,
  Widget? child,
  double value,
);

/// Animated version of [RadialGauge] that gradually changes its values over
/// a period of time.
///
/// Whenever the [value], [axis], or [radius] are changed, the gauge smoothly
/// transitions from the old values to the new ones over [duration] using
/// [curve]. There's no animation controller to manage — just rebuild with new
/// props and the transition happens.
///
/// To follow the animated value during the transition (for example, a label
/// that counts up, or external effects like a shader speed), provide a
/// [builder] or [onAnimationFrame] callback.
///
/// ```dart
/// AnimatedRadialGauge(
///   duration: const Duration(milliseconds: 800),
///   curve: Curves.easeOutCubic,
///   value: speed,
///   axis: const GaugeAxis(min: 0, max: 100, sweepDegrees: 270),
///   builder: (context, child, value) => Text(value.toStringAsFixed(0)),
/// )
/// ```
class AnimatedRadialGauge extends ImplicitlyAnimatedWidget {
  /// The value from which the initial animation starts before tweening to
  /// [value].
  final double initialValue;

  /// {@macro gauge_indicator.RadialGauge.value}
  final double value;

  /// {@macro gauge_indicator.RadialGauge.axis}
  final GaugeAxis axis;

  /// {@macro gauge_indicator.RadialGauge.alignment}
  final Alignment alignment;

  /// {@macro gauge_indicator.RadialGauge.debug}
  final bool debug;

  /// {@macro gauge_indicator.RadialGauge.radius}
  final double? radius;

  /// Optional child painted at the center of the gauge.
  final Widget? child;

  /// Builds the center content with access to the current animated [value].
  /// When provided, replaces [child].
  final GaugeLabelBuilder? builder;

  /// {@macro gauge_indicator.RadialGauge.repaint}
  final Listenable? repaint;

  /// Fires on every animation frame with the current interpolated value,
  /// clamped to `[axis.min, axis.max]`.
  final ValueChanged<double>? onAnimationFrame;

  /// Creates an animated radial gauge. [value], [duration], and [curve]
  /// drive how the gauge transitions when the props change.
  const AnimatedRadialGauge({
    super.key,
    this.initialValue = 0.0,
    required super.duration,
    required this.value,
    this.builder,
    this.axis = const GaugeAxis(),
    super.curve,
    this.alignment = Alignment.center,
    this.radius,
    this.debug = false,
    this.child,
    this.repaint,
    this.onAnimationFrame,
    super.onEnd,
  });

  @override
  AnimatedWidgetBaseState<AnimatedRadialGauge> createState() =>
      _AnimatedRadialGaugeState();
}

class _AnimatedRadialGaugeState
    extends AnimatedWidgetBaseState<AnimatedRadialGauge> {
  bool _isInitialAnimation = true;

  Tween<double>? _valueTween;
  Tween<double?>? _radiusTween;
  GaugeAxisTween? _axisTween;

  @override
  void initState() {
    super.initState();
    controller
      ..addListener(_emitFrame)
      ..value = 0.0
      ..forward().whenCompleteOrCancel(() {
        _isInitialAnimation = false;
      });
  }

  void _emitFrame() {
    final tween = _valueTween;
    final callback = widget.onAnimationFrame;
    if (tween == null || callback == null) return;
    callback(tween.evaluate(animation).clamp(widget.axis.min, widget.axis.max));
  }

  @override
  void dispose() {
    controller.removeListener(_emitFrame);
    super.dispose();
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _axisTween = visitor(
      _axisTween,
      widget.axis,
      (dynamic value) => GaugeAxisTween(
        begin: value as GaugeAxis,
        end: value,
      ),
    ) as GaugeAxisTween;
    _valueTween = visitor(
      _valueTween,
      widget.value,
      (dynamic value) => Tween<double>(
        begin: widget.initialValue,
        end: widget.value,
      ),
    ) as Tween<double>;

    _radiusTween = widget.radius == null
        // If the radius is not specified, its animation is disabled.
        ? NullTween()
        : visitor(
            _radiusTween,
            widget.radius,
            (dynamic value) => Tween<double?>(
              begin: value,
              end: value,
            ),
          ) as Tween<double?>;
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Builder(
        builder: (context) {
          final value = _valueTween!.evaluate(animation).clamp(
                widget.axis.min,
                widget.axis.max,
              );

          final radius = _radiusTween!.evaluate(animation);
          final computedAxis = _axisTween!.evaluate(animation)!.flatten();

          final axis = computedAxis.transform(
            range: GaugeRange(widget.axis.min, widget.axis.max),
            progress: controller.value,
            value: value,
            isInitial: _isInitialAnimation,
          );

          return RadialGauge(
            debug: widget.debug,
            value: value,
            radius: radius,
            alignment: widget.alignment,
            axis: axis,
            repaint: widget.repaint,
            child: widget.builder?.call(context, widget.child, value) ??
                widget.child,
          );
        },
      ),
    );
  }
}
