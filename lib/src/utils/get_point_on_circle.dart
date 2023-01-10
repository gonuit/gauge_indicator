import 'dart:ui';
import 'dart:math' as math;

Offset getPointOnCircle(Offset offset, double angle, double radius) {
  final x = math.cos(angle) * radius;
  final y = math.sin(angle) * radius;
  return offset + Offset(x, y);
}
