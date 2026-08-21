import 'package:flutter/material.dart';
import '../../widgets/button_3d.dart';
import 'g3_math_numbers_screen.dart';
import 'g3_add_sub_hub.dart';
import 'g3_multiplication_screen.dart';
import 'g3_division_screen.dart';
import 'g3_fractions_screen.dart';
import 'g3_word_problems_screen.dart';

class G3MathHub extends StatelessWidget {
  const G3MathHub({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <(String, String, String, Color, Widget)>[
      ('🔢', 'الأرقام', 'من ١ إلى ٩٩٩٩ على صفحات', const Color(0xFF2979FF), const G3MathNumbersScreen()),
      ('➕', 'الجمع والطرح', 'أفقي وعمودي، بأرقام حتى ٩٩٩', const Color(0xFF00C853), const G3AddSubHub()),
      ('✖️', 'الضرب', 'جدول الضرب الكامل من ١ إلى ١٠', const Color(0xFF7C4DFF), const G3MultiplicationScreen()),
      ('➗', 'القسمة', 'مفهوم جديد: التوزيع بالتساوي', const Color(0xFFFF6B35), const G3DivisionScreen()),
      ('🍕', 'الكسور', 'نصف، ثلث، وربع — بصريًا', const Color(0xFFFF1E7E), const G3FractionsScreen()),
      ('🧩', 'مسائل كلامية', 'مسائل متنوعة: جمع، طرح، ضرب، وقسمة', const Color(0xFF00BFA6), const G3WordProblemsScreen()),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الرياضيات 🧮')),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: items.map((g) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Button3D(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => g.$5)),
                color: g.$4,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                child: Row(children: [
                  Text(g.$1, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(g.$2, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                      const SizedBox(height: 3),
                      Text(g.$3, style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
                    ]),
                  ),
                ]),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
