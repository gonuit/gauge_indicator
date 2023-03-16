import 'package:flutter/painting.dart';

import '../radial_gauge/data/data.dart';

/// Split overlapping segments into non-overlapping.
///
/// By default segments colors are blended.
Iterable<GaugeSegment> flattenSegments(
  final List<GaugeSegment> segments, {
  bool colorBlending = true,
}) sync* {
  final points = segments.fold<Set<double>>(
    <double>{},
    (set, segment) => set
      ..add(segment.from)
      ..add(segment.to),
  ).toList()
    ..sort((a, b) => a.compareTo(b));

  for (var i = 0; i < points.length - 1; i++) {
    final start = points[i];
    final end = points[i + 1];

    final includedSegments = segments.where(
      (s) => start >= s.from && end <= s.to,
    );

    if (includedSegments.isEmpty) continue;

    final lastSegment = includedSegments.last;

    final color = colorBlending
        ? includedSegments
            .skip(1)
            .fold<HSVColor>(
                HSVColor.fromColor(includedSegments.first.color),
                (val, next) =>
                    HSVColor.lerp(val, HSVColor.fromColor(next.color), 0.5)!)
            .toColor()
        : lastSegment.color;

    yield GaugeSegment(
      from: start,
      to: end,
      color: color,
      gradient: lastSegment.gradient,
      shader: lastSegment.shader,
      cornerRadius: lastSegment.cornerRadius,
    );
  }
}
