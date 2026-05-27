// ignore_for_file: public_member_api_docs
import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/src/internal.dart';

Path calculateRoundedArcPath(
  Rect rect, {
  double from = 0.0,
  double to = 1.0,
  double degrees = 180.0,
  double thickness = 10.0,
}) => calculateRadiusArcPath(
  rect,
  cornerRadius: Radius.circular(thickness / 2),
  from: from < to ? from : to,
  to: from < to ? to : from,
  degrees: degrees,
  thickness: thickness,
);
