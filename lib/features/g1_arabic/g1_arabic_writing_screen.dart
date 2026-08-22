import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../data/content.dart';
import '../../data/short_words.dart';
import '../../widgets/bold_drawing_canvas.dart';
import '../../widgets/celebration_overlay.dart';

class G1ArabicWritingScreen extends StatefulWidget {
  const G1ArabicWritingScreen({super.key});
  @override
  State<G1ArabicWritingScreen> createState() => _G1ArabicWritingScreenState();
}

class _G1ArabicWritingScreenState extends State<G1ArabicWritingScreen> {
  final canvasKey = GlobalKey<BoldDrawingCanvasState>();
  int index = 0;
  String? cheer;

  // مجموعة كبيرة من الأهداف: كل الحروف، ثم كلمات من حرفين، ثم كلمات من ثلاثة أحرف.
  late final targets = [
    ...arabicLetters.map((l) => (l.letter, l.sound)),
    ...twoLetterWords.map((w) => (w.word, w.word)),
    ...threeLetterWords.map((w) => (w.word, w.word)),
  ];

  void _speak() => VoiceService.arabic(targets[index].$2);

  void _next(int delta) {
    canvasKey.currentState?.clear();
    setState(() {
      index = (index + delta + targets.length) % targets.length;
      cheer = kCheers[index % kCheers.length];
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => cheer = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final target = targets[index];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('الكتابة • ${index + 1} من ${targets.length}'),
          actions: [
            IconButton(
              onPressed: _speak,
              tooltip: 'استمع',
              icon: const Icon(Icons.volume_up_rounded),
            ),
            IconButton(
              onPressed: () => canvasKey.currentState?.clear(),
              tooltip: 'مسح',
              icon: const Icon(Icons.delete_outline_rounded),
            ),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 6),
                const Text(
                  'اكتب على السبورة',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  target.$1,
                  style: const TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Expanded(child: BoldDrawingCanvas(key: canvasKey)),
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
            CelebrationOverlay(message: cheer),
          ],
        ),
      ),
    );
  }
}
