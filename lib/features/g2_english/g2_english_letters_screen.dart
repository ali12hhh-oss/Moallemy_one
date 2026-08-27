import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../data/content.dart';
import '../../widgets/button_3d.dart';

/// حروف إنجليزية للصف الثاني، مفصولة إلى مجموعتين: صغيرة وكبيرة.
class G2EnglishLettersScreen extends StatefulWidget {
  const G2EnglishLettersScreen({super.key});

  @override
  State<G2EnglishLettersScreen> createState() => _G2EnglishLettersScreenState();
}

class _G2EnglishLettersScreenState extends State<G2EnglishLettersScreen> {
  bool showLowercase = true;

  @override
  Widget build(BuildContext context) {
    const letters = englishLetters;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: const Text('English Letters')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: Row(
                textDirection: TextDirection.ltr,
                children: [
                  Expanded(
                    child: Button3D(
                      onTap: () => setState(() => showLowercase = true),
                      color: showLowercase
                          ? const Color(0xFF7C4DFF)
                          : const Color(0xFF90A4AE),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      child: const Center(
                        child: Text(
                          'الحروف الصغيرة\nLowercase Letters',
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Button3D(
                      onTap: () => setState(() => showLowercase = false),
                      color: !showLowercase
                          ? const Color(0xFFFF8A65)
                          : const Color(0xFF90A4AE),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      child: const Center(
                        child: Text(
                          'الحروف الكبيرة\nUppercase Letters',
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: letters.length,
                itemBuilder: (_, i) {
                  final e = letters[i];
                  final lower = e.letter.toLowerCase();
                  final displayedLetter =
                      showLowercase ? lower : lower.toUpperCase();
                  return Button3D(
                    onTap: () => VoiceService.englishLetterSound(
                      lower,
                      fallbackText: e.sound,
                    ),
                    color: showLowercase
                        ? const Color(0xFF7C4DFF)
                        : const Color(0xFFFF8A65),
                    padding: const EdgeInsets.all(4),
                    child: Center(
                      child: Text(
                        displayedLetter,
                        textDirection: TextDirection.ltr,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
