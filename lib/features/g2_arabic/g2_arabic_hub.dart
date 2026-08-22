import 'package:flutter/material.dart';

import '../../widgets/button_3d.dart';
import '../g1_arabic/g1_harakat_hub.dart';
import 'g2_letters_words_hub.dart';
import 'g2_grammar_hub.dart';

class G2ArabicHub extends StatelessWidget {
  const G2ArabicHub({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <(String, String, String, Color, Widget)>[
      (
        '🔤',
        'حروف وكلمات',
        'الحروف، اقرأ (حرفين إلى جمل)، الكتابة الذكية',
        const Color(0xFF7C4DFF),
        const G2LettersWordsHub(),
      ),
      (
        '◌َ',
        'الحركات',
        'الفتحة والضمة والكسرة مع النطق والكتابة',
        const Color(0xFF2979FF),
        const G1HarakatHub(),
      ),
      (
        '📝',
        'قواعد اللغة',
        'ال التعريف، المفرد والمثنى والجمع، المؤنث والمذكر، الاسم والفعل',
        const Color(0xFFFF1E7E),
        const G2GrammarHub(),
      ),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('اللغة العربية 📚')),
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
                    Text(g.$1, style: const TextStyle(fontSize: 34)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            g.$2,
                            style: const TextStyle(
                              fontSize: 19,
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
