import 'package:flutter/material.dart';

import '../../widgets/button_3d.dart';
import 'g2_math_numbers_screen.dart';
import 'g2_add_sub_hub.dart';
import 'g2_compare_order_screen.dart';
import 'g2_multiplication_screen.dart';
import 'g2_word_problems_screen.dart';

class G2MathHub extends StatelessWidget {
  const G2MathHub({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <(String, String, String, Color, Widget)>[
      (
        '🔢',
        'الأرقام',
        'من ١ إلى ٩٩٩ على صفحات، والآحاد والعشرات والمئات',
        const Color(0xFF2979FF),
        const G2MathNumbersScreen(),
      ),
      (
        '➕',
        'الجمع والطرح',
        'أفقي وعمودي، بأرقام حتى ٩٩',
        const Color(0xFF00C853),
        const G2AddSubHub(),
      ),
      (
        '⚖️',
        'المقارنة والترتيب',
        'أكبر أم أصغر، وترتيب تصاعدي وتنازلي',
        const Color(0xFF7C4DFF),
        const G2CompareOrderScreen(),
      ),
      (
        '✖️',
        'الضرب',
        'جدول الضرب من ١ إلى ٥',
        const Color(0xFFFF6B35),
        const G2MultiplicationScreen(),
      ),
      (
        '🧩',
        'مسائل كلامية',
        'مسائل حياتية بسيطة تُدرَّب الجمع والطرح',
        const Color(0xFFFF1E7E),
        const G2WordProblemsScreen(),
      ),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الرياضيات 🧮')),
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
