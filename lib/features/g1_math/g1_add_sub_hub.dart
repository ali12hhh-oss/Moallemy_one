import 'package:flutter/material.dart';

import '../../widgets/button_3d.dart';
import '../../widgets/speakable_text.dart';
import 'g1_add_sub_screen.dart';

class G1AddSubHub extends StatelessWidget {
  const G1AddSubHub({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const SpeakableText('الجمع والطرح', style: TextStyle(color: Colors.white))),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Button3D(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const G1AddSubScreen(isAddition: true),
                ),
              ),
              color: const Color(0xFF00C853),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              child: const Row(
                children: [
                  Text('➕', style: TextStyle(fontSize: 40)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SpeakableText('الجمع', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                        SizedBox(height: 4),
                        SpeakableText('اجمع الفواكه، والناتج لا يتجاوز ١٠', style: TextStyle(color: Colors.white70)),
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
                  builder: (_) => const G1AddSubScreen(isAddition: false),
                ),
              ),
              color: const Color(0xFFFF6B35),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              child: const Row(
                children: [
                  Text('➖', style: TextStyle(fontSize: 40)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SpeakableText('الطرح', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                        SizedBox(height: 4),
                        SpeakableText('اطرح من الفواكه، والناتج لا يتجاوز ١٠', style: TextStyle(color: Colors.white70)),
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
