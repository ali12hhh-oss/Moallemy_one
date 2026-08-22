import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../data/content.dart';
import '../../widgets/button_3d.dart';

/// حروف إنجليزية صغيرة (lowercase) حصرًا، مع نطق **صوت** الحرف (مثل "بَ"
/// وليس اسمه "بي") تمشيًا مع أسلوب الفونكس (phonics).
class G1EnglishLettersScreen extends StatelessWidget {
  const G1EnglishLettersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('English Letters')),
        body: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: englishLetters.length,
          itemBuilder: (_, i) {
            final e = englishLetters[i];
            final lower = e.letter.toLowerCase();
            return Button3D(
              onTap:
                  () => VoiceService.englishLetterSound(
                    lower,
                    fallbackText: e.sound,
                  ),
              color: const Color(0xFF7C4DFF),
              padding: const EdgeInsets.all(6),
              child: Center(
                child: Text(
                  lower,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
