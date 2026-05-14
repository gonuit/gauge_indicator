<div align="center">
  <h1>Radial gauge</h1>
  <p>Animated, highly customizable, open-source Flutter gauge indicator widget.</p>
  <img src="https://raw.githubusercontent.com/gonuit/gauge_indicator/main/readme/space_gauge.gif" />
  <h3><a href="https://gauge-indicator.klyta.it/">Check out a working example! 🔗</a></h3>
</div>

---

|                                           Progress bar and shader support                                            |                                                  Multiple zones style                                                  |                                                 Gradient support                                                  |
| :------------------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------------------: |
| ![AnimatedRadialGauge](https://raw.githubusercontent.com/gonuit/gauge_indicator/main/readme/shader_progress_bar.gif) | ![AnimatedRadialGauge](https://raw.githubusercontent.com/gonuit/gauge_indicator/main/readme/multiple_segments_styles.gif) | ![AnimatedRadialGauge](https://raw.githubusercontent.com/gonuit/gauge_indicator/main/readme/gradient_support.gif) |

## Usage

Drop a `RadialGauge` or `AnimatedRadialGauge` into your widget tree. The gauge fills its parent, so give it a bounded size with a `SizedBox` (or pass an explicit `radius`).

### Code

```dart
import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class GaugeDemo extends StatelessWidget {
  const GaugeDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 200,
      child: AnimatedRadialGauge(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOut,
        // `value` lives on the [min, max] axis defined below.
        value: 65,
        axis: const GaugeAxis(
          min: 0,
          max: 100,
          sweepDegrees: 180,
          style: GaugeAxisStyle(
            thickness: 20,
            background: Color(0xFFDFE2EC),
          ),
          pointer: GaugePointer.needle(
            width: 16,
            height: 100,
            color: Color(0xFF193663),
          ),
          progressBar: GaugeProgressBar.rounded(
            color: Color(0xFFB4C2F8),
          ),
        ),
      ),
    );
  }
}
```

For colored ranges, custom transformers, and a live playground, see the runnable examples in [`example/lib/examples/`](https://github.com/gonuit/gauge_indicator/tree/main/example/lib/examples) and the [hosted demo](https://gauge-indicator.klyta.it/).

### Output

<div align="center">
  <img src="https://raw.githubusercontent.com/gonuit/gauge_indicator/main/readme/getting_started.gif" />
</div>

## Examples

Click any thumbnail to open it in the [hosted playground](https://gauge-indicator.klyta.it/).

|  |  |  |
| :---: | :---: | :---: |
| [<img src="https://raw.githubusercontent.com/gonuit/gauge_indicator/main/readme/examples/getting-started.png" width="240" alt="Getting started"/>](https://gauge-indicator.klyta.it/examples/getting-started)<br/>**Getting started** | [<img src="https://raw.githubusercontent.com/gonuit/gauge_indicator/main/readme/examples/zones.png" width="240" alt="Zones"/>](https://gauge-indicator.klyta.it/examples/zones)<br/>**Zones** | [<img src="https://raw.githubusercontent.com/gonuit/gauge_indicator/main/readme/examples/active-zone.png" width="240" alt="Active zone"/>](https://gauge-indicator.klyta.it/examples/active-zone)<br/>**Active zone** |
| [<img src="https://raw.githubusercontent.com/gonuit/gauge_indicator/main/readme/examples/zone-labels.png" width="240" alt="Zone labels"/>](https://gauge-indicator.klyta.it/examples/zone-labels)<br/>**Zone labels** | [<img src="https://raw.githubusercontent.com/gonuit/gauge_indicator/main/readme/examples/thermometer.png" width="240" alt="Thermometer"/>](https://gauge-indicator.klyta.it/examples/thermometer)<br/>**Thermometer** | [<img src="https://raw.githubusercontent.com/gonuit/gauge_indicator/main/readme/examples/step-goal.png" width="240" alt="Step goal"/>](https://gauge-indicator.klyta.it/examples/step-goal)<br/>**Step goal** |
| [<img src="https://raw.githubusercontent.com/gonuit/gauge_indicator/main/readme/examples/voltmeter.png" width="240" alt="Voltmeter"/>](https://gauge-indicator.klyta.it/examples/voltmeter)<br/>**Voltmeter** | [<img src="https://raw.githubusercontent.com/gonuit/gauge_indicator/main/readme/examples/activity-rings.png" width="240" alt="Activity rings"/>](https://gauge-indicator.klyta.it/examples/activity-rings)<br/>**Activity rings** | [<img src="https://raw.githubusercontent.com/gonuit/gauge_indicator/main/readme/examples/live-heart-rate.png" width="240" alt="Live heart rate"/>](https://gauge-indicator.klyta.it/examples/live-heart-rate)<br/>**Live heart rate** |
| [<img src="https://raw.githubusercontent.com/gonuit/gauge_indicator/main/readme/examples/rank-progression.png" width="240" alt="Rank progression"/>](https://gauge-indicator.klyta.it/examples/rank-progression)<br/>**Rank progression** | [<img src="https://raw.githubusercontent.com/gonuit/gauge_indicator/main/readme/examples/shader-progress-bar.png" width="240" alt="Progress bar shader"/>](https://gauge-indicator.klyta.it/examples/shader-progress-bar)<br/>**Progress bar shader** |  |