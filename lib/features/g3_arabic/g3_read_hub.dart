import 'package:flutter/material.dart';
import '../../data/short_words.dart';
import '../../widgets/button_3d.dart';
import '../g1_arabic/g1_read_words_screen.dart';
import '../g2_arabic/g2_sentence_read_screen.dart';

class G3ReadHub extends StatelessWidget {
  const G3ReadHub({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <(String, String, Color, Widget)>[
      ('2️⃣', 'كلمات من حرفين', const Color(0xFF7C4DFF), const G1ReadWordsScreen(words: twoLetterWords, title: 'كلمات من حرفين')),
      ('3️⃣', 'كلمات من ثلاثة أحرف', const Color(0xFFFF1E7E), const G1ReadWordsScreen(words: threeLetterWords, title: 'كلمات من ثلاثة أحرف')),
      ('4️⃣', 'كلمات من أربعة أحرف', const Color(0xFF00BFA6), const G1ReadWordsScreen(words: fourLetterWords, title: 'كلمات من أربعة أحرف')),
      ('5️⃣', 'كلمات من خمسة أحرف', const Color(0xFFFF6B35), const G1ReadWordsScreen(words: fiveLetterWords, title: 'كلمات من خمسة أحرف')),
      ('📝', 'جمل من ثلاثة أجزاء', const Color(0xFF2979FF), const G2SentenceReadScreen(sentences: threePartSentences, title: 'جمل من ثلاثة أجزاء')),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('اقرأ 📖')),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: items.map((g) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Button3D(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => g.$4)),
                color: g.$3,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                child: Row(children: [
                  Text(g.$1, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 14),
                  Expanded(child: Text(g.$2, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white))),
                ]),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
