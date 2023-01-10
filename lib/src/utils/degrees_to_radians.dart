import 'dart:math' as math;

const double radians2Degrees = 180.0 / math.pi;

/// Convert [radians] to degrees.
double toDegrees(double radians) => radians * radians2Degrees;

const double degrees2Radians = math.pi / 180.0;

/// Convert [degrees] to radians.
double toRadians(double degrees) => degrees * degrees2Radians;
