import 'package:flutter/material.dart';

import '../../widgets/button_3d.dart';
import 'g2_write_numbers_screen.dart';
import 'g2_write_recognize_screen.dart';

class G2WritingHub extends StatelessWidget {
  const G2WritingHub({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <(String, String, String, Color, Widget)>[
      (
        '✏️',
        'كتابة الحروف',
        'سبورة ذكية لكتابة الحروف والتعرّف عليها',
        const Color(0xFF00BFA6),
        const G2WriteRecognizeScreen(),
      ),
      (
        '🔢',
        'كتابة الأرقام',
        'تسلسل الأرقام من ١ إلى ٥٠ وتدريب الآحاد والعشرات',
        const Color(0xFF2979FF),
        const G2WriteNumbersScreen(),
      ),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الكتابة')),
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
                  vertical: 22,
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
