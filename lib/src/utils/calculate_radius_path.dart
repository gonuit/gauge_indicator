import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

/// If a canvas is specified during debugging,
/// the vertices of the arc will be drawn
Path calculateRadiusArcPath(
  Rect rect, {
  required Radius cornerRadius,
  double from = 0.0,
  double to = 1.0,
  double degrees = 180.0,
  double thickness = 10.0,
  Canvas? canvas,
}) {
  assert(from <= to, 'Cannot draw inverted arc.');

  final radius = rect.longestSide / 2;

  degrees = (degrees).clamp(10.0, 360.0);
  final part = to - from;
  final useDegrees = (degrees * part).clamp(10.0, 360.0);

  /// We are shifting arc angles to center it horizontally.
  final angleShift = (degrees - 180) / 2;
  final gaugeDegreesTween = Tween<double>(
    begin: -180.0 - angleShift,
    end: 0.0 + angleShift,
  );

  final circleCenter = rect.center;

  final halfThickness = thickness / 2;

  /// Can be helpful for multiple axes support.
  final startAngle = gaugeDegreesTween.transform(from);
  final endAngle = gaugeDegreesTween.transform(to);

  final outerRadius = radius;
  final centerOuterRadius = outerRadius - cornerRadius.y;
  final centerRadius = radius - halfThickness;
  final innerRadius = radius - thickness;
  final centerInnerRadius = innerRadius + cornerRadius.y;

  final centerAxisStartAngle = toRadians(startAngle);
  final centerAxisEndAngle = toRadians(endAngle);

  final horizontalCornerAngle = getArcAngle(cornerRadius.x, centerRadius);
  final largeArcMinAngle = 180.0 + toDegrees(horizontalCornerAngle * 2);

  final axisStartAngle = centerAxisStartAngle + horizontalCornerAngle;
  final axisEndAngle = centerAxisEndAngle - horizontalCornerAngle;

  final startOuterPoint =
      getPointOnCircle(circleCenter, axisStartAngle, outerRadius);
  final endOuterPoint =
      getPointOnCircle(circleCenter, axisEndAngle, outerRadius);
  final endOuterCenterPoint =
      getPointOnCircle(circleCenter, centerAxisEndAngle, centerOuterRadius);
  final endInnerCenterPoint =
      getPointOnCircle(circleCenter, centerAxisEndAngle, centerInnerRadius);
  final endInnerPoint =
      getPointOnCircle(circleCenter, axisEndAngle, innerRadius);
  final startOuterCenterPoint =
      getPointOnCircle(circleCenter, centerAxisStartAngle, centerOuterRadius);
  final startInnerCenterPoint =
      getPointOnCircle(circleCenter, centerAxisStartAngle, centerInnerRadius);
  final startInnerPoint =
      getPointOnCircle(circleCenter, axisStartAngle, innerRadius);

  assert(
    (() {
      canvas?.drawPoints(
        PointMode.points,
        [
          startOuterPoint,
          endOuterPoint,
          endOuterCenterPoint,
          endInnerCenterPoint,
          endInnerPoint,
          startOuterCenterPoint,
          startInnerCenterPoint,
          startInnerPoint,
        ],
        Paint()
          ..color = const Color(0xFF000000)
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round,
      );
      return true;
    })(),
    'draw the debug arc vertices',
  );

  // Rotate the arc radius to maintain proper aspect
  final endRotation = endAngle + 180 + 90;
  final startRotation = startAngle + 180 - 90;

  final axisSurface = Path()
    ..moveTo(startOuterPoint.dx, startOuterPoint.dy)
    ..arcToPoint(
      endOuterPoint,
      largeArc: useDegrees > largeArcMinAngle,
      radius: Radius.circular(outerRadius),
    )
    ..arcToPoint(
      endOuterCenterPoint,
      radius: cornerRadius,
      rotation: endRotation,
    )
    ..lineTo(endInnerCenterPoint.dx, endInnerCenterPoint.dy)
    ..arcToPoint(
      endInnerPoint,
      radius: cornerRadius,
      rotation: endRotation,
    )
    ..arcToPoint(
      startInnerPoint,
      largeArc: useDegrees > largeArcMinAngle,
      radius: Radius.circular(innerRadius),
      clockwise: false,
    )
    ..arcToPoint(
      startInnerCenterPoint,
      radius: cornerRadius,
      rotation: startRotation,
    )
    ..lineTo(startOuterCenterPoint.dx, startOuterCenterPoint.dy)
    ..arcToPoint(
      startOuterPoint,
      radius: cornerRadius,
      rotation: startRotation,
    );

  return axisSurface;
}
