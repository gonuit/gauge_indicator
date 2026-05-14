import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class ZoneRangeEditor extends StatefulWidget {
  final List<GaugeZone> zones;
  final void Function(int boundaryIndex, double position) onBoundaryChanged;
  final double min;
  final double max;

  const ZoneRangeEditor({
    super.key,
    required this.zones,
    required this.onBoundaryChanged,
    this.min = 0,
    this.max = 100,
  });

  @override
  State<ZoneRangeEditor> createState() => _ZoneRangeEditorState();
}

class _ZoneRangeEditorState extends State<ZoneRangeEditor> {
  static const double _barHeight = 22;
  static const double _thumbWidth = 14;
  static const double _thumbHeight = 30;

  int? _draggingIndex;
  double? _draggingPosition;

  double _boundary(int i) {
    if (_draggingIndex == i && _draggingPosition != null) {
      return _draggingPosition!;
    }
    return widget.zones[i].to;
  }

  @override
  Widget build(BuildContext context) {
    final zones = widget.zones;
    if (zones.length < 2) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final span = widget.max - widget.min;
          double xFor(double v) => (v - widget.min) / span * width;

          return SizedBox(
            height: _thumbHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 0,
                  top: (_thumbHeight - _barHeight) / 2,
                  height: _barHeight,
                  width: width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Stack(
                      children: [
                        for (var i = 0; i < zones.length; i++)
                          Builder(builder: (_) {
                            final from = i == 0
                                ? zones[0].from
                                : _boundary(i - 1);
                            final to = i == zones.length - 1
                                ? zones[i].to
                                : _boundary(i);
                            return Positioned(
                              left: xFor(from),
                              width: xFor(to) - xFor(from),
                              top: 0,
                              bottom: 0,
                              child: Container(color: zones[i].color),
                            );
                          }),
                      ],
                    ),
                  ),
                ),
                for (var i = 0; i < zones.length - 1; i++)
                  Positioned(
                    left: xFor(_boundary(i)) - _thumbWidth / 2,
                    top: 0,
                    child: _Thumb(
                      width: _thumbWidth,
                      height: _thumbHeight,
                      onStart: () {
                        setState(() {
                          _draggingIndex = i;
                          _draggingPosition = zones[i].to;
                        });
                      },
                      onDrag: (dx) {
                        if (_draggingPosition == null) return;
                        final delta = dx / width * span;
                        final lo = zones[i].from + 1;
                        final hi = zones[i + 1].to - 1;
                        final next =
                            (_draggingPosition! + delta).clamp(lo, hi);
                        setState(() {
                          _draggingPosition = next;
                        });
                      },
                      onEnd: () {
                        final committed = _draggingPosition;
                        setState(() {
                          _draggingIndex = null;
                          _draggingPosition = null;
                        });
                        if (committed != null) {
                          widget.onBoundaryChanged(i, committed);
                        }
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback onStart;
  final void Function(double dx) onDrag;
  final VoidCallback onEnd;

  const _Thumb({
    required this.width,
    required this.height,
    required this.onStart,
    required this.onDrag,
    required this.onEnd,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        dragStartBehavior: DragStartBehavior.down,
        onHorizontalDragStart: (_) => onStart(),
        onHorizontalDragUpdate: (d) => onDrag(d.delta.dx),
        onHorizontalDragEnd: (_) => onEnd(),
        onHorizontalDragCancel: onEnd,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFF002E5F), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: const Center(
            child: SizedBox(
              width: 2,
              height: 12,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFF002E5F)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
