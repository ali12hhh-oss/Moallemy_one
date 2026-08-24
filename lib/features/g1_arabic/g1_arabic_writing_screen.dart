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

  late final targets = [
    ...arabicLetters.map((l) => (l.letter, l.sound)),
    ...twoLetterWords.map((w) => (w.word, w.word)),
    ...threeLetterWords.map((w) => (w.word, w.word)),
  ];

  void _speak() {
    final target = targets[index];
    if (target.$1.runes.length == 1) {
      VoiceService.arabicLetterSound(target.$1, fallbackText: target.$2);
    } else {
      VoiceService.arabic(target.$2);
    }
  }

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
    final isLetter = target.$1.runes.length == 1;

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
        body: SafeArea(
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
                children: [
                  const Center(
                    child: Text(
                      'اكتب على السبورة',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      target.$1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isLetter ? 58 : 42,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 320,
                    child: BoldDrawingCanvas(key: canvasKey),
                  ),
                  const SizedBox(height: 10),
                  Row(
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
                ],
              ),
              CelebrationOverlay(message: cheer),
            ],
          ),
        ),
      ),
    );
  }
}
