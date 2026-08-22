import 'package:flutter/material.dart';

import '../../widgets/button_3d.dart';
import '../letters/letters_screen.dart';
import '../g2_arabic/g2_write_recognize_screen.dart';
import 'g3_read_hub.dart';
import 'g3_reading_passage_screen.dart';

class G3LettersWordsHub extends StatelessWidget {
  const G3LettersWordsHub({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <(String, String, String, Color, Widget)>[
      (
        '🔤',
        'الحروف',
        'كل الحروف الـ٢٨: صوت الحرف واسمه',
        const Color(0xFF7C4DFF),
        const LettersScreen(),
      ),
      (
        '📖',
        'اقرأ',
        'كلمات من حرفين إلى خمسة أحرف، وجمل من ثلاثة أجزاء',
        const Color(0xFFFF6B35),
        const G3ReadHub(),
      ),
      (
        '📰',
        'القراءة',
        'فقرات قصيرة مع أسئلة فهم',
        const Color(0xFF00C853),
        const G3ReadingPassageScreen(),
      ),
      (
        '✏️',
        'الكتابة الذكية',
        'اكتب جملة كاملة والتطبيق يقرأها بصوته',
        const Color(0xFF00BFA6),
        const G2WriteRecognizeScreen(),
      ),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('حروف وكلمات')),
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
                        Text(g.$1, style: const TextStyle(fontSize: 34)),
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
