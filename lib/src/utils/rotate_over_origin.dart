import 'package:flutter/material.dart';

/// Rotates over [origin] by the given [rotation] in radians.
Matrix4 rotateOverOrigin({
  required Matrix4 matrix,
  required Offset origin,
  required double rotation,
}) =>
    matrix
      ..translate(origin.dx, origin.dy)
      ..multiply(Matrix4.rotationZ(rotation))
      ..translate(-origin.dx, -origin.dy);
