import 'package:flutter/material.dart';

/// Produces a string label for a numeric gauge value.
///
/// Use the factory constructors to pick a strategy, or subclass for custom
/// formatting:
///  * [GaugeLabelProvider.value] — numeric labels with configurable digits
///  * [GaugeLabelProvider.map] — caller-supplied mapping function
///  * [GaugeLabelProvider.categories] — labels for matching value ranges
abstract class GaugeLabelProvider {
  /// Base constructor for subclasses.
  const GaugeLabelProvider();

  /// Returns a numeric label for the provided value.
  const factory GaugeLabelProvider.value({int fractionDigits}) =
      ValueLabelProvider;

  /// Maps a numeric value to the label.
  const factory GaugeLabelProvider.map({required ToLabel toLabel}) =
      MapLabelProvider;

  /// Returns a label from the matching [LabelCategory]
  /// or a numeric label if no matching category is available.
  const factory GaugeLabelProvider.categories(
    List<LabelCategory> categories, {
    int fractionDigits,
  }) = CategoryLabelProvider;

  /// Returns a string label for the specified [value].
  String getLabel(double value);
}

/// A [GaugeLabelProvider] that formats the value as a fixed-precision
/// number.
class ValueLabelProvider extends GaugeLabelProvider {
  /// Number of digits after the decimal point.
  final int fractionDigits;

  /// Creates a numeric label provider.
  const ValueLabelProvider({this.fractionDigits = 0});

  @override
  String getLabel(double value) {
    return value.toStringAsFixed(fractionDigits);
  }
}

/// Function that maps a numeric gauge value to a display string.
typedef ToLabel = String Function(double);

/// A [GaugeLabelProvider] that delegates label production to a function.
class MapLabelProvider extends GaugeLabelProvider {
  /// Function returning the label for a given value.
  final ToLabel toLabel;

  /// Creates a label provider backed by [toLabel].
  const MapLabelProvider({required this.toLabel});

  @override
  String getLabel(double value) {
    return toLabel(value);
  }
}

/// A named label for a `[from, to]` value range, used by
/// [CategoryLabelProvider].
class LabelCategory {
  /// Lower bound of the range (inclusive).
  final double from;

  /// Upper bound of the range (inclusive).
  final double to;

  /// Label returned when a value falls inside the range.
  final String label;

  /// Creates a label category.
  const LabelCategory(this.from, this.to, this.label);
}

/// A [GaugeLabelProvider] that returns the label of the matching
/// [LabelCategory], falling back to a numeric label when no category
/// matches.
///
/// For purely numeric labels, see [ValueLabelProvider].
class CategoryLabelProvider extends GaugeLabelProvider {
  /// Categories searched in order; the first match wins.
  final List<LabelCategory> categories;

  /// Number of digits after the decimal point used for the fallback numeric
  /// label when no category matches.
  final int fractionDigits;

  /// Creates a category-based label provider.
  const CategoryLabelProvider(this.categories, {this.fractionDigits = 0});

  @override
  String getLabel(double value) {
    for (final category in categories) {
      if (category.from <= value && category.to >= value) {
        return category.label;
      }
    }
    return value.toStringAsFixed(fractionDigits);
  }
}

/// A centered [Text] widget that renders a gauge value through a
/// [GaugeLabelProvider].
///
/// Use as the `child` or `builder` content for a [RadialGauge] /
/// [AnimatedRadialGauge].
class RadialGaugeLabel extends StatelessWidget {
  /// The value to display.
  final double value;

  /// Optional text style applied to the label.
  final TextStyle? style;

  /// Provider that converts [value] into a display string.
  final GaugeLabelProvider labelProvider;

  /// Creates a radial gauge label.
  const RadialGaugeLabel({
    super.key,
    required this.value,
    this.style,
    this.labelProvider = const GaugeLabelProvider.value(),
  });

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
