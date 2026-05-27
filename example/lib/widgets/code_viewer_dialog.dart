import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:google_fonts/google_fonts.dart';

/// Shows the generated Dart [code] in a dialog on wide screens and a
/// draggable bottom sheet on narrow ones. Includes a copy-to-clipboard action.
Future<void> showCodeViewer(BuildContext context, String code) {
  final isMobile = MediaQuery.sizeOf(context).width < 700;
  if (isMobile) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.9,
        child: _CodeViewerBody(code: code),
      ),
    );
  }
  return showDialog<void>(
    context: context,
    builder: (_) => Dialog(
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 640),
        child: _CodeViewerBody(code: code),
      ),
    ),
  );
}

class _CodeViewerBody extends StatelessWidget {
  final String code;

  const _CodeViewerBody({required this.code});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _Header(onClose: () => Navigator.of(context).pop()),
        const Divider(height: 1, color: Color(0xFFE3E8F2)),
        Expanded(child: _CodeBlock(code: code)),
        const Divider(height: 1, color: Color(0xFFE3E8F2)),
        _Footer(code: code),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onClose;

  const _Header({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 8, 12),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Generated code',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF002E5F),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Close',
            icon: const Icon(Icons.close),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

class _CodeBlock extends StatefulWidget {
  final String code;

  const _CodeBlock({required this.code});

  @override
  State<_CodeBlock> createState() => _CodeBlockState();
}

class _CodeBlockState extends State<_CodeBlock> {
  final _vController = ScrollController();
  final _hController = ScrollController();

  @override
  void dispose() {
    _vController.dispose();
    _hController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF5F7FB),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scrollbar(
            controller: _vController,
            thumbVisibility: true,
            child: Scrollbar(
              controller: _hController,
              thumbVisibility: true,
              notificationPredicate: (n) => n.depth == 1,
              child: SingleChildScrollView(
                controller: _vController,
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  controller: _hController,
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: SelectionArea(
                      child: HighlightView(
                        widget.code,
                        language: 'dart',
                        theme: githubTheme,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        textStyle: GoogleFonts.jetBrainsMono(
                          textStyle: const TextStyle(
                            fontSize: 12.5,
                            height: 1.5,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final String code;

  const _Footer({required this.code});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Paste inside a build() method.',
              style: TextStyle(fontSize: 12, color: Color(0xFF6B7A99)),
            ),
          ),
          FilledButton.icon(
            icon: const Icon(Icons.copy_outlined, size: 18),
            label: const Text('Copy'),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: code));
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Copied to clipboard'),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
