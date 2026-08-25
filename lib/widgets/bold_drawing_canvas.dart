import 'package:flutter/material.dart';

/// لوحة كتابة بقلم عريض وواضح جدًا أثناء الكتابة.
/// الكتابة تستجيب مباشرة لحركة إصبع الطفل وتعيد الرسم في كل حركة.
/// تُستخدم في جميع شاشات الكتابة في التطبيق.
class BoldDrawingCanvas extends StatefulWidget {
  final Color initialColor;

  const BoldDrawingCanvas({
    super.key,
    this.initialColor = const Color(0xFF3949AB),
  });

  @override
  State<BoldDrawingCanvas> createState() => BoldDrawingCanvasState();
}

class BoldDrawingCanvasState extends State<BoldDrawingCanvas> {
  final points = <Offset?>[];
  late Color penColor = widget.initialColor;

  static const penColors = [
    Color(0xFF3949AB),
    Color(0xFFE53935),
    Color(0xFF00897B),
    Color(0xFFFB8C00),
    Color(0xFF8E24AA),
    Color(0xFF212121),
  ];

  void clear() {
    if (!mounted) return;
    setState(points.clear);
  }

  void _startStroke(Offset position) {
    setState(() => points.add(position));
  }

  void _continueStroke(Offset position) {
    setState(() => points.add(position));
  }

  void _endStroke() {
    setState(() => points.add(null));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: penColors.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final color = penColors[i];
              final selected = color.toARGB32() == penColor.toARGB32();
              return GestureDetector(
                onTap: () => setState(() => penColor = color),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? Colors.black : Colors.transparent,
                      width: 3,
                    ),
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
                color: scheme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: scheme.outlineVariant,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Listener(
                  behavior: HitTestBehavior.opaque,
                  onPointerDown: (event) => _startStroke(event.localPosition),
                  onPointerMove: (event) => _continueStroke(event.localPosition),
                  onPointerUp: (_) => _endStroke(),
                  onPointerCancel: (_) => _endStroke(),
                  child: CustomPaint(
                    painter: BoldDrawingPainter(points, penColor),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// قلم عريض جدًا وواضح المعالم مع أطراف مستديرة.
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
      final first = points[i];
      final second = points[i + 1];
      if (first != null && second != null) {
        canvas.drawLine(first, second, pen);
      }
    }

    // إظهار نقطة البداية فور لمس السبورة حتى لا تختفي الكتابة
    // عند أول لمسة قبل وصول حركة الإصبع التالية.
    final last = points.isEmpty ? null : points.last;
    if (last != null) {
      canvas.drawCircle(last, pen.strokeWidth / 2, Paint()..color = color);
    }
  }

  // النقاط تُعدّل داخل نفس القائمة، لذلك مقارنة مراجع القائمة القديمة
  // والجديدة لا تكشف التغيير. إعادة true تضمن إعادة الرسم مع كل حركة إصبع.
  @override
  bool shouldRepaint(covariant BoldDrawingPainter oldDelegate) => true;
}
