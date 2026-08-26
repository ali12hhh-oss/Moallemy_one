import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/section_background.dart';
import 'g1_math_numbers_screen.dart';
import 'g1_add_sub_hub.dart';
import 'g1_mult_count_hub.dart';

class G1MathHub extends StatelessWidget {
  const G1MathHub({super.key});

  Widget _speakable(String text, TextStyle style) => GestureDetector(
        onTap: () => VoiceService.speak(text, language: 'ar-SA'),
        child: Text(text, style: style),
      );

  @override
  Widget build(BuildContext context) {
    final items = <(String, String, String, Color, Widget)>[
      ('🔢', 'الأرقام', 'من ١ إلى ١٠٠، مع الآحاد والعشرات والمئات', const Color(0xFF2979FF), const G1MathNumbersScreen()),
      ('➕', 'الجمع والطرح', 'بالفواكه، والناتج لا يتجاوز ١٠', const Color(0xFF00C853), const G1AddSubHub()),
      ('✖️', 'الضرب والعدّ', 'جدول ١ و٢ و٣، وعدّ تصاعدي وتنازلي', const Color(0xFF7C4DFF), const G1MultCountHub()),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: _speakable('الرياضيات', const TextStyle(fontWeight: FontWeight.w700)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SectionBackground(
          asset: 'assets/images/math_bg.jpg',
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 72, 18, 18),
              children: items
                  .map(
                    (g) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Button3D(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => g.$5)),
                        color: g.$4,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                        child: Row(
                          children: [
                            Text(g.$1, style: const TextStyle(fontSize: 36)),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(g.$2, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: Colors.white)),
                                  const SizedBox(height: 3),
                                  Text(g.$3, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
