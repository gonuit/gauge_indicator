import 'dart:math' as math;
import 'degrees_to_radians.dart';

/// Calculate circle segment sagitta.
double getSagitta(double degrees, double radius) {
  final chord = 2 * radius * math.sin(toRadians(degrees / 2));

  /// Manipulate the sign to get the sagitta of the larger arc
  final sign = degrees > 180 ? 1 : -1;

  /// Arc sagitta is also the gauge widget height.
  return radius +
      sign * math.sqrt(math.pow(radius, 2) - math.pow(chord / 2, 2));
}
