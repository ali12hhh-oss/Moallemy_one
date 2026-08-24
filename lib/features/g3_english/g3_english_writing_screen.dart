import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../widgets/bold_drawing_canvas.dart';
import '../../widgets/celebration_overlay.dart';

const _targets = [
  'I am happy',
  'I like school',
  'She is my friend',
  'He is playing',
  'We are here',
  'The sun is hot',
  'I have a book',
  'They are kind',
];

class G3EnglishWritingScreen extends StatefulWidget {
  const G3EnglishWritingScreen({super.key});
  @override
  State<G3EnglishWritingScreen> createState() => _G3EnglishWritingScreenState();
}

class _G3EnglishWritingScreenState extends State<G3EnglishWritingScreen> {
  int index = 0;
  final canvasKey = GlobalKey<BoldDrawingCanvasState>();
  String? cheer;

  void _speak() => VoiceService.english(_targets[index]);

  void _next(int delta) {
    canvasKey.currentState?.clear();
    setState(() {
      index = (index + delta + _targets.length) % _targets.length;
      cheer = kCheers[index % kCheers.length];
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => cheer = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Writing • ${index + 1}/${_targets.length}'),
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
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 7),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _targets[index],
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w900,
                          color: theme.colorScheme.primary,
                        ),
                      ),
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
