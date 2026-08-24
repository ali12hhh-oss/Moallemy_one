import 'package:flutter/material.dart';

import '../../widgets/button_3d.dart';
import '../../widgets/section_background.dart';
import '../g2_english/g2_english_vocab_screen.dart';
import 'g3_english_sentences_screen.dart';
import 'g3_english_reading_screen.dart';
import 'g3_english_writing_screen.dart';

class G3EnglishHub extends StatelessWidget {
  const G3EnglishHub({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <(String, String, String, Color, Widget)>[
      ('📚', 'Vocabulary', 'مفردات واسعة مع الترجمة العربية', const Color(0xFF2979FF), const G2EnglishVocabScreen()),
      ('💬', 'Sentences', 'جمل is / am / are مع النطق والترجمة', const Color(0xFF00C853), const G3EnglishSentencesScreen()),
      ('📰', 'Reading', 'فقرة قصيرة مع أسئلة فهم', const Color(0xFFFF6B35), const G3EnglishReadingScreen()),
      ('✏️', 'Writing', 'اكتب جملًا كاملة مع الاستماع', const Color(0xFF00BFA6), const G3EnglishWritingScreen()),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('English 🇬🇧'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SectionBackground(
          asset: 'assets/images/english_bg.jpg',
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 72, 18, 18),
              children: items.map((g) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Button3D(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => g.$5),
                    ),
                    color: g.$4,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                    child: Row(
                      children: [
                        Text(g.$1, style: const TextStyle(fontSize: 32)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(g.$2, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                              const SizedBox(height: 3),
                              Text(g.$3, style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
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
        ),
      ),
    );
  }
}
