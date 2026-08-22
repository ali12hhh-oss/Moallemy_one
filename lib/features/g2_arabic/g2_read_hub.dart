import 'package:flutter/material.dart';

import '../../data/short_words.dart';
import '../../widgets/button_3d.dart';
import '../g1_arabic/g1_read_words_screen.dart';
import 'g2_sentence_read_screen.dart';

class G2ReadHub extends StatelessWidget {
  const G2ReadHub({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <(String, String, String, Color, Widget)>[
      (
        '2️⃣',
        'كلمات من حرفين',
        'دمج حرفين لتكوين كلمة',
        const Color(0xFF7C4DFF),
        const G1ReadWordsScreen(words: twoLetterWords, title: 'كلمات من حرفين'),
      ),
      (
        '3️⃣',
        'كلمات من ثلاثة أحرف',
        'دمج ثلاثة أحرف وتهجئتها',
        const Color(0xFFFF1E7E),
        const G1ReadWordsScreen(
          words: threeLetterWords,
          title: 'كلمات من ثلاثة أحرف',
        ),
      ),
      (
        '4️⃣',
        'كلمات من أربعة أحرف',
        'دمج أربعة أحرف وتهجئتها',
        const Color(0xFF00BFA6),
        const G1ReadWordsScreen(
          words: fourLetterWords,
          title: 'كلمات من أربعة أحرف',
        ),
      ),
      (
        '📝',
        'جمل من مقطعين',
        'اقرأ جملًا قصيرة كاملة',
        const Color(0xFF2979FF),
        const G2SentenceReadScreen(),
      ),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('اقرأ 📖')),
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
