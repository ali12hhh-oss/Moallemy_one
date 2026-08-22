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
      'ا',
      'ب',
      'ت',
      'ث',
      'ج',
      'ح',
      'د',
      'ر',
      'س',
      'ش',
      'م',
      'ن',
      'ي',
      '١',
      '٢',
      '٣',
      '٤',
      '٥',
      '٦',
      '٧',
      '٨',
      '٩',
      '١٠',
      if (widget.stageId == 'prep' || widget.stageId == 'g1') ...[
        'a',
        'b',
        'c',
        'd',
        'e',
        'f',
        'g',
        'h',
        'i',
        'j',
        'k',
        'l',
        'm',
        'n',
        'o',
        'p',
        'q',
        'r',
        's',
        't',
        'u',
        'v',
        'w',
        'x',
        'y',
        'z',
      ],
    ];
  }

  String get target => targets[index % targets.length];
  bool get isEnglish => RegExp(r'^[a-z]+$').hasMatch(target);
  bool get isNumber => RegExp(r'^[٠-٩]+$').hasMatch(target);

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
            IconButton(
              onPressed: () => setState(points.clear),
              tooltip: 'مسح',
              icon: const Icon(Icons.delete_outline_rounded),
            ),
          ],
        ),
        body: Column(
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
                padding: const EdgeInsets.all(12),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: GestureDetector(
                      onPanStart: (d) =>
                          setState(() => points.add(d.localPosition)),
                      onPanUpdate: (d) =>
                          setState(() => points.add(d.localPosition)),
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

class DrawingPainter extends CustomPainter {
  final List<Offset> points;
  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final pen = Paint()
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    for (var i = 1; i < points.length; i++) {
      canvas.drawLine(points[i - 1], points[i], pen);
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) =>
      oldDelegate.points != points;
}
