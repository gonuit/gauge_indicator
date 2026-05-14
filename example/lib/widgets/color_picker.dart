import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

Future<Color?> pickColor(BuildContext context, Color initialColor) {
  Color color = initialColor;
  return showDialog<Color>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Pick a color'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: color,
          onColorChanged: (c) => color = c,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(color);
          },
          child: const Text('Select'),
        ),
      ],
    ),
  );
}

class ColorField extends StatelessWidget {
  final String title;
  final Color color;
  final ValueChanged<Color> onColorChanged;
  final VoidCallback? onRemove;

  const ColorField({
    super.key,
    required this.title,
    required this.color,
    required this.onColorChanged,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final swatch = Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black26, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );

    return ListTile(
      dense: true,
      title: Text(title, style: const TextStyle(fontSize: 13)),
      onTap: () => pickColor(context, color).then((picked) {
        if (picked != null) {
          onColorChanged(picked);
        }
      }),
      trailing: onRemove == null
          ? swatch
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                swatch,
                IconButton(
                  visualDensity: VisualDensity.compact,
                  splashRadius: 18,
                  icon: const Icon(Icons.close, size: 18),
                  color: Colors.black45,
                  tooltip: 'Remove',
                  onPressed: onRemove,
                ),
              ],
            ),
    );
  }
}
