import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// Provides string labels for the `RadialGauge`.
abstract class GaugeLabelProvider {
  const GaugeLabelProvider();

  /// Returns a numeric label for the provided value.
  const factory GaugeLabelProvider.value({
    int fractionDigits,
  }) = ValueLabelProvider;

  /// Maps a numeric value to the label.
  const factory GaugeLabelProvider.map({
    required ToLabel toLabel,
  }) = MapLabelProvider;

  /// Returns a label from the matching [LabelCategory]
  /// or a numeric label if no matching category is available.
  const factory GaugeLabelProvider.categories(
    List<LabelCategory> categories, {
    int fractionDigits,
  }) = CategoryLabelProvider;

  /// Returns a string label for the specified [value].
  String getLabel(double value);
}

/// Returns a numeric label for the provided value.
class ValueLabelProvider extends GaugeLabelProvider {
  final int fractionDigits;

  const ValueLabelProvider({
    this.fractionDigits = 0,
  });

  @override
  String getLabel(double value) {
    return value.toStringAsFixed(fractionDigits);
  }
}

typedef ToLabel = String Function(double);

/// Maps a numeric value to the label.
class MapLabelProvider extends GaugeLabelProvider {
  final ToLabel toLabel;

  const MapLabelProvider({
    required this.toLabel,
  });

  @override
  String getLabel(double value) {
    return toLabel(value);
  }
}

/// Use with [CategoryLabelProvider] to define string labels
/// for specific value ranges.
class LabelCategory {
  final double from;
  final double to;
  final String label;

  const LabelCategory(this.from, this.to, this.label);
}

/// Returns a label from the matching [LabelCategory]
/// or a numeric label if no matching category is available.
///
/// If you only want to use a number label, take a look at the
/// [ValueLabelProvider] class.
class CategoryLabelProvider extends GaugeLabelProvider {
  final List<LabelCategory> categories;
  final int fractionDigits;

  const CategoryLabelProvider(
    this.categories, {
    this.fractionDigits = 0,
  });

  @override
  String getLabel(double value) {
    final category = categories.firstWhereOrNull(
      (c) => c.from <= value && c.to >= value,
    );

    return category?.label ?? value.toStringAsFixed(fractionDigits);
  }
}

/// A simple widget that uses the [Text] widget and
/// the [GaugeLabelProvider] class to draw a value label
/// for the [RadialGauge] widget.
///
/// Uses [GaugeLabelProvider] to transform the
/// obtained value into a label.
class RadialGaugeLabel extends StatelessWidget {
  final double value;
  final TextStyle? style;
  final GaugeLabelProvider labelProvider;

  const RadialGaugeLabel({
    Key? key,
    required this.value,
    this.style,
    this.labelProvider = const GaugeLabelProvider.value(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        labelProvider.getLabel(value),
        textAlign: TextAlign.center,
        style: style,
        maxLines: 1,
      ),
    );
  }
}
