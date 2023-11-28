import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

Path calculateAxisPath(
  Rect rect, {
  double from = 0.0,
  double to = 1.0,
  double degrees = 180.0,
  double thickness = 10.0,
}) {
  final radius = rect.longestSide / 2;

  degrees = (degrees).clamp(10.0, 359.99);
  final part = to - from;
  final useDegrees = (degrees * part).clamp(10.0, 359.99);

  /// We are shifting arc angles to center it horizontally.
  final angleShift = (degrees - 180) / 2;
  final gaugeDegreesTween = Tween<double>(
    begin: -180.0 - angleShift,
    end: 0.0 + angleShift,
  );

  final circleCenter = rect.center;

  /// Can be helpful for multiple axes support.
  final startAngle = gaugeDegreesTween.transform(from);
  final endAngle = gaugeDegreesTween.transform(to);

  final innerRadius = radius - thickness;
  final outerRadius = radius;

  const largeArcMinAngle = 180.0;

  final axisStartAngle = toRadians(startAngle);
  final axisEndAngle = toRadians(endAngle);

  final startOuterPoint =
      getPointOnCircle(circleCenter, axisStartAngle, outerRadius);
  final endOuterPoint =
      getPointOnCircle(circleCenter, axisEndAngle, outerRadius);
  final endInnerPoint =
      getPointOnCircle(circleCenter, axisEndAngle, innerRadius);
  final startInnerPoint =
      getPointOnCircle(circleCenter, axisStartAngle, innerRadius);

  final axisSurface = Path()
    ..moveTo(
      startOuterPoint.dx,
      startOuterPoint.dy,
    )
    ..arcToPoint(
      endOuterPoint,
      largeArc: useDegrees > largeArcMinAngle,
      radius: Radius.circular(outerRadius),
      clockwise: from < to,
    )
    ..lineTo(
      endInnerPoint.dx,
      endInnerPoint.dy,
    )
    ..arcToPoint(
      startInnerPoint,
      largeArc: useDegrees > largeArcMinAngle,
      radius: Radius.circular(innerRadius),
      clockwise: from > to,
    )
    ..lineTo(
      startOuterPoint.dx,
      startOuterPoint.dy,
    );

  return axisSurface;
}
