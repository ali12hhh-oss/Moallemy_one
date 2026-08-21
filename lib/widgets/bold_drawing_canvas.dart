import 'package:flutter/material.dart';

/// لوحة كتابة بقلم عريض وواضح جدًا أثناء الكتابة، مع شريط اختيار لون القلم.
/// تُستخدم في كل شاشات الكتابة على الشاشة في التطبيق.
class BoldDrawingCanvas extends StatefulWidget {
  final Color initialColor;
  const BoldDrawingCanvas({super.key, this.initialColor = const Color(0xFF3949AB)});

  @override
  State<BoldDrawingCanvas> createState() => BoldDrawingCanvasState();
}

class BoldDrawingCanvasState extends State<BoldDrawingCanvas> {
  final points = <Offset?>[];
  late Color penColor = widget.initialColor;

  static const penColors = [
    Color(0xFF3949AB), Color(0xFFE53935), Color(0xFF00897B),
    Color(0xFFFB8C00), Color(0xFF8E24AA), Color(0xFF212121),
  ];

  void clear() => setState(points.clear);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: penColors.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (_, i) {
            final c = penColors[i];
            final selected = c.toARGB32() == penColor.toARGB32();
            return GestureDetector(
              onTap: () => setState(() => penColor = c),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: c,
                  shape: BoxShape.circle,
                  border: Border.all(color: selected ? Colors.black : Colors.transparent, width: 3),
                ),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 8),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: GestureDetector(
                onPanStart: (d) => setState(() => points.add(d.localPosition)),
                onPanUpdate: (d) => setState(() => points.add(d.localPosition)),
                onPanEnd: (_) => setState(() => points.add(null)),
                child: CustomPaint(painter: BoldDrawingPainter(points, penColor), child: const SizedBox.expand()),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}

/// قلم عريض جدًا وواضح المعالم (١٤ بكسل) مع أطراف مستديرة.
class BoldDrawingPainter extends CustomPainter {
  final List<Offset?> points;
  final Color color;
  BoldDrawingPainter(this.points, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final pen = Paint()
      ..color = color
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < points.length - 1; i++) {
      final a = points[i];
      final b = points[i + 1];
      if (a != null && b != null) canvas.drawLine(a, b, pen);
    }
  }

  @override
  bool shouldRepaint(covariant BoldDrawingPainter oldDelegate) => oldDelegate.points != points || oldDelegate.color != color;
}
