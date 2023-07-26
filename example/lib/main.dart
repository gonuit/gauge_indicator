import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radial gauge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.black,
        ),
      ),
      home: const Scaffold(
        body: ZonePainter(),
      ),
    );
  }
}

class ZonePainter extends StatefulWidget {
  const ZonePainter({super.key});

  @override
  State<ZonePainter> createState() => _ZonePainterState();
}

class _ZonePainterState extends State<ZonePainter> {
  List<GaugeSegment> getSegments = [
    GaugeSegment(
      from: 0,
      to: 20,
      style: GaugeSegmentStyle(
        color: Colors.grey.withOpacity(.25),
        cornerRadius: const Radius.circular(10),
        thickness: 15,
      ),
    ),
    GaugeSegment(
      from: 20,
      to: 40,
      style: GaugeSegmentStyle(
        color: Colors.cyan.withOpacity(.25),
        cornerRadius: const Radius.circular(10),
      ),
    ),
    GaugeSegment(
      from: 40,
      to: 60,
      style: GaugeSegmentStyle(
        color: Colors.yellow.withOpacity(.25),
        cornerRadius: const Radius.circular(10),
      ),
    ),
    GaugeSegment(
      from: 60,
      to: 80,
      style: GaugeSegmentStyle(
        color: Colors.orange.withOpacity(.25),
        cornerRadius: const Radius.circular(10),
      ),
    ),
    GaugeSegment(
      from: 80,
      to: 100,
      style: GaugeSegmentStyle(
        color: Colors.red.withOpacity(.25),
        cornerRadius: const Radius.circular(10),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<int> zoneTarget = [1];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        child: AnimatedRadialGauge(
          duration: const Duration(milliseconds: 300),
          value: 10,
          axis: GaugeAxis(
            min: 0,
            max: 100,
            degrees: 180,
            progressBar: const GaugeProgressBar.rounded(
                placement: GaugeProgressPlacement.over,
                color: Colors.transparent),
            pointer: const GaugePointer.triangle(
              borderRadius: 20,
              height: 20,
              width: 8,
              color: Colors.grey,
              shadow: Shadow(
                color: Colors.black,
                blurRadius: 4,
              ),
              position: GaugePointerPosition.surface(offset: Offset(0, 0)),
              border: GaugePointerBorder(
                color: Colors.transparent,
                width: 4,
              ),
            ),

            // if zone target value is equal getSegment index, then set color with opacity 1
            segments: getSegments
                .map((e) => GaugeSegment(
                      from: e.from,
                      to: e.to,
                      style: e.style.copyWith(
                        color: zoneTarget.contains(getSegments.indexOf(e))
                            ? e.style.color!.withOpacity(1)
                            : e.style.color,
                      ),
                    ))
                .toList(),
            style: const GaugeAxisStyle(
              // if zone target value is equal getSegment index, then set thickness with 0 else 6
              thickness: 5,
              segmentSpacing: 6,
              blendColors: false,
              cornerRadius: Radius.circular(20),
              background: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
