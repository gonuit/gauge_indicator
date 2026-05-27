import 'dart:async';

import 'package:example/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  unawaited(GoogleFonts.pendingFonts([GoogleFonts.jetBrainsMono()]));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Radial gauge',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        tabBarTheme: const TabBarThemeData(labelColor: Colors.black),
      ),
      routerConfig: router,
      builder: (context, child) => ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: child,
      ),
    );
  }
}
