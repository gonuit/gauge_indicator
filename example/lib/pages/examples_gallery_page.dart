import 'package:example/examples/shader_gradient_example.dart';
import 'package:example/widgets/package_title.dart';
import 'package:flutter/material.dart';

class ExampleEntry {
  final String name;
  final WidgetBuilder builder;

  const ExampleEntry({required this.name, required this.builder});
}

final List<ExampleEntry> examples = [
  ExampleEntry(
    name: 'Gradient shader',
    builder: (_) => const ShaderGradientExample(),
  ),
];

class ExamplesGalleryPage extends StatefulWidget {
  const ExamplesGalleryPage({super.key});

  @override
  State<ExamplesGalleryPage> createState() => _ExamplesGalleryPageState();
}

class _ExamplesGalleryPageState extends State<ExamplesGalleryPage> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final viewSize = MediaQuery.sizeOf(context);
    final isMobile = viewSize.width < 700;

    final list = _ExamplesList(
      examples: examples,
      selected: _selected,
      onSelected: (i) => setState(() => _selected = i),
    );

    final demo = Center(child: examples[_selected].builder(context));

    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: PageTitle(
                  title: 'Examples',
                  isSmall: isMobile,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          Expanded(
            child: isMobile
                ? Column(
                    children: [
                      SizedBox(height: 120, child: list),
                      Expanded(child: demo),
                    ],
                  )
                : Row(
                    children: [
                      SizedBox(width: 240, child: list),
                      Expanded(child: demo),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _ExamplesList extends StatelessWidget {
  final List<ExampleEntry> examples;
  final int selected;
  final ValueChanged<int> onSelected;

  const _ExamplesList({
    required this.examples,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Color(0xFFDDDDDD))),
      ),
      child: ListView.builder(
        itemCount: examples.length,
        itemBuilder: (context, i) {
          final isSelected = i == selected;
          return ListTile(
            dense: true,
            selected: isSelected,
            title: Text(examples[i].name),
            onTap: () => onSelected(i),
          );
        },
      ),
    );
  }
}
