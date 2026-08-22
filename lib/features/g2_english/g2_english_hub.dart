import 'package:flutter/material.dart';

import '../../widgets/button_3d.dart';
import 'g2_english_letters_screen.dart';
import 'g2_english_vocab_screen.dart';
import 'g2_english_sentences_screen.dart';
import 'g2_english_pronouns_screen.dart';
import 'g2_english_writing_screen.dart';

class G2EnglishHub extends StatelessWidget {
  const G2EnglishHub({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <(String, String, String, Color, Widget)>[
      (
        '🔤',
        'Letters',
        'حروف كبيرة وصغيرة (Aa, Bb...) مع النطق',
        const Color(0xFF7C4DFF),
        const G2EnglishLettersScreen(),
      ),
      (
        '📚',
        'Vocabulary',
        'مفردات أوسع مع الترجمة العربية',
        const Color(0xFF2979FF),
        const G2EnglishVocabScreen(),
      ),
      (
        '💬',
        'Sentences',
        'جمل بسيطة للقراءة والاستماع',
        const Color(0xFF00C853),
        const G2EnglishSentencesScreen(),
      ),
      (
        '🙋',
        'Pronouns',
        'الضمائر: I, you, he, she...',
        const Color(0xFFFF1E7E),
        const G2EnglishPronounsScreen(),
      ),
      (
        '✏️',
        'Writing',
        'اكتب كلمات كاملة مع الاستماع',
        const Color(0xFF00BFA6),
        const G2EnglishWritingScreen(),
      ),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('English 🇬🇧')),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: items.map((g) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Button3D(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => g.$5),
                ),
                color: g.$4,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 20,
                ),
                child: Row(
                  children: [
                    Text(g.$1, style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            g.$2,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            g.$3,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
