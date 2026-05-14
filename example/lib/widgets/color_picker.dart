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
        ElevatedButton(
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

  const ColorField({
    super.key,
    required this.title,
    required this.color,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () => pickColor(
        context,
        color,
      ).then((color) {
        if (color != null) {
          onColorChanged(color);
        }
      }),
      trailing: Container(
        width: 40,
        height: 40,
        color: color,
      ),
    );
  }
}
