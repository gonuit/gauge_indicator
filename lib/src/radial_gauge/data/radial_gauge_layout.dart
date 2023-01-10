import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

import '../internal/internal.dart';

/// Defines the radial gauge layout.
/// The layout is defined by the three rects and the radius.
class RadialGaugeLayout {
  final Rect circleRect;
  final Rect targetRect;
  final Rect sourceRect;

  /// The circle radius
  final double radius;

  RadialGaugeLayout({
    required this.circleRect,
    required this.targetRect,
    required this.sourceRect,
    required this.radius,
  });

  /// Calculate the layout based on the [size], [ratios] and
  /// the gauge [alignment].
  factory RadialGaugeLayout.calculate(
    Size size,
    RadialGaugeSizeRatios ratios, {
    Alignment alignment = Alignment.center,
  }) {
    final sourceRect = Offset.zero & size;

    if (!sourceRect.isFinite) {
      throw StateError(
        'Wrap a gauge widget with a SizedBox.',
      );
    }

    final targetSize = applyAspectRatio(sourceRect, ratios.aspectRatio);

    /// Cannot draw larger indicator than available space
    final clampedRadius = ratios.getRadius(targetSize);

    /// Rect of a visible gauge part
    final targetRect = alignment.inscribe(targetSize, sourceRect);

    /// Gauge circle rect
    final circleRect = Rect.fromCircle(
      center: targetRect.topCenter + Offset(0.0, clampedRadius),
      radius: clampedRadius,
    );

    return RadialGaugeLayout(
      circleRect: circleRect,
      targetRect: targetRect,
      sourceRect: sourceRect,
      radius: clampedRadius,
    );
  }

  /// Shift the layout by the provided [offset].
  /// This is used during the paint.
  RadialGaugeLayout shift(Offset offset) => RadialGaugeLayout(
        circleRect: circleRect.shift(offset),
        targetRect: targetRect.shift(offset),
        sourceRect: sourceRect.shift(offset),
        radius: radius,
      );
}
