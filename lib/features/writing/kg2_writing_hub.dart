import 'package:flutter/material.dart';

import '../../widgets/button_3d.dart';
import 'kg2_letter_writing_screen.dart';
import 'kg2_number_writing_screen.dart';

class Kg2WritingHub extends StatelessWidget {
  const Kg2WritingHub({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الكتابة ✏️')),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Button3D(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const Kg2LetterWritingScreen(),
                ),
              ),
              color: const Color(0xFF7C4DFF),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              child: const Row(
                children: [
                  Text('🔤', style: TextStyle(fontSize: 40)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'كتابة الحروف',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'حرف بأشكاله الثلاثة، ودمج حرفين معًا',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Button3D(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const Kg2NumberWritingScreen(),
                ),
              ),
              color: const Color(0xFF2979FF),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              child: const Row(
                children: [
                  Text('🔢', style: TextStyle(fontSize: 40)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'كتابة الأرقام',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'اكتب العدد، ثم ميّز الآحاد من العشرات',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
