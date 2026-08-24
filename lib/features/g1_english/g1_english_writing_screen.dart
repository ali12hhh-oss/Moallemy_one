import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../data/content.dart';
import '../../widgets/bold_drawing_canvas.dart';
import '../../widgets/celebration_overlay.dart';
import '../../widgets/button_3d.dart';

class G1EnglishWritingScreen extends StatefulWidget {
  const G1EnglishWritingScreen({super.key});
  @override
  State<G1EnglishWritingScreen> createState() => _G1EnglishWritingScreenState();
}

class _G1EnglishWritingScreenState extends State<G1EnglishWritingScreen> {
  bool lettersMode = true;
  int index = 0;
  final canvasKey = GlobalKey<BoldDrawingCanvasState>();
  String? cheer;

  static const numberWords = {
    1: 'one', 2: 'two', 3: 'three', 4: 'four', 5: 'five',
    6: 'six', 7: 'seven', 8: 'eight', 9: 'nine', 10: 'ten',
  };

  void _switch(bool letters) {
    canvasKey.currentState?.clear();
    setState(() {
      lettersMode = letters;
      index = 0;
    });
  }

  void _speak() {
    if (lettersMode) {
      final e = englishLetters[index];
      VoiceService.englishLetterSound(e.letter.toLowerCase(), fallbackText: e.sound);
    } else {
      VoiceService.english(numberWords[index + 1]!);
    }
  }

  void _next(int delta) {
    canvasKey.currentState?.clear();
    final len = lettersMode ? englishLetters.length : 10;
    setState(() {
      index = (index + delta + len) % len;
      cheer = kCheers[index % kCheers.length];
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => cheer = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final target = lettersMode ? englishLetters[index].letter.toLowerCase() : '${index + 1}';
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Writing ✏️'),
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
                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Button3D(
                            onTap: () => _switch(true),
                            color: lettersMode ? const Color(0xFF7C4DFF) : const Color(0xFFB39DDB),
                            depth: lettersMode ? 2 : 7,
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            child: const Center(
                              child: Text('Letters 🔤', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Button3D(
                            onTap: () => _switch(false),
                            color: !lettersMode ? const Color(0xFF2979FF) : const Color(0xFF90CAF9),
                            depth: !lettersMode ? 2 : 7,
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            child: const Center(
                              child: Text('Numbers 🔢', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        target,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: lettersMode ? 48 : 40, height: 1.0, fontWeight: FontWeight.w900, color: theme.colorScheme.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
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
