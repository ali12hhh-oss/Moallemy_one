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
            IconButton(
              onPressed: () => canvasKey.currentState?.clear(),
              tooltip: 'Clear',
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
                  'اكتب الجملة',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  _targets[index],
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                  textDirection: TextDirection.ltr,
                ),
                const SizedBox(height: 6),
                Expanded(child: BoldDrawingCanvas(key: canvasKey)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
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
    );
  }
}
