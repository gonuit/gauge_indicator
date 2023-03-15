import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

import '../internal/internal.dart';

extension on Rect {
  bool includes(Rect other) {
    return width >= other.width &&
        height >= other.height &&
        left <= other.left &&
        right >= other.right &&
        top <= other.top &&
        bottom >= other.bottom;
  }
}

extension on BoxConstraints {
  bool canFitIn(Size size) {
    return maxWidth >= size.width && maxHeight >= size.height;
  }
}

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
    BoxConstraints constraints,
    RadialGaugeSizeRatios ratios, {
    double? preferredRadius,
    Alignment alignment = Alignment.center,
  }) {
    Size? preferredSize;
    if (preferredRadius != null) {
      preferredSize = ratios.getSize(preferredRadius);
      // Gauge can be fitted in the provided constraints
      final canFitGaugeInTheConstraints = constraints.canFitIn(preferredSize);
      // If the gauge fits within the constraints, align it in this space
      if (canFitGaugeInTheConstraints) {
        // Returns the size close as possible to the preferred one.
        // This is used as the source rect.
        final sourceSize = constraints.constrain(preferredSize);
        final sourceRect = Offset.zero & sourceSize;

        if (!sourceRect.isFinite) {
          throw StateError(
            'Wrap a gauge widget with a SizedBox.',
          );
        }

        /// Rect of a visible gauge part
        final targetRect = alignment.inscribe(preferredSize, sourceRect);

        /// Gauge circle rect
        final circleRect = Rect.fromCircle(
          center: targetRect.topCenter + Offset(0.0, preferredRadius),
          radius: preferredRadius,
        );

        return RadialGaugeLayout(
          circleRect: circleRect,
          targetRect: targetRect,
          sourceRect: sourceRect,
          radius: preferredRadius,
        );
      }
    }

    final Size sourceSize;
    if (constraints.isTight) {
      sourceSize = constraints.smallest;
    } else if (constraints.hasTightHeight) {
      final height = constraints.minHeight;
      sourceSize = constraints.constrain(Size(
        ratios.getWidth(height),
        height,
      ));
    } else if (constraints.hasTightWidth) {
      final width = constraints.minWidth;
      sourceSize = constraints.constrain(Size(
        width,
        ratios.getHeight(width),
      ));
    } else {
      // For infinite dimensions the [radius] needs to be specified.
      sourceSize = constraints.constrain(preferredSize ?? Size.zero);
    }

    final sourceRect = Offset.zero & sourceSize;
    if (!sourceRect.isFinite) {
      throw StateError(
        'Wrap a gauge widget with a SizedBox.',
      );
    }

    final Size targetSize;
    if (preferredRadius != null) {
      final preferredSize2 = ratios.getSize(preferredRadius);
      final preferredRect = Offset.zero & preferredSize2;

      targetSize = sourceRect.includes(preferredRect)
          ? preferredSize2
          : applyAspectRatio(sourceRect, ratios.aspectRatio);
    } else {
      targetSize = applyAspectRatio(sourceRect, ratios.aspectRatio);
    }

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
