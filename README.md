<div align="center">
  <h1>Radial gauge</h1>
  <p>Animated, highly customizable, open-source Flutter gauge indicator widget.</p>
  <img src="https://raw.githubusercontent.com/gonuit/gauge_indicator/854f73cc961899b0820101aa8fc2e68d289b16ee/readme/space_gauge.gif" />
  <h3><a href="https://gauge-indicator.klyta.it/">Check out a working example! 🔗</a></h3>
</div>

---

## Examples

Click any thumbnail to open it in the [hosted playground](https://gauge-indicator.klyta.it/). Source for each lives in [`example/lib/examples/`](https://github.com/gonuit/gauge_indicator/tree/main/example/lib/examples).

|  |  |  |
| :---: | :---: | :---: |
| [<img src="https://raw.githubusercontent.com/gonuit/gauge_indicator/854f73cc961899b0820101aa8fc2e68d289b16ee/readme/examples/getting-started.png" width="240" alt="Getting started"/>](https://gauge-indicator.klyta.it/examples/getting-started)<br/>**Getting started** | [<img src="https://raw.githubusercontent.com/gonuit/gauge_indicator/854f73cc961899b0820101aa8fc2e68d289b16ee/readme/examples/zones.png" width="240" alt="Zones"/>](https://gauge-indicator.klyta.it/examples/zones)<br/>**Zones** | [<img src="https://raw.githubusercontent.com/gonuit/gauge_indicator/854f73cc961899b0820101aa8fc2e68d289b16ee/readme/examples/active-zone.png" width="240" alt="Active zone"/>](https://gauge-indicator.klyta.it/examples/active-zone) <br/>**Active zone** |
| [<img src="https://raw.githubusercontent.com/gonuit/gauge_indicator/854f73cc961899b0820101aa8fc2e68d289b16ee/readme/examples/zone-labels.png" width="240" alt="Zone labels"/>](https://gauge-indicator.klyta.it/examples/zone-labels)<br/>**Zone labels** | [<img src="https://raw.githubusercontent.com/gonuit/gauge_indicator/854f73cc961899b0820101aa8fc2e68d289b16ee/readme/examples/thermometer.png" width="240" alt="Thermometer"/>](https://gauge-indicator.klyta.it/examples/thermometer)<br/>**Thermometer** | [<img src="https://raw.githubusercontent.com/gonuit/gauge_indicator/854f73cc961899b0820101aa8fc2e68d289b16ee/readme/examples/step-goal.png" width="240" alt="Step goal"/>](https://gauge-indicator.klyta.it/examples/step-goal)<br/>**Step goal** |
| [<img src="https://raw.githubusercontent.com/gonuit/gauge_indicator/854f73cc961899b0820101aa8fc2e68d289b16ee/readme/examples/voltmeter.png" width="240" alt="Voltmeter"/>](https://gauge-indicator.klyta.it/examples/voltmeter)<br/>**Voltmeter** | [<img src="https://raw.githubusercontent.com/gonuit/gauge_indicator/854f73cc961899b0820101aa8fc2e68d289b16ee/readme/examples/activity-rings.png" width="240" alt="Activity rings"/>](https://gauge-indicator.klyta.it/examples/activity-rings)<br/>**Activity rings** | [<img src="https://raw.githubusercontent.com/gonuit/gauge_indicator/854f73cc961899b0820101aa8fc2e68d289b16ee/readme/examples/live-heart-rate.png" width="240" alt="Live heart rate"/>](https://gauge-indicator.klyta.it/examples/live-heart-rate)<br/>**Live heart rate** |
| [<img src="https://raw.githubusercontent.com/gonuit/gauge_indicator/854f73cc961899b0820101aa8fc2e68d289b16ee/readme/examples/rank-progression.png" width="240" alt="Rank progression"/>](https://gauge-indicator.klyta.it/examples/rank-progression)<br/>**Rank progression** | [<img src="https://raw.githubusercontent.com/gonuit/gauge_indicator/854f73cc961899b0820101aa8fc2e68d289b16ee/readme/examples/shader-progress-bar.png" width="240" alt="Progress bar shader"/>](https://gauge-indicator.klyta.it/examples/shader-progress-bar)<br/>**Progress bar shader** |  |

## Usage

Install:

```bash
flutter pub add gauge_indicator
```

Drop an `AnimatedRadialGauge` (or `RadialGauge`) into your tree, sized by its parent:

```dart
import 'package:gauge_indicator/gauge_indicator.dart';

SizedBox(
  width: 280,
  height: 200,
  child: AnimatedRadialGauge(
    duration: const Duration(milliseconds: 800),
    value: 65,
    axis: const GaugeAxis(min: 0, max: 100),
  ),
)
```

Pointers, progress bars, zones, gradients, and labels are all opt-in via the `GaugeAxis` config — see the gallery above for working setups.