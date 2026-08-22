import 'package:flutter/material.dart';

import '../../widgets/button_3d.dart';
import '../letters/letters_screen.dart';
import 'g1_read_hub.dart';
import 'g1_arabic_writing_screen.dart';

class G1LettersWordsHub extends StatelessWidget {
  const G1LettersWordsHub({super.key});

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
        'كلمات من حرفين وثلاثة أحرف مع الهجاء',
        const Color(0xFFFF6B35),
        const G1ReadHub(),
      ),
      (
        '✏️',
        'الكتابة',
        'سبورة احترافية بألوان مختلفة لكل الحروف والكلمات',
        const Color(0xFF00BFA6),
        const G1ArabicWritingScreen(),
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
                        Text(g.$1, style: const TextStyle(fontSize: 36)),
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
