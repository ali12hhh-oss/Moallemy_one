import 'package:flutter/material.dart';

import '../../widgets/button_3d.dart';
import '../../widgets/speakable_text.dart';
import 'g1_multiplication_screen.dart';
import 'g1_counting_screen.dart';

class G1MultCountHub extends StatelessWidget {
  const G1MultCountHub({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const SpeakableText('الضرب والعدّ')),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Button3D(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const G1MultiplicationScreen()),
              ),
              color: const Color(0xFF7C4DFF),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              child: const Row(
                children: [
                  Text('✖️', style: TextStyle(fontSize: 40)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SpeakableText('الضرب', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                        SizedBox(height: 4),
                        SpeakableText('جدول الضرب ١ و٢ و٣ مع النطق', style: TextStyle(color: Colors.white70)),
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
                MaterialPageRoute(builder: (_) => const G1CountingScreen()),
              ),
              color: const Color(0xFF00BFA6),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              child: const Row(
                children: [
                  Text('🔢', style: TextStyle(fontSize: 40)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SpeakableText('العدّ التصاعدي والتنازلي', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                        SizedBox(height: 4),
                        SpeakableText('أكمل السلسلة صعودًا ونزولًا', style: TextStyle(color: Colors.white70)),
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
