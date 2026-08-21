import 'package:flutter/material.dart';
import '../../core/audio/voice_service.dart';
import '../../data/content.dart';
import '../../widgets/button_3d.dart';

class G2EnglishSentencesScreen extends StatelessWidget {
  const G2EnglishSentencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('Sentences 💬')),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: englishSentences.length,
          itemBuilder: (_, i) {
            final s = englishSentences[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Button3D(
                onTap: () => VoiceService.english(s),
                color: const Color(0xFF00C853),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                child: Row(children: [
                  const Icon(Icons.volume_up_rounded, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(child: Text(s, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white))),
                ]),
              ),
            );
          },
        ),
      ),
    );
  }
}
