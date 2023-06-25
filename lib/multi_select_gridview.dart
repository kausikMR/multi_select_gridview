import 'package:flutter/material.dart';

class MultiSelectGridView extends StatefulWidget {
  final int count;
  final Widget Function(GlobalKey key, int index, bool selected) itemBuilder;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final int? crossAxisCount;

  const MultiSelectGridView({
    super.key,
    required this.count,
    required this.itemBuilder,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.crossAxisCount,
  });

  @override
  State<MultiSelectGridView> createState() => _MultiSelectGridViewState();
}

class _MultiSelectGridViewState extends State<MultiSelectGridView> {
  Offset? start;
  Offset? end;
  late int count;
  late List<GlobalKey> keys;
  late List<bool> selected;

  @override
  void initState() {
    super.initState();
    count = widget.count;
    keys = [for (int i = 0; i < count; i++) GlobalKey()];
    selected = [for (int i = 0; i < count; i++) false];
  }

  bool checkWidgetInsideRange(
      Offset startOffset, Offset endOffset, GlobalKey widgetKey) {
    final RenderBox renderBox =
        widgetKey.currentContext?.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    final widgetRect =
        Rect.fromPoints(position, position + Offset(size.width, size.height));
    final rangeRect = Rect.fromPoints(startOffset, endOffset);

    return rangeRect.overlaps(widgetRect);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selected = [for (int i = 0; i < 20; i++) false];
              });
            },
            onPanStart: (details) {
              setState(() {
                start = details.localPosition;
              });
            },
            onPanUpdate: (details) {
              setState(() {
                end = details.localPosition;
                for (int i = 0; i < 20; i++) {
                  final isSelected = checkWidgetInsideRange(
                    start!,
                    end!,
                    keys[i],
                  );
                  if (isSelected) selected[i] = true;
                }
              });
            },
            onPanEnd: (details) {
              setState(() {
                start = null;
                end = null;
              });
            },
            child: GridView.count(
              crossAxisSpacing: widget.crossAxisSpacing ?? 0.0,
              mainAxisSpacing: widget.crossAxisSpacing ?? 0.0,
              crossAxisCount: MediaQuery.of(context).size.width ~/ 100,
              children: [
                for (int i = 0; i < count; i++)
                  widget.itemBuilder(keys[i], i, selected[i]),
              ],
            ),
          ),
        ),
        if (start != null && end != null)
          CustomPaint(
            painter: RectanglePainter(
              start: start!,
              end: end!,
            ),
          ),
      ],
    );
  }
}

class RectanglePainter extends CustomPainter {
  final Offset start;
  final Offset end;

  const RectanglePainter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    final rect = Rect.fromPoints(start, end);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
