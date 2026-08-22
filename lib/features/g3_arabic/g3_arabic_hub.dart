import 'package:flutter/material.dart';

import '../../widgets/button_3d.dart';
import 'g3_letters_words_hub.dart';
import 'g3_grammar_hub.dart';

class G3ArabicHub extends StatelessWidget {
  const G3ArabicHub({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <(String, String, String, Color, Widget)>[
      (
        '🔤',
        'حروف وكلمات',
        'كلمات حتى خمسة أحرف، جمل أطول، وفقرة قراءة بأسئلة',
        const Color(0xFF7C4DFF),
        const G3LettersWordsHub(),
      ),
      (
        '📝',
        'قواعد اللغة',
        'أزمنة الفعل، أدوات الاستفهام، ونوع الجملة',
        const Color(0xFFFF1E7E),
        const G3GrammarHub(),
      ),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('اللغة العربية 📚')),
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
                      vertical: 22,
                    ),
                    child: Row(
                      children: [
                        Text(g.$1, style: const TextStyle(fontSize: 36)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                g.$2,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                g.$3,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
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
