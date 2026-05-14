import 'dart:math' as math;

import 'package:example/examples/active_zone_example.dart';
import 'package:example/examples/getting_started_example.dart';
import 'package:example/examples/shader_gradient_example.dart';
import 'package:example/examples/zones_example.dart';
import 'package:example/widgets/showcase_sidebar.dart';
import 'package:example/widgets/source_code_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExampleEntry {
  final String path;
  final String name;
  final IconData icon;
  final String sourcePath;
  final WidgetBuilder builder;

  const ExampleEntry({
    required this.path,
    required this.name,
    required this.icon,
    required this.sourcePath,
    required this.builder,
  });
}

final List<ExampleEntry> examples = [
  ExampleEntry(
    path: 'getting-started',
    name: 'Getting started',
    icon: Icons.play_circle_outline,
    sourcePath: 'example/lib/examples/getting_started_example.dart',
    builder: (_) => const GettingStartedExample(),
  ),
  ExampleEntry(
    path: 'zones',
    name: 'Zones',
    icon: Icons.donut_small_outlined,
    sourcePath: 'example/lib/examples/zones_example.dart',
    builder: (_) => const ZonesExample(),
  ),
  ExampleEntry(
    path: 'active-zone',
    name: 'Active zone',
    icon: Icons.highlight_alt_outlined,
    sourcePath: 'example/lib/examples/active_zone_example.dart',
    builder: (_) => const ActiveZoneExample(),
  ),
  ExampleEntry(
    path: 'shader-progress-bar',
    name: 'Progress bar shader',
    icon: Icons.auto_awesome_outlined,
    sourcePath: 'example/lib/examples/shader_gradient_example.dart',
    builder: (_) => const ShaderGradientExample(),
  ),
];

class ExamplesGalleryShell extends StatelessWidget {
  final String? currentSlug;
  final Widget child;

  const ExamplesGalleryShell({
    super.key,
    required this.currentSlug,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final viewSize = MediaQuery.sizeOf(context);
    final isMobile = viewSize.width < 700;

    final backButton = IconButton(
      icon: const Icon(Icons.arrow_back),
      tooltip: 'Back',
      onPressed: () => context.go('/'),
    );

    final list = _ExamplesList(
      examples: examples,
      currentSlug: currentSlug,
    );

    final currentEntry = examples.firstWhere(
      (e) => e.path == currentSlug,
      orElse: () => examples.first,
    );

    final content = Stack(
      children: [
        Positioned.fill(child: child),
        Positioned(
          top: 12,
          right: 12,
          child: _ViewSourceButton(entry: currentEntry),
        ),
      ],
    );

    return Scaffold(
      body: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SidebarHeader(
                  title: 'Examples',
                  isSmall: true,
                  leading: backButton,
                ),
                Expanded(child: content),
                SizedBox(
                  height: math.min(viewSize.height * 0.4, 240),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      border: const Border(
                        top: BorderSide(color: Color(0xFFDDDDDD)),
                      ),
                    ),
                    child: list,
                  ),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShowcaseSidebar(
                  title: 'Examples',
                  leading: backButton,
                  child: list,
                ),
                Expanded(child: content),
              ],
            ),
    );
  }
}

class _ViewSourceButton extends StatelessWidget {
  final ExampleEntry entry;

  const _ViewSourceButton({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Color(0xFFE3E8F2)),
      ),
      child: InkWell(
        onTap: () => SourceCodeDialog.show(
          context,
          title: entry.name,
          sourcePath: entry.sourcePath,
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.code, size: 16, color: Color(0xFF002E5F)),
              SizedBox(width: 8),
              Text(
                'View source',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF002E5F),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExamplesList extends StatelessWidget {
  final List<ExampleEntry> examples;
  final String? currentSlug;

  const _ExamplesList({
    required this.examples,
    required this.currentSlug,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      itemCount: examples.length,
      itemBuilder: (context, i) {
        final entry = examples[i];
        return _ExampleTile(
          entry: entry,
          selected: entry.path == currentSlug,
        );
      },
    );
  }
}

class _ExampleTile extends StatelessWidget {
  final ExampleEntry entry;
  final bool selected;

  const _ExampleTile({
    required this.entry,
    required this.selected,
  });

  static const _borderColor = Color(0xFFE3E8F2);
  static const _selectedBorder = Color(0xFF002E5F);
  static const _primaryText = Color(0xFF002E5F);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Material(
        color: selected ? const Color(0xFFF1F5FC) : Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: selected ? _selectedBorder : _borderColor,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: InkWell(
          onTap: () => context.go('/examples/${entry.path}'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: selected
                        ? _selectedBorder.withValues(alpha: 0.1)
                        : const Color(0xFFF4F6FB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    entry.icon,
                    size: 18,
                    color: _primaryText,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entry.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.w500,
                      color: _primaryText,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: selected
                      ? _primaryText
                      : _primaryText.withValues(alpha: 0.35),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
