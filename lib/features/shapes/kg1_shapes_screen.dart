import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../widgets/button_3d.dart';

enum _ShapeKind { square, triangle, circle, rectangle, trapezoid, oblique }

class _ShapeEntry {
  final String name;
  final _ShapeKind kind;
  final Color color;
  const _ShapeEntry(this.name, this.kind, this.color);
}

/// كل الأشكال الهندسية المطلوبة للروضة الأولى، كل شكل مرسوم بدقة (وليس
/// إيموجي) بلون مختلف، مع النطق عند الضغط.
class Kg1ShapesScreen extends StatelessWidget {
  const Kg1ShapesScreen({super.key});

  static const shapes = <_ShapeEntry>[
    _ShapeEntry('مربع', _ShapeKind.square, Color(0xFFE53935)),
    _ShapeEntry('مثلث', _ShapeKind.triangle, Color(0xFF1E88E5)),
    _ShapeEntry('دائرة', _ShapeKind.circle, Color(0xFF43A047)),
    _ShapeEntry('مستطيل', _ShapeKind.rectangle, Color(0xFFFB8C00)),
    _ShapeEntry('منحرف', _ShapeKind.oblique, Color(0xFF8E24AA)),
    _ShapeEntry('شبه منحرف', _ShapeKind.trapezoid, Color(0xFF00897B)),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الأشكال 🔷')),
        body: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: .95,
          ),
          itemCount: shapes.length,
          itemBuilder: (_, i) {
            final s = shapes[i];
            return Button3D(
              onTap: () => VoiceService.arabic(s.name),
              color: s.color,
              padding: const EdgeInsets.all(14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 78,
                    height: 78,
                    child: CustomPaint(painter: _ShapePainter(s.kind)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    s.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ShapePainter extends CustomPainter {
  final _ShapeKind kind;
  _ShapePainter(this.kind);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
    final w = size.width, h = size.height;
    final path = Path();
    switch (kind) {
      case _ShapeKind.square:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(4, 4, w - 8, h - 8),
            const Radius.circular(8),
          ),
          paint,
        );
      case _ShapeKind.rectangle:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 14, w, h - 28),
            const Radius.circular(8),
          ),
          paint,
        );
      case _ShapeKind.circle:
        canvas.drawCircle(Offset(w / 2, h / 2), w / 2 - 2, paint);
      case _ShapeKind.triangle:
        path.moveTo(w / 2, 2);
        path.lineTo(w - 4, h - 4);
        path.lineTo(4, h - 4);
        path.close();
        canvas.drawPath(path, paint);
      case _ShapeKind.trapezoid:
        // شبه منحرف: قاعدتان متوازيتان بطولين مختلفين
        path.moveTo(w * .28, 6);
        path.lineTo(w * .72, 6);
        path.lineTo(w - 4, h - 6);
        path.lineTo(4, h - 6);
        path.close();
        canvas.drawPath(path, paint);
      case _ShapeKind.oblique:
        // منحرف: متوازي أضلاع مائل
        path.moveTo(w * .32, 4);
        path.lineTo(w - 4, 4);
        path.lineTo(w * .68, h - 4);
        path.lineTo(4, h - 4);
        path.close();
        canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ShapePainter oldDelegate) =>
      oldDelegate.kind != kind;
}
