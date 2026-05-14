// ignore_for_file: public_member_api_docs
import 'package:flutter/painting.dart';

import '../radial_gauge/data/data.dart';

/// Split overlapping zones into non-overlapping.
///
/// By default zone colors are blended.
Iterable<GaugeZone> flattenZones(
  final List<GaugeZone> zones, {
  bool colorBlending = true,
}) sync* {
  final points = zones.fold<Set<double>>(
    <double>{},
    (set, zone) => set
      ..add(zone.from)
      ..add(zone.to),
  ).toList()
    ..sort((a, b) => a.compareTo(b));

  for (var i = 0; i < points.length - 1; i++) {
    final start = points[i];
    final end = points[i + 1];

    final includedZones = zones.where(
      (s) => start >= s.from && end <= s.to,
    );

    if (includedZones.isEmpty) continue;

    final lastZone = includedZones.last;

    final color = colorBlending
        ? includedZones
            .skip(1)
            .fold<HSVColor>(
                HSVColor.fromColor(includedZones.first.color),
                (val, next) =>
                    HSVColor.lerp(val, HSVColor.fromColor(next.color), 0.5)!)
            .toColor()
        : lastZone.color;

    yield GaugeZone(
      from: start,
      to: end,
      color: color,
      gradient: lastZone.gradient,
      shader: lastZone.shader,
      border: lastZone.border,
      cornerRadius: lastZone.cornerRadius,
    );
  }
}
