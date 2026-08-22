import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../data/pronouns.dart';
import '../../widgets/button_3d.dart';

class G2EnglishPronounsScreen extends StatelessWidget {
  const G2EnglishPronounsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('Pronouns 🙋')),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: englishPronouns.length,
          itemBuilder: (_, i) {
            final p = englishPronouns[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Button3D(
                onTap: () => VoiceService.english(p.word),
                color: const Color(0xFFFF1E7E),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),
                child: Row(
                  children: [
                    Text(p.emoji, style: const TextStyle(fontSize: 30)),
                    const SizedBox(width: 14),
                    Text(
                      p.word,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      p.arabic,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
