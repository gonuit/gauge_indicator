// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';

/// Rotates over [origin] by the given [rotation] in radians.
Matrix4 rotateOverOrigin({
  required Matrix4 matrix,
  required Offset origin,
  required double rotation,
}) =>
    matrix
      ..translateByDouble(origin.dx, origin.dy, 0, 1)
      ..multiply(Matrix4.rotationZ(rotation))
      ..translateByDouble(-origin.dx, -origin.dy, 0, 1);
