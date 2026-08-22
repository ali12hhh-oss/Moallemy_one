import 'package:flutter/material.dart';

import '../../widgets/button_3d.dart';
import 'g3_verb_tense_screen.dart';
import 'g3_question_words_screen.dart';
import 'g3_sentence_type_screen.dart';

class G3GrammarHub extends StatelessWidget {
  const G3GrammarHub({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <(String, String, String, Color, Widget)>[
      (
        '⏰',
        'أزمنة الفعل',
        'ماضٍ، مضارع، ومستقبل',
        const Color(0xFF7C4DFF),
        const G3VerbTenseScreen(),
      ),
      (
        '❓',
        'أدوات الاستفهام',
        'من، ماذا، أين، متى، كيف، لماذا، كم',
        const Color(0xFF2979FF),
        const G3QuestionWordsScreen(),
      ),
      (
        '🏷️',
        'نوع الجملة',
        'جملة اسمية أم فعلية؟',
        const Color(0xFFFF1E7E),
        const G3SentenceTypeScreen(),
      ),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('قواعد اللغة 📝')),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children:
              items.map((g) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Button3D(
                    onTap:
                        () => Navigator.push(
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
