import 'package:flutter/material.dart';

import '../../data/short_words.dart';
import '../../widgets/button_3d.dart';
import 'g1_read_words_screen.dart';

class G1ReadHub extends StatelessWidget {
  const G1ReadHub({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('اقرأ 📖')),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Button3D(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => const G1ReadWordsScreen(
                            words: twoLetterWords,
                            title: 'كلمات من حرفين',
                          ),
                    ),
                  ),
              color: const Color(0xFF7C4DFF),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              child: const Row(
                children: [
                  Text('2️⃣', style: TextStyle(fontSize: 40)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'كلمات من حرفين',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'تعلّم دمج حرفين لتكوين كلمة',
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
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => const G1ReadWordsScreen(
                            words: threeLetterWords,
                            title: 'كلمات من ثلاثة أحرف',
                          ),
                    ),
                  ),
              color: const Color(0xFFFF1E7E),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              child: const Row(
                children: [
                  Text('3️⃣', style: TextStyle(fontSize: 40)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'كلمات من ثلاثة أحرف',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'تعلّم دمج ثلاثة أحرف وتهجئتها',
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
