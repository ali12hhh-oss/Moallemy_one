import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/localization/letter_forms.dart';
import '../../data/content.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

/// حروف الروضة الثانية: كل حرف يُعرض بأشكاله الثلاثة (أول الكلمة، وسطها،
/// آخرها) مع النطق لكل شكل، وأزرار 3D، وكلمة تشجيع تظهر وسط الشاشة.
class Kg2LettersScreen extends StatefulWidget {
  const Kg2LettersScreen({super.key});
  @override
  State<Kg2LettersScreen> createState() => _Kg2LettersScreenState();
}

class _Kg2LettersScreenState extends State<Kg2LettersScreen> {
  int index = 0;
  String? cheer;

  static const colors = [
    Color(0xFF7C4DFF),
    Color(0xFF00BFA6),
    Color(0xFFFF6B35),
    Color(0xFF2979FF),
    Color(0xFFFF1E7E),
  ];

  void _next(int delta) {
    setState(
      () =>
          index = (index + delta + arabicLetters.length) % arabicLetters.length,
    );
  }

  void _onFormTap(String form) {
    VoiceService.arabicLetterSound(
      arabicLetters[index].letter,
      fallbackText: arabicLetters[index].sound,
    );
    setState(() => cheer = kCheers[index % kCheers.length]);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => cheer = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final letter = arabicLetters[index];
    final forms = LetterForms.of(letter.letter);
    final color = colors[index % colors.length];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('الحروف • حرف ${index + 1} من ${arabicLetters.length}'),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: (index + 1) / arabicLetters.length,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'حرف ${letter.sound}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: forms.all.map((f) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          child: Button3D(
                            onTap: () => _onFormTap(f.$2),
                            color: color,
                            padding: const EdgeInsets.symmetric(
                              vertical: 18,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  f.$2,
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  f.$1,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '${letter.emoji} ${letter.word}',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => VoiceService.arabic(letter.word),
                    icon: const Icon(Icons.record_voice_over),
                    label: const Text('استمع إلى الكلمة'),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _next(-1),
                          child: const Text('السابق'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => _next(1),
                          child: const Text('التالي'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CelebrationOverlay(message: cheer),
          ],
        ),
      ),
    );
  }
}
