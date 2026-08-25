import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../widgets/button_3d.dart';

enum _ShapeKind {
  square,
  triangle,
  circle,
  rectangle,
  trapezoid,
  oblique,
  pentagon,
  hexagon,
  rhombus,
}

class _ShapeEntry {
  final String name;
  final _ShapeKind kind;
  final Color color;
  const _ShapeEntry(this.name, this.kind, this.color);
}

class Kg2ShapesScreen extends StatefulWidget {
  const Kg2ShapesScreen({super.key});

  static const shapes = <_ShapeEntry>[
    _ShapeEntry('مربع', _ShapeKind.square, Color(0xFFE53935)),
    _ShapeEntry('مثلث', _ShapeKind.triangle, Color(0xFF1E88E5)),
    _ShapeEntry('دائرة', _ShapeKind.circle, Color(0xFF43A047)),
    _ShapeEntry('مستطيل', _ShapeKind.rectangle, Color(0xFFFB8C00)),
    _ShapeEntry('منحرف', _ShapeKind.oblique, Color(0xFF8E24AA)),
    _ShapeEntry('شبه منحرف', _ShapeKind.trapezoid, Color(0xFF00897B)),
    _ShapeEntry('خماسي', _ShapeKind.pentagon, Color(0xFFFF1E7E)),
    _ShapeEntry('سداسي', _ShapeKind.hexagon, Color(0xFF2979FF)),
    _ShapeEntry('معيّن', _ShapeKind.rhombus, Color(0xFFFFC107)),
  ];

  @override
  State<Kg2ShapesScreen> createState() => _Kg2ShapesScreenState();
}

class _Kg2ShapesScreenState extends State<Kg2ShapesScreen> {
  int? selectedIndex;

  void _select(int index) {
    setState(() => selectedIndex = index);
    VoiceService.arabic(Kg2ShapesScreen.shapes[index].name);
  }

  @override
  Widget build(BuildContext context) {
    const shapes = Kg2ShapesScreen.shapes;
    final selected = selectedIndex == null ? null : shapes[selectedIndex!];
    final remaining = <int>[
      for (var i = 0; i < shapes.length; i++)
        if (i != selectedIndex) i,
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الأشكال 🔷')),
        body: selected == null
            ? _buildInitialGrid(shapes)
            : Column(
                children: [
                  _buildLargePreview(selected),
                  Expanded(child: _buildChoicesGrid(remaining)),
                ],
              ),
      ),
    );
  }

  Widget _buildInitialGrid(List<_ShapeEntry> shapes) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: .95,
      ),
      itemCount: shapes.length,
      itemBuilder: (_, i) => _buildShapeCard(shapes[i], i, large: false),
    );
  }

  Widget _buildChoicesGrid(List<int> indices) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: .9,
      ),
      itemCount: indices.length,
      itemBuilder: (_, i) {
        final index = indices[i];
        return _buildShapeCard(
          Kg2ShapesScreen.shapes[index],
          index,
          large: false,
        );
      },
    );
  }

  Widget _buildLargePreview(_ShapeEntry shape) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: shape.color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            offset: Offset(0, 4),
            color: Color(0x33000000),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: 170,
            height: 140,
            child: CustomPaint(painter: _ShapePainter(shape.kind)),
          ),
          const SizedBox(height: 8),
          Text(
            shape.name,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShapeCard(
    _ShapeEntry shape,
    int index, {
    required bool large,
  }) {
    return Button3D(
      onTap: () => _select(index),
      color: shape.color,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: large ? 150 : 70,
            height: large ? 120 : 70,
            child: CustomPaint(painter: _ShapePainter(shape.kind)),
          ),
          const SizedBox(height: 6),
          Text(
            shape.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: large ? 24 : 15,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShapePainter extends CustomPainter {
  final _ShapeKind kind;
  _ShapePainter(this.kind);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
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
        path.moveTo(w * .28, 6);
        path.lineTo(w * .72, 6);
        path.lineTo(w - 4, h - 6);
        path.lineTo(4, h - 6);
        path.close();
        canvas.drawPath(path, paint);
      case _ShapeKind.oblique:
        path.moveTo(w * .32, 4);
        path.lineTo(w - 4, 4);
        path.lineTo(w * .68, h - 4);
        path.lineTo(4, h - 4);
        path.close();
        canvas.drawPath(path, paint);
      case _ShapeKind.rhombus:
        path.moveTo(w / 2, 2);
        path.lineTo(w - 4, h / 2);
        path.lineTo(w / 2, h - 2);
        path.lineTo(4, h / 2);
        path.close();
        canvas.drawPath(path, paint);
      case _ShapeKind.pentagon:
        _regularPolygon(path, w, h, 5);
        canvas.drawPath(path, paint);
      case _ShapeKind.hexagon:
        _regularPolygon(path, w, h, 6);
        canvas.drawPath(path, paint);
    }
  }

  static void _regularPolygon(Path path, double w, double h, int sides) {
    final cx = w / 2, cy = h / 2, r = math.min(w, h) / 2 - 3;
    for (var i = 0; i < sides; i++) {
      final angle = -math.pi / 2 + i * 2 * math.pi / sides;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
  }

  @override
  bool shouldRepaint(covariant _ShapePainter oldDelegate) =>
      oldDelegate.kind != kind;
}
