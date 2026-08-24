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
    final theme = Theme.of(context);

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
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(12, 5, 12, 3),
                    child: Text(
                      'اكتب على السبورة',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        target.$1,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: isLetter ? 48 : 34,
                          height: 1.05,
                          fontWeight: FontWeight.w900,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: BoldDrawingCanvas(key: canvasKey),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () => _next(-1),
                            icon: const Icon(Icons.arrow_forward_rounded),
                            label: const Text('السابق'),
                            style: FilledButton.styleFrom(
                              minimumSize: const Size(0, 54),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () => canvasKey.currentState?.clear(),
                            icon: const Icon(Icons.delete_sweep_rounded),
                            label: const Text('مسح السبورة'),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFE53935),
                              minimumSize: const Size(0, 54),
                              textStyle: const TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () => _next(1),
                            icon: const Icon(Icons.arrow_back_rounded),
                            label: const Text('التالي'),
                            style: FilledButton.styleFrom(
                              minimumSize: const Size(0, 54),
                            ),
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
      ),
    );
  }
}
