import 'package:flutter/material.dart';

class ConfigSection extends StatelessWidget {
  final String title;
  final bool initiallyExpanded;
  final List<Widget> children;

  const ConfigSection({
    super.key,
    required this.title,
    this.initiallyExpanded = false,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Material(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE3E8F2)),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF002E5F),
              ),
            ),
            initiallyExpanded: initiallyExpanded,
            tilePadding: const EdgeInsets.symmetric(horizontal: 16),
            childrenPadding: const EdgeInsets.only(bottom: 8),
            children: children,
          ),
        ),
      ),
    );
  }
}

class LabeledSegmented<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> values;
  final String Function(T) labelOf;
  final IconData Function(T)? iconOf;
  final ValueChanged<T> onChanged;

  const LabeledSegmented({
    super.key,
    required this.label,
    required this.value,
    required this.values,
    required this.labelOf,
    required this.onChanged,
    this.iconOf,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<T>(
              showSelectedIcon: false,
              style: SegmentedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                textStyle: const TextStyle(fontSize: 12),
              ),
              segments: [
                for (final v in values)
                  ButtonSegment<T>(
                    value: v,
                    icon: iconOf == null ? null : Icon(iconOf!(v), size: 16),
                    label: Text(labelOf(v)),
                  ),
              ],
              selected: {value},
              onSelectionChanged: (s) => onChanged(s.first),
            ),
          ),
        ],
      ),
    );
  }
}

class LabeledDropdown<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T> onChanged;

  const LabeledDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFCBD3E1)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                isDense: true,
                isExpanded: true,
                value: value,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
                items: [
                  for (final item in items)
                    DropdownMenuItem(value: item, child: Text(itemLabel(item))),
                ],
                onChanged: (v) {
                  if (v == null) return;
                  onChanged(v);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
