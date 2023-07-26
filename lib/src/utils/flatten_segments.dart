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
                HSVColor.fromColor(includedSegments.first.style.color!),
                (val, next) => HSVColor.lerp(
                    val, HSVColor.fromColor(next.style.color!), 0.5)!)
            .toColor()
        : lastSegment.style.color;

    yield GaugeSegment(
      from: start,
      to: end,
      style: lastSegment.style.copyWith(
        color: color,
        border: lastSegment.style.border,
        gradient: lastSegment.style.gradient,
        cornerRadius: lastSegment.style.cornerRadius,
        thickness: lastSegment.style.thickness,
        shader: lastSegment.style.shader,
      ),
    );
  }
}
