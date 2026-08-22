import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../data/content.dart';
import '../../widgets/button_3d.dart';

/// A focused writing-practice screen for الروضة الأولى: two big 3D tabs at
/// the top switch between writing all 28 Arabic letters and writing the
/// numbers ١-١٠. The pen is bold and clearly visible while drawing, and the
/// child can pick their favorite ink color.
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

  static const numbers = ['١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩', '١٠'];

  void _switch(bool letters) {
    setState(() {
      lettersMode = letters;
      index = 0;
      points.clear();
    });
  }

  void _next(int delta) {
    final len = lettersMode ? arabicLetters.length : numbers.length;
    setState(() {
      index = (index + delta + len) % len;
      points.clear();
    });
  }

  void _speak() {
    if (lettersMode) {
      final l = arabicLetters[index];
      VoiceService.arabicLetterSound(l.letter, fallbackText: l.sound);
    } else {
      VoiceService.arabic(_numberWord(index + 1));
    }
  }

  static String _numberWord(int n) =>
      const {
        1: 'واحد',
        2: 'اثنان',
        3: 'ثلاثة',
        4: 'أربعة',
        5: 'خمسة',
        6: 'ستة',
        7: 'سبعة',
        8: 'ثمانية',
        9: 'تسعة',
        10: 'عشرة',
      }[n] ??
      '$n';

  @override
  Widget build(BuildContext context) {
    final target = lettersMode ? arabicLetters[index].letter : numbers[index];
    final isTwo = !lettersMode && index == 1; // الرقم ٢

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
            IconButton(
              onPressed: () => setState(points.clear),
              tooltip: 'مسح',
              icon: const Icon(Icons.delete_outline_rounded),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Button3D(
                      onTap: () => _switch(true),
                      color: lettersMode
                          ? const Color(0xFF7C4DFF)
                          : const Color(0xFFB39DDB),
                      depth: lettersMode ? 2 : 7,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: const Center(
                        child: Text(
                          'الحروف 🔤',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Button3D(
                      onTap: () => _switch(false),
                      color: !lettersMode
                          ? const Color(0xFF2979FF)
                          : const Color(0xFF90CAF9),
                      depth: !lettersMode ? 2 : 7,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: const Center(
                        child: Text(
                          'الأرقام 🔢',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              lettersMode ? 'اكتب الحرف' : 'اكتب الرقم',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              target,
              style: const TextStyle(fontSize: 74, fontWeight: FontWeight.w900),
            ),
            if (isTwo)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  '💡 لاحظ: الرقم ٢ يُكتب بانحناءة من الأعلى نحو الأسفل، مثل حرف الدال (د) لكن بالعكس.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13),
                ),
              ),
            const SizedBox(height: 6),
            // اختيار لون القلم
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
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: GestureDetector(
                      onPanStart: (d) =>
                          setState(() => points.add(d.localPosition)),
                      onPanUpdate: (d) =>
                          setState(() => points.add(d.localPosition)),
                      onPanEnd: (_) => setState(() => points.add(null)),
                      child: CustomPaint(
                        painter: _BoldDrawingPainter(points, penColor),
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _next(-1),
                      child: const Text('السابق'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => _next(1),
                      child: const Text('التالي'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A bold, clearly-visible pen stroke painter — thick, round-capped lines
/// with a soft glow so a child can clearly see their own writing.
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
      final a = points[i];
      final b = points[i + 1];
      if (a != null && b != null) canvas.drawLine(a, b, pen);
    }
  }

  @override
  bool shouldRepaint(covariant _BoldDrawingPainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.color != color;
}
