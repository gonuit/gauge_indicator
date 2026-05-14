// ignore_for_file: public_member_api_docs
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/src/internal.dart';

/// If a canvas is specified during debugging,
/// the vertices of the arc will be drawn
Path calculateRadiusArcPath(
  Rect rect, {
  required Radius cornerRadius,
  Radius? startCornerRadius,
  Radius? endCornerRadius,
  double from = 0.0,
  double to = 1.0,
  double degrees = 180.0,
  double thickness = 10.0,
  Canvas? canvas,
}) {
  assert(from <= to, 'Cannot draw inverted arc.');

  final radius = rect.longestSide / 2;

  degrees = (degrees).clamp(10.0, 359.99);
  final part = to - from;
  final useDegrees = (degrees * part).clamp(10.0, 359.99);

  final angleShift = (degrees - 180) / 2;
  final gaugeDegreesTween = Tween<double>(
    begin: -180.0 - angleShift,
    end: 0.0 + angleShift,
  );

  final circleCenter = rect.center;
  final halfThickness = thickness / 2;

  final startAngle = gaugeDegreesTween.transform(from);
  final endAngle = gaugeDegreesTween.transform(to);

  final centerRadius = radius - halfThickness;

  Radius startCorner = startCornerRadius ?? cornerRadius;
  Radius endCorner = endCornerRadius ?? cornerRadius;

  /// Scale corner radii down so the two caps don't overlap inside the
  /// rendered arc itself.
  final segmentArcLength =
      centerRadius * toRadians((endAngle - startAngle).abs());
  final totalCornerX = startCorner.x + endCorner.x;
  final inSegmentScale = totalCornerX > segmentArcLength && totalCornerX > 0
      ? segmentArcLength / totalCornerX
      : 1.0;

  /// When the axis is a (nearly) closed ring, also taper the caps as the
  /// empty portion of the ring shrinks below the cap diameter, so the start
  /// and end caps don't collide at 360°.
  final totalArcLength = centerRadius * toRadians(degrees);
  final emptyArcLength = totalArcLength - segmentArcLength;
  final isFullRing = degrees > 359.0;
  final emptyScale =
      isFullRing && totalCornerX > emptyArcLength && totalCornerX > 0
          ? (emptyArcLength / totalCornerX).clamp(0.0, 1.0)
          : 1.0;

  final scale =
      emptyScale < inSegmentScale ? emptyScale : inSegmentScale;
  startCorner = Radius.elliptical(
    startCorner.x * scale,
    (startCorner.y * scale).clamp(0.0, halfThickness),
  );
  endCorner = Radius.elliptical(
    endCorner.x * scale,
    (endCorner.y * scale).clamp(0.0, halfThickness),
  );

  final outerRadius = radius;
  final innerRadius = radius - thickness;

  final centerAxisStartAngle = toRadians(startAngle);
  final centerAxisEndAngle = toRadians(endAngle);

  final startCornerAngle = getArcAngle(startCorner.x, centerRadius);
  final endCornerAngle = getArcAngle(endCorner.x, centerRadius);
  final largeArcMinAngle =
      180.0 + toDegrees(startCornerAngle + endCornerAngle);

  final axisStartAngle = centerAxisStartAngle + startCornerAngle;
  final axisEndAngle = centerAxisEndAngle - endCornerAngle;

  final startOuterPoint =
      getPointOnCircle(circleCenter, axisStartAngle, outerRadius);
  final endOuterPoint =
      getPointOnCircle(circleCenter, axisEndAngle, outerRadius);
  final endOuterCenterPoint = getPointOnCircle(
      circleCenter, centerAxisEndAngle, outerRadius - endCorner.y);
  final endInnerCenterPoint = getPointOnCircle(
      circleCenter, centerAxisEndAngle, innerRadius + endCorner.y);
  final endInnerPoint =
      getPointOnCircle(circleCenter, axisEndAngle, innerRadius);
  final startOuterCenterPoint = getPointOnCircle(
      circleCenter, centerAxisStartAngle, outerRadius - startCorner.y);
  final startInnerCenterPoint = getPointOnCircle(
      circleCenter, centerAxisStartAngle, innerRadius + startCorner.y);
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

  final endRotation = endAngle + 180 + 90;
  final startRotation = startAngle + 180 - 90;

  return Path()
    ..moveTo(startOuterPoint.dx, startOuterPoint.dy)
    ..arcToPoint(
      endOuterPoint,
      largeArc: useDegrees > largeArcMinAngle,
      radius: Radius.circular(outerRadius),
    )
    ..arcToPoint(
      endOuterCenterPoint,
      radius: endCorner,
      rotation: endRotation,
    )
    ..lineTo(endInnerCenterPoint.dx, endInnerCenterPoint.dy)
    ..arcToPoint(
      endInnerPoint,
      radius: endCorner,
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
      radius: startCorner,
      rotation: startRotation,
    )
    ..lineTo(startOuterCenterPoint.dx, startOuterCenterPoint.dy)
    ..arcToPoint(
      startOuterPoint,
      radius: startCorner,
      rotation: startRotation,
    );
}
