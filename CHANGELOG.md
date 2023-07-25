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
