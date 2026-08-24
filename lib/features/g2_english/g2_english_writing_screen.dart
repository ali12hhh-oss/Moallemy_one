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
    final theme = Theme.of(context);

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
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 3, 10, 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(w.emoji, style: const TextStyle(fontSize: 30)),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            w.word,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900, color: theme.colorScheme.primary),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            w.arabic,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                            label: const Text('Previous'),
                            style: FilledButton.styleFrom(minimumSize: const Size(0, 54)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () => canvasKey.currentState?.clear(),
                            icon: const Icon(Icons.delete_sweep_rounded),
                            label: const Text('Clear board'),
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
                            label: const Text('Next'),
                            style: FilledButton.styleFrom(minimumSize: const Size(0, 54)),
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
