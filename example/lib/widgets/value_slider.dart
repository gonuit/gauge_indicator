import 'package:flutter/material.dart';

class ValueSlider extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final ValueChanged<double>? onChangeEnd;
  final double min;
  final double max;

  const ValueSlider({
    Key? key,
    required this.label,
    required this.onChanged,
    this.onChangeEnd,
    required this.value,
    required this.min,
    required this.max,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            "$label: ${value.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        Slider(
          min: min,
          max: max,
          value: value,
          onChanged: onChanged,
          onChangeEnd: onChangeEnd,
        ),
      ],
    );
  }
}
