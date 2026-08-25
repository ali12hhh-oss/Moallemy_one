import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../data/content.dart';
import '../../widgets/button_3d.dart';

/// شاشة الكتابة للروضة الأولى.
/// ثابتة بملء المساحة المتاحة، والكتابة تظهر مباشرة تحت إصبع الطفل.
class Kg1WritingScreen extends StatefulWidget {
  const Kg1WritingScreen({super.key});

  @override
  State<Kg1WritingScreen> createState() => _Kg1WritingScreenState();
}

class _Kg1WritingScreenState extends State<Kg1WritingScreen> {
  bool lettersMode = true;
  int index = 0;
  final points = <Offset?>[];
  Color penColor = const Color(0xFF3949AB);

  static const penColors = [
    Color(0xFF3949AB),
    Color(0xFFE53935),
    Color(0xFF00897B),
    Color(0xFFFB8C00),
    Color(0xFF8E24AA),
    Color(0xFF212121),
  ];

  static const numbers = ['١','٢','٣','٤','٥','٦','٧','٨','٩','١٠'];

  void _clearBoard() => setState(points.clear);

  void _switch(bool letters) {
    setState(() {
      lettersMode = letters;
      index = 0;
      points.clear();
    });
  }

  void _move(int delta) {
    final length = lettersMode ? arabicLetters.length : numbers.length;
    setState(() {
      index = (index + delta + length) % length;
      points.clear();
    });
  }

  void _speak() {
    if (lettersMode) {
      final letter = arabicLetters[index];
      VoiceService.arabicLetterSound(letter.letter, fallbackText: letter.sound);
    } else {
      VoiceService.arabic(_numberWord(index + 1));
    }
  }

  static String _numberWord(int n) => const {
    1: 'واحد', 2: 'اثنان', 3: 'ثلاثة', 4: 'أربعة', 5: 'خمسة',
    6: 'ستة', 7: 'سبعة', 8: 'ثمانية', 9: 'تسعة', 10: 'عشرة',
  }[n] ?? '$n';

  void _startStroke(Offset point) => setState(() => points.add(point));
  void _continueStroke(Offset point) => setState(() => points.add(point));
  void _endStroke() => setState(() => points.add(null));

  ButtonStyle _controlStyle({required Color background, double fontSize = 15}) =>
      FilledButton.styleFrom(
        minimumSize: const Size(0, 54),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
        backgroundColor: background,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w900),
      );

  @override
  Widget build(BuildContext context) {
    final target = lettersMode ? arabicLetters[index].letter : numbers[index];
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الكتابة على الشاشة'),
          actions: [
            IconButton(
              onPressed: _speak,
              tooltip: 'استمع',
              icon: const Icon(Icons.volume_up_rounded),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 3),
                child: Row(
                  children: [
                    Expanded(
                      child: Button3D(
                        onTap: () => _switch(true),
                        color: lettersMode ? const Color(0xFF7C4DFF) : const Color(0xFFB39DDB),
                        depth: lettersMode ? 2 : 7,
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        child: const Center(child: Text('الحروف 🔤', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white))),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Button3D(
                        onTap: () => _switch(false),
                        color: !lettersMode ? const Color(0xFF2979FF) : const Color(0xFF90CAF9),
                        depth: !lettersMode ? 2 : 7,
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        child: const Center(child: Text('الأرقام 🔢', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white))),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Text(lettersMode ? 'اكتب الحرف' : 'اكتب الرقم', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              FittedBox(fit: BoxFit.scaleDown, child: Text(target, style: const TextStyle(fontSize: 68, fontWeight: FontWeight.w900))),
              const SizedBox(height: 3),
              SizedBox(
                height: 34,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: penColors.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 9),
                  itemBuilder: (_, i) {
                    final color = penColors[i];
                    final selected = color.toARGB32() == penColor.toARGB32();
                    return GestureDetector(
                      onTap: () => setState(() => penColor = color),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(color: selected ? Colors.black : Colors.transparent, width: 3),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 4),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: theme.colorScheme.outlineVariant, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Listener(
                        behavior: HitTestBehavior.opaque,
                        onPointerDown: (event) => _startStroke(event.localPosition),
                        onPointerMove: (event) => _continueStroke(event.localPosition),
                        onPointerUp: (_) => _endStroke(),
                        onPointerCancel: (_) => _endStroke(),
                        child: CustomPaint(
                          painter: _BoldDrawingPainter(points, penColor),
                          child: const SizedBox.expand(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // الأزرار الثلاثة ثابتة أسفل السبورة وبنفس الحجم والشكل.
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        style: _controlStyle(background: const Color(0xFF00897B)),
                        onPressed: () => _move(-1),
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: const Text('السابق'),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: FilledButton.icon(
                        style: _controlStyle(background: const Color(0xFFE53935), fontSize: 14),
                        onPressed: _clearBoard,
                        icon: const Icon(Icons.delete_sweep_rounded, size: 22),
                        label: const Text('مسح السبورة'),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: FilledButton.icon(
                        style: _controlStyle(background: const Color(0xFF00897B)),
                        onPressed: () => _move(1),
                        icon: const Icon(Icons.arrow_back_rounded),
                        label: const Text('التالي'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BoldDrawingPainter extends CustomPainter {
  final List<Offset?> points;
  final Color color;

  _BoldDrawingPainter(this.points, this.color);

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
      if (first != null && second != null) canvas.drawLine(first, second, pen);
    }

    final last = points.isEmpty ? null : points.last;
    if (last != null) canvas.drawCircle(last, pen.strokeWidth / 2, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _BoldDrawingPainter oldDelegate) => true;
}
