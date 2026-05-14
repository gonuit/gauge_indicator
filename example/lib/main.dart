import 'package:example/pages/radial_gauge_example_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radial gauge',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        tabBarTheme: const TabBarThemeData(
          labelColor: Colors.black,
        ),
      ),
      home: const Scaffold(
        body: RadialGaugeExamplePage(),
      ),
    );
  }
}
