import 'package:flutter/material.dart';

import '../../widgets/button_3d.dart';
import 'g1_english_letters_screen.dart';
import 'g1_english_numbers_screen.dart';
import 'g1_english_writing_screen.dart';

class G1EnglishHub extends StatelessWidget {
  const G1EnglishHub({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <(String, String, String, Color, Widget)>[
      (
        '🔤',
        'الحروف الإنجليزية',
        'حروف صغيرة (small) فقط، بصوت الحرف',
        const Color(0xFF7C4DFF),
        const G1EnglishLettersScreen(),
      ),
      (
        '🔢',
        'الأرقام الإنجليزية',
        'من ١ إلى ١٠ مع النطق',
        const Color(0xFF2979FF),
        const G1EnglishNumbersScreen(),
      ),
      (
        '✏️',
        'الكتابة',
        'اكتب الحروف والأرقام مع الاستماع',
        const Color(0xFF00BFA6),
        const G1EnglishWritingScreen(),
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
