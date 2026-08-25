import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';

class WritingScreen extends StatefulWidget {
  final String? stageId;
  const WritingScreen({super.key, this.stageId});

  @override
  State<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> {
  final points = <Offset>[];
  int index = 0;

  List<String> get targets {
    final advanced = widget.stageId == 'g2' || widget.stageId == 'g3';
    if (advanced) {
      return [
        'باب',
        'كتاب',
        'مدرسة',
        'قلم',
        'شجرة',
        'جميل',
        'cat',
        'book',
        'school',
        'friend',
        'apple',
      ];
    }
    return [
      'ا', 'ب', 'ت', 'ث', 'ج', 'ح', 'د', 'ر', 'س', 'ش', 'م', 'ن', 'ي',
      '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩', '١٠',
      if (widget.stageId == 'prep' || widget.stageId == 'g1') ...[
        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
        'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
      ],
    ];
  }

  String get target => targets[index % targets.length];
  bool get isEnglish => RegExp(r'^[a-z]+$').hasMatch(target);
  bool get isNumber => RegExp(r'^[٠-٩]+$').hasMatch(target);

  void _clearBoard() {
    if (points.isEmpty) return;
    setState(points.clear);
  }

  void _next(int delta) {
    setState(() {
      index = (index + delta + targets.length) % targets.length;
      points.clear();
    });
  }

  void _speak() {
    if (isEnglish) {
      VoiceService.english(target);
    } else {
      VoiceService.arabic(target);
    }
  }

  Widget _bottomButton({
    required String text,
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: SizedBox(
        height: 54,
        child: FilledButton.icon(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          icon: Icon(icon, size: 22),
          label: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final label = isNumber
        ? 'اكتب الرقم'
        : isEnglish
            ? 'اكتب الحرف'
            : (target.length > 1 ? 'اكتب الكلمة' : 'اكتب الحرف');

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
            // يبقى زر المسح العلوي موجوداً، بالإضافة إلى زر المسح الواضح أسفل السبورة.
            IconButton(
              onPressed: _clearBoard,
              tooltip: 'مسح السبورة',
              icon: const Icon(Icons.delete_outline_rounded),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                target,
                textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
                style: const TextStyle(fontSize: 76, fontWeight: FontWeight.w900),
              ),
              const Text(
                'اتبع النموذج ثم حاول الكتابة بإصبعك ✨',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
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
                        behavior: HitTestBehavior.opaque,
                        onPanStart: (details) {
                          setState(() => points.add(details.localPosition));
                        },
                        onPanUpdate: (details) {
                          setState(() => points.add(details.localPosition));
                        },
                        onPanEnd: (_) {
                          // يفصل بين ضربات الإصبع حتى لا تتصل الكتابات المنفصلة.
                          setState(() => points.add(Offset.infinite));
                        },
                        child: CustomPaint(
                          painter: DrawingPainter(points),
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
                    _bottomButton(
                      text: 'السابق',
                      icon: Icons.arrow_forward_rounded,
                      color: const Color(0xFF26A69A),
                      onPressed: () => _next(-1),
                    ),
                    const SizedBox(width: 8),
                    _bottomButton(
                      text: 'مسح السبورة',
                      icon: Icons.delete_sweep_rounded,
                      color: const Color(0xFFE53935),
                      onPressed: _clearBoard,
                    ),
                    const SizedBox(width: 8),
                    _bottomButton(
                      text: 'التالي',
                      icon: Icons.arrow_back_rounded,
                      color: const Color(0xFF5E35B1),
                      onPressed: () => _next(1),
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

class DrawingPainter extends CustomPainter {
  final List<Offset> points;
  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final pen = Paint()
      ..color = Colors.black87
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final dotPen = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    for (var i = 0; i < points.length; i++) {
      final current = points[i];
      if (current == Offset.infinite) continue;

      final previous = i > 0 ? points[i - 1] : Offset.infinite;
      if (previous == Offset.infinite) {
        // يظهر حتى الضغط المفرد على السبورة، وليس فقط الحركة.
        canvas.drawCircle(current, pen.strokeWidth / 2, dotPen);
      } else {
        canvas.drawLine(previous, current, pen);
      }
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) => true;
}
