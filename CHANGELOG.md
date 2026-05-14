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
