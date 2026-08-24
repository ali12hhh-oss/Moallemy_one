import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../data/content_v11.dart';
import '../../widgets/bold_drawing_canvas.dart';
import '../../widgets/celebration_overlay.dart';

class G2EnglishWritingScreen extends StatefulWidget {
  const G2EnglishWritingScreen({super.key});
  @override
  State<G2EnglishWritingScreen> createState() => _G2EnglishWritingScreenState();
}

class _G2EnglishWritingScreenState extends State<G2EnglishWritingScreen> {
  int index = 0;
  final canvasKey = GlobalKey<BoldDrawingCanvasState>();
  String? cheer;

  void _speak() => VoiceService.english(englishWordsV11[index].word);

  void _next(int delta) {
    canvasKey.currentState?.clear();
    setState(() {
      index = (index + delta + englishWordsV11.length) % englishWordsV11.length;
      cheer = kCheers[index % kCheers.length];
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => cheer = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = englishWordsV11[index];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Writing • ${index + 1}/${englishWordsV11.length}'),
          actions: [
            IconButton(
              onPressed: _speak,
              tooltip: 'Listen',
              icon: const Icon(Icons.volume_up_rounded),
            ),
            IconButton(
              onPressed: () => canvasKey.currentState?.clear(),
              tooltip: 'Clear',
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
                  Center(
                    child: Text(w.emoji, style: const TextStyle(fontSize: 40)),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        Text(
                          w.word,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(
                          w.arabic,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 320,
                    child: BoldDrawingCanvas(key: canvasKey),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => _next(1),
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text('Next'),
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
