## 0.5.0-beta.7
- Reorganized the README around the examples gallery and trimmed Usage to a minimal install + setup snippet.

## 0.5.0-beta.6
- `GaugeAxis.origin` now defaults to `min` instead of `0.0`, so progress bars on axes that don't include zero render correctly out of the box. An assertion catches origins outside `[min, max]`.
- Added `repaint` parameter on `RadialGauge` / `AnimatedRadialGauge` for paint-only updates driven by an external listenable (e.g. shaders).
- Added `onAnimationFrame` callback on `AnimatedRadialGauge` for reading the interpolated value each frame.
- Renamed `GaugeAxis.degrees` to `sweepDegrees` and `GaugeAxis.zero` to `origin` for clearer intent. Old names remain as deprecated aliases and will be removed in `0.6.0`.
- Renamed `GaugeSegment` to `GaugeZone`, `GaugeAxis.segments` to `zones`, and `GaugeAxisStyle.segmentSpacing` to `zoneSpacing` so the API uses gauge-native vocabulary. Old names remain as deprecated aliases and will be removed in `0.6.0`.
- Added `GaugeAxisStyle.zoneSpacingMode` (`uniform` or `local`) for choosing whether a narrow zone tightens every gap uniformly or only the gaps next to it.
- `GaugeAxisTransformer.progress` now inherits the underlying zones' `cornerRadius` (and other properties) when recolouring, so the masked portion keeps the same shape as the zones it covers.
- On 360° axes, the rounded cap radius now tapers as progress approaches a full revolution, so the end and start caps no longer collide at the seam.
- Added `GaugeZone.label` (`GaugeZoneLabel`) for rendering a text and/or icon label inside the band, laid out along the arc and clipped to the zone ([#12](https://github.com/gonuit/gauge_indicator/issues/12)).
- Narrowed the public API to widgets and their configuration classes; internal utilities are no longer exported.
- Documented all public classes, fields, and constructors.

## 0.5.0-beta.5
- Segments now reach the axis ends instead of leaving a half-spacing gap at the boundaries; their outer caps inherit `GaugeAxisStyle.cornerRadius` so they trace the axis background ([#6](https://github.com/gonuit/gauge_indicator/issues/6)).
- Fixed `GaugeAxisStyle.cornerRadius` changes not triggering a repaint, so the surface now updates when the radius is changed.

## 0.5.0-beta.4
- Fixed rounded progress bar artifact at zero and near-zero values ([#13](https://github.com/gonuit/gauge_indicator/issues/13)).
- `GaugeProgressBar` with `inside` placement now renders without explicit segments and respects the axis corner radius.

## 0.5.0-beta.3
- Fixed pointer shadow ignoring `Shadow.offset`; the shadow is now drawn at the configured offset relative to the pointer ([#14](https://github.com/gonuit/gauge_indicator/issues/14)).

## 0.5.0-beta.2
- Fixed `RadialGauge` segments painting at the parent canvas origin instead of the gauge's position when used without a `RepaintBoundary` (e.g. directly inside a `Padding`, `Row`, or any layout with a non-zero offset) ([#17](https://github.com/gonuit/gauge_indicator/issues/17)).

## 0.5.0-beta.1
- Reworked the example application with a redesigned configuration panel: collapsible sections, interactive segment range editor with add/remove, and animation curve & duration controls.
- Fixed segment corner radius producing distorted shapes when segments are too small to fit the requested radius.
- Fixed segment spacing scaling with the axis degrees instead of staying consistent across different axis spans.
- Fixed inverted segment rendering when the axis is too narrow to fit the requested spacing; spacing now shrinks proportionally to fit.
- Reserved a 1px minimum rendered width per segment so middle segments no longer vanish before edges when the axis is small.
- Spacing is now applied symmetrically to every segment so relative widths are preserved (previously middle segments lost twice the trim of edge segments, which made naturally-wider middle segments appear smaller than narrower edge segments under tight spacing).
- Fixed flickering during animations with overshooting curves (e.g. elastic) by bounding segment positions to the visible axis range.
- Fixed `AnimatedRadialGauge.child` being silently ignored when no `builder` was provided ([#21](https://github.com/gonuit/gauge_indicator/issues/21)).
## 0.4.3
- Support negative values [#7](https://github.com/gonuit/gauge_indicator/pull/7) by [dino-keskic](https://github.com/dino-keskic)
- Added gauge segments border.
- Corrected the readme example. Added *radius* parameter that is required for parent widgets that do not have a constrained size.
- Fixed segment color changes in the example application
## 0.4.2
- Updated package thumbnail image
## 0.4.1
- Fixed the gauge indicator not responding to the progress bar change.
## 0.4.0
- Added factory constructors _GaugeProgressBar_ and _GaugePointer_ classes.
- Fixed the `radius` property of *RadialGauge* and *AnimatedRadialGauge* widgets.
- Added implicit `radius` animation for the *AnimatedRadialGauge* widget.
- Added `cornerRadius` argument for *GaugeAxisStyle* and *GaugeSegment* classes.
- Fixed invalid segment spacing.
- Fixed the basic progress bar for the 360-degree axis.
- Fixed errors that occur when using the *AnimatedRadialGauge* widget without the *radius* property provided.
- Added default style for *RadialGauge* and *AnimatedRadialGauge* widgets to make it easier to get started with the widget.
- Moved *progressBar* property from the widget to the *GaugeAxis* class.
- Made *GaugeProgressBar* constructors constant.
- Minor bug fixes.

## 0.3.3

- Fixed readme file.

## 0.3.0

- Initial release.
