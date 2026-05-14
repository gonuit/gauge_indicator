# gauge_indicator example

Interactive demo for the [`gauge_indicator`](https://pub.dev/packages/gauge_indicator) package. The configuration panel on the left lets you tweak every gauge property live — layout, style, segments (drag the dividers to resize, or add/remove up to 10), progress bar, pointer, and animation curve & duration — and the gauge on the right reflects the changes in real time.

Try it in your browser: <https://gauge-indicator.klyta.it/>

Run it:

```sh
flutter run
```

Or build for web:

```sh
flutter build web --release
```

The entry point is [`lib/main.dart`](lib/main.dart); the page that hosts the gauge and the configuration panel lives in [`lib/pages/radial_gauge_example_page.dart`](lib/pages/radial_gauge_example_page.dart).
