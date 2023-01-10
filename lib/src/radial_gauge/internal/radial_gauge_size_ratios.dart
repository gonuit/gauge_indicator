import 'package:flutter/rendering.dart';
import 'dart:math' as math;

import 'package:gauge_indicator/gauge_indicator.dart';

/// This class helps to determine the gauge widget size during the layout.
class RadialGaugeSizeRatios {
  /// The radial gauge aspect ratio
  final double aspectRatio;

  /// The radial gauge radius factor.
  ///
  /// It describes the percentage of the radial gauge height that is occupied
  /// by the circle radius.
  final double radiusFactor;

  /// Calculate the radial gauge height based on the ratios and width.
  double getHeight(double width) => width / aspectRatio;

  /// Calculate the radial gauge width based on the ratios and height.
  double getWidth(double height) => height * aspectRatio;

  /// Calculate the radial gauge radius based on the ratios and size.
  double getRadius(Size size) => size.height * radiusFactor;

  /// Calculate the radial gauge size based on the ratios and radius.
  Size getSize(double radius) => Size(radius * 2, getHeight(radius * 2));

  const RadialGaugeSizeRatios({
    required this.aspectRatio,
    required this.radiusFactor,
  });

  /// Calculate gauge indicator ratios.
  ///
  /// Thanks to this method we are able to determine the RenderBox size.
  factory RadialGaugeSizeRatios.fromDegrees(double degrees) {
    /// Target rect aspect ratio is determined by the saggita with
    /// some widget related constraints.
    double getBoundingBoxAspectRatio(double heightFactor) {
      const width = 1.0;
      const halfWidth = width / 2;

      /// Bounding box aspect ratio cannot be smaller than half of the width.
      final height = math.max(halfWidth, heightFactor);

      return width / height;
    }

    /// Degrees needs to be in range of 10.0 - 360.0
    degrees = degrees.clamp(10.0, 360.0);

    const radiusFactor = 0.5;

    /// Arc sagitta is also the gauge widget height.
    final heightFactor = getSagitta(degrees, radiusFactor);

    return RadialGaugeSizeRatios(
      aspectRatio: getBoundingBoxAspectRatio(heightFactor),
      radiusFactor: (radiusFactor / heightFactor.clamp(0.5, 1.0)),
    );
  }
}
