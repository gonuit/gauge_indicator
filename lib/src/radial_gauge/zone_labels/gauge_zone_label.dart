import 'package:flutter/widgets.dart';

/// Where along a zone's arc the label is anchored.
enum GaugeZoneLabelAlignment {
  /// Pinned to the zone's lower-value edge. Overflow clips on the high side.
  start,

  /// Centered between the zone's [from] and [to]. Overflow clips on both sides.
  center,

  /// Pinned to the zone's higher-value edge. Overflow clips on the low side.
  end,
}

/// A label rendered inside a [GaugeZone], with optional [icon] and [text]
/// laid out along the arc and clipped to the zone so overflow truncates at
/// the boundary.
@immutable
class GaugeZoneLabel {
  /// Text rendered after the icon. May be null for an icon-only label.
  final String? text;

  /// Icon rendered before the text. May be null for a text-only label.
  final IconData? icon;

  /// Gap between [icon] and [text] in logical pixels. Ignored if either is
  /// null.
  final double iconGap;

  /// Text style applied to [text]. Icon color and size are derived from
  /// `style.color` and `style.fontSize`.
  final TextStyle? style;

  /// Where along the zone the label is anchored.
  final GaugeZoneLabelAlignment alignment;

  /// Radial offset from the band centerline, normalized to half-thickness.
  /// `0` is the centerline, `-1` the inner edge, `+1` the outer edge.
  final double radialAlignment;

  /// Inset (in logical pixels) applied at the alignment edge so the label
  /// doesn't kiss the zone boundary.
  final double padding;

  /// Creates a zone label. At least one of [text] or [icon] must be set.
  const GaugeZoneLabel({
    this.text,
    this.icon,
    this.iconGap = 4,
    this.style,
    this.alignment = GaugeZoneLabelAlignment.center,
    this.radialAlignment = 0,
    this.padding = 4,
  }) : assert(
          text != null || icon != null,
          'GaugeZoneLabel requires text or icon (or both).',
        );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GaugeZoneLabel &&
        text == other.text &&
        icon == other.icon &&
        iconGap == other.iconGap &&
        style == other.style &&
        alignment == other.alignment &&
        radialAlignment == other.radialAlignment &&
        padding == other.padding;
  }

  @override
  int get hashCode => Object.hash(
        text,
        icon,
        iconGap,
        style,
        alignment,
        radialAlignment,
        padding,
      );
}
