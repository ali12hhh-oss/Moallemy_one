import 'package:flutter/material.dart';
import '../../core/audio/voice_service.dart';
import '../../data/content.dart';
import '../../widgets/button_3d.dart';

/// حروف كبيرة وصغيرة معًا (Aa, Bb...) — للصف الثاني.
class G2EnglishLettersScreen extends StatelessWidget {
  const G2EnglishLettersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('English Letters')),
        body: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10),
          itemCount: englishLetters.length,
          itemBuilder: (_, i) {
            final e = englishLetters[i];
            return Button3D(
              onTap: () => VoiceService.englishLetterSound(e.letter.toLowerCase(), fallbackText: e.sound),
              color: const Color(0xFF7C4DFF),
              padding: const EdgeInsets.all(4),
              child: Center(child: Text('${e.letter}${e.letter.toLowerCase()}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white))),
            );
          },
        ),
      ),
    );
  }
}
