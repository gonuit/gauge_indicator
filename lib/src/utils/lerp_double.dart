double lerpDouble(double begin, double end, double t) {
  /// This check is to ensure that the returned value will not differ because
  /// of issues with double calculations
  if (begin == end) {
    return end;
  } else {
    return begin * (1.0 - t) + end * t;
  }
}
