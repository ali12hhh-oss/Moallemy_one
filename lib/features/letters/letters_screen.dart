import 'package:flutter/material.dart';

import '../../data/content.dart';
import '../../core/audio/voice_service.dart';
import '../../widgets/speakable_text.dart';

class LettersScreen extends StatefulWidget {
  const LettersScreen({super.key});
  @override
  State<LettersScreen> createState() => _S();
}

class _S extends State<LettersScreen> {
  int i = 0;

  String _letterName(String x) =>
      const {
        'أ': 'ألف', 'ب': 'باء', 'ت': 'تاء', 'ث': 'ثاء', 'ج': 'جيم',
        'ح': 'حاء', 'خ': 'خاء', 'د': 'دال', 'ذ': 'ذال', 'ر': 'راء',
        'ز': 'زاي', 'س': 'سين', 'ش': 'شين', 'ص': 'صاد', 'ض': 'ضاد',
        'ط': 'طاء', 'ظ': 'ظاء', 'ع': 'عين', 'غ': 'غين', 'ف': 'فاء',
        'ق': 'قاف', 'ك': 'كاف', 'ل': 'لام', 'م': 'ميم', 'ن': 'نون',
        'ه': 'هاء', 'و': 'واو', 'ي': 'ياء',
      }[x] ?? x;

  static ButtonStyle _navigationButtonStyle() => FilledButton.styleFrom(
        minimumSize: const Size(0, 52),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w900,
        ),
      );

  @override
  Widget build(BuildContext c) {
    final l = arabicLetters[i];
    final name = _letterName(l.letter);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const SpeakableText('الحروف العربية')),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              LinearProgressIndicator(value: (i + 1) / arabicLetters.length),
              const SizedBox(height: 12),
              Center(
                child: SpeakableText('الحرف ${i + 1} من ${arabicLetters.length}'),
              ),
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      SpeakableText(
                        l.letter,
                        style: const TextStyle(
                          fontSize: 96,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SpeakableText(
                        'صوت الحرف: ${l.sound}',
                        style: const TextStyle(fontSize: 23),
                      ),
                      const SizedBox(height: 4),
                      SpeakableText(
                        'اسم الحرف: $name',
                        style: const TextStyle(fontSize: 19),
                      ),
                      const SizedBox(height: 4),
                      SpeakableText(
                        '${l.emoji}  ${l.word}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => VoiceService.arabicLetterSound(
                            l.letter,
                            fallbackText: l.sound,
                          ),
                          icon: const Icon(Icons.volume_up),
                          label: const Text('استمع إلى صوت الحرف'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => VoiceService.arabic(l.word),
                          icon: const Icon(Icons.record_voice_over),
                          label: const Text('استمع إلى الكلمة'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => VoiceService.arabicLetterName(l.letter),
                          icon: const Icon(Icons.badge),
                          label: const Text('اسم الحرف'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      style: _navigationButtonStyle(),
                      onPressed: i == 0 ? null : () => setState(() => i--),
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const SpeakableText('السابق'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      style: _navigationButtonStyle(),
                      onPressed: i == arabicLetters.length - 1
                          ? null
                          : () => setState(() => i++),
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const SpeakableText('التالي'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
