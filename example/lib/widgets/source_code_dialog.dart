import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

const _rawBase =
    'https://raw.githubusercontent.com/gonuit/gauge_indicator/d2f51edd4d5abaaad812933f5a50ccc4cdea1285/';
const _blobBase =
    'https://github.com/gonuit/gauge_indicator/blob/d2f51edd4d5abaaad812933f5a50ccc4cdea1285/';

final Map<String, String> _sourceCache = {};

class SourceCodeDialog extends StatefulWidget {
  final String title;
  final String sourcePath;

  const SourceCodeDialog({
    super.key,
    required this.title,
    required this.sourcePath,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String sourcePath,
  }) {
    final isMobile = MediaQuery.sizeOf(context).width < 700;
    if (isMobile) {
      return showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        useSafeArea: true,
        builder: (_) => FractionallySizedBox(
          heightFactor: 0.9,
          child: SourceCodeDialog(
            title: title,
            sourcePath: sourcePath,
          ),
        ),
      );
    }
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(24),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960, maxHeight: 720),
          child: SourceCodeDialog(
            title: title,
            sourcePath: sourcePath,
          ),
        ),
      ),
    );
  }

  @override
  State<SourceCodeDialog> createState() => _SourceCodeDialogState();
}

class _SourceCodeDialogState extends State<SourceCodeDialog> {
  late Future<String> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<String> _load() async {
    final cached = _sourceCache[widget.sourcePath];
    if (cached != null) return cached;
    final res = await http.get(Uri.parse('$_rawBase${widget.sourcePath}'));
    if (res.statusCode != 200) {
      throw Exception('GitHub returned ${res.statusCode}');
    }
    final body = res.body;
    _sourceCache[widget.sourcePath] = body;
    return body;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(
          title: widget.title,
          sourcePath: widget.sourcePath,
          onCopy: _copyToClipboard,
        ),
        Expanded(
          child: FutureBuilder<String>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return _ErrorView(
                  onRetry: () => setState(() => _future = _load()),
                  sourcePath: widget.sourcePath,
                );
              }
              return _CodeView(code: snapshot.data ?? '');
            },
          ),
        ),
      ],
    );
  }

  Future<void> _copyToClipboard() async {
    final code = _sourceCache[widget.sourcePath];
    if (code == null) return;
    await Clipboard.setData(ClipboardData(text: code));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Source copied'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String sourcePath;
  final VoidCallback onCopy;

  const _Header({
    required this.title,
    required this.sourcePath,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 700;
    final filename = sourcePath.split('/').last;
    final githubUrl = Uri.parse('$_blobBase$sourcePath');

    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        isCompact ? 4 : 12,
        8,
        isCompact ? 8 : 12,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFD),
        border: Border(
          bottom: BorderSide(color: Color(0xFFE3E8F2)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isCompact ? 14 : 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF002E5F),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isCompact ? filename : sourcePath,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: Color(0xFF6B7691),
                  ),
                ),
              ],
            ),
          ),
          if (isCompact)
            IconButton(
              tooltip: 'Open on GitHub',
              icon: const Icon(Icons.open_in_new, size: 20),
              color: const Color(0xFF002E5F),
              onPressed: () =>
                  launchUrl(githubUrl, mode: LaunchMode.externalApplication),
            )
          else
            OutlinedButton.icon(
              icon: const Icon(Icons.open_in_new, size: 16),
              label: const Text('Open on GitHub'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF002E5F),
                side: const BorderSide(color: Color(0xFFCBD3E1)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () =>
                  launchUrl(githubUrl, mode: LaunchMode.externalApplication),
            ),
          if (!isCompact) const SizedBox(width: 4),
          IconButton(
            tooltip: 'Copy',
            icon: const Icon(Icons.copy_outlined, size: 20),
            color: const Color(0xFF002E5F),
            onPressed: onCopy,
          ),
          if (!isCompact)
            IconButton(
              tooltip: 'Close',
              icon: const Icon(Icons.close, size: 20),
              color: const Color(0xFF002E5F),
              onPressed: () => Navigator.of(context).pop(),
            ),
        ],
      ),
    );
  }
}

class _CodeView extends StatefulWidget {
  final String code;

  const _CodeView({required this.code});

  @override
  State<_CodeView> createState() => _CodeViewState();
}

class _CodeViewState extends State<_CodeView> {
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
                    constraints:
                        BoxConstraints(minWidth: constraints.maxWidth),
                    child: SelectionArea(
                      child: HighlightView(
                        widget.code,
                        language: 'dart',
                        theme: githubTheme,
                        padding: const EdgeInsets.all(20),
                        textStyle: GoogleFonts.jetBrainsMono(
                          textStyle: const TextStyle(
                            fontSize: 13,
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

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  final String sourcePath;

  const _ErrorView({required this.onRetry, required this.sourcePath});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 48,
              color: Color(0xFF6B7691),
            ),
            const SizedBox(height: 12),
            const Text(
              "Couldn't load source",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF002E5F),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Retry'),
                  onPressed: onRetry,
                ),
                const SizedBox(width: 12),
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: const Text('Open on GitHub'),
                  onPressed: () => launchUrl(
                    Uri.parse('$_blobBase$sourcePath'),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
