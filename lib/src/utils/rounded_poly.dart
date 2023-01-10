import 'dart:math' as math;
import 'dart:ui';

class VertexDefinition {
  final double x;
  final double y;
  final double? radius;

  final double distance;

  VertexDefinition(
    this.x,
    this.y, {
    this.radius,
  }) : distance = math.sqrt(x * x + y * y);

  double get nx {
    return x / distance;
  }

  double get ny {
    return y / distance;
  }

  double get direction {
    return math.atan2(ny, nx);
  }

  VertexDefinition operator -(VertexDefinition def) =>
      VertexDefinition(x - def.x, y - def.y);
}

/// Returns a [Path] that describes the rounded polygon.
Path roundedPoly(
  List<VertexDefinition> vertices,
  double radiusAll,
) {
  var radius = radiusAll;
  late double cRadius;

  final verticesCount = vertices.length;
  var p1 = vertices[verticesCount - 1];

  final path = Path();
  for (int i = 0; i < verticesCount; i++) {
    var p2 = vertices[i % verticesCount];
    final p3 = vertices[(i + 1) % verticesCount];

    final v1 = p1 - p2;
    final v2 = p3 - p2;
    final sinA = v1.nx * v2.ny - v1.ny * v2.nx;
    final sinA90 = v1.nx * v2.nx - v1.ny * -v2.ny;
    var angle = math.asin(sinA < -1
        ? -1
        : sinA > 1
            ? 1
            : sinA);

    int radDirection = 1;
    bool drawDirection = false;
    if (sinA90 < 0) {
      if (angle < 0) {
        angle = math.pi + angle;
      } else {
        angle = math.pi - angle;
        radDirection = -1;
        drawDirection = true;
      }
    } else {
      if (angle > 0) {
        radDirection = -1;
        drawDirection = true;
      }
    }

    if (p2.radius != null) {
      radius = p2.radius!;
    } else {
      radius = radiusAll;
    }

    final halfAngle = angle / 2;

    var lenOut = (math.cos(halfAngle) * radius / math.sin(halfAngle)).abs();

    if (lenOut > math.min(v1.distance / 2, v2.distance / 2)) {
      lenOut = math.min(v1.distance / 2, v2.distance / 2);
      cRadius = (lenOut * math.sin(halfAngle) / math.cos(halfAngle)).abs();
    } else {
      cRadius = radius;
    }

    var x = p2.x + v2.nx * lenOut;
    var y = p2.y + v2.ny * lenOut;

    x += -v2.ny * cRadius * radDirection;
    y += v2.nx * cRadius * radDirection;

    final startAngle = v1.direction + math.pi / 2 * radDirection;
    final endAngle = v2.direction - math.pi / 2 * radDirection;

    double toSweepAngle(double startAngle, double endAngle) {
      const circle = math.pi * 2;
      const halfCircle = math.pi;

      final sweepAngle = endAngle - startAngle;

      if (drawDirection && sweepAngle > halfCircle) {
        return sweepAngle - circle;
      } else if (!drawDirection && sweepAngle < halfCircle) {
        return sweepAngle + circle;
      } else {
        return sweepAngle;
      }
    }

    path.arcTo(
      Rect.fromCircle(center: Offset(x, y), radius: cRadius),
      startAngle,
      toSweepAngle(startAngle, endAngle),
      false,
    );

    p1 = p2;
    p2 = p3;
  }
  path.close();

  return path;
}
