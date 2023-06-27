import 'package:flutter/animation.dart';

/// This animation is used to disable property animation
/// without affecting the logic already in use.
// ignore: prefer_void_to_null
class NullTween extends Tween<Null> {
  /// This animation is used to disable property animation
  /// without affecting the logic already in use.
  NullTween();

  @override
  Null lerp(double t) => null;
}
