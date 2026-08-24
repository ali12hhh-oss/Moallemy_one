import 'package:flutter/material.dart';

import '../../widgets/button_3d.dart';
import '../../widgets/section_background.dart';
import 'g1_letters_words_hub.dart';
import 'g1_harakat_hub.dart';

class G1ArabicHub extends StatelessWidget {
  const G1ArabicHub({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(title: const Text('اللغة العربية 📚'), backgroundColor: Colors.transparent, elevation: 0),
        body: SectionBackground(
          asset: 'assets/images/arabic_bg.jpg',
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 72, 18, 18),
              children: [
                Button3D(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const G1LettersWordsHub())), color: const Color(0xFF7C4DFF), padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22), child: const Row(children: [Text('🔤', style: TextStyle(fontSize: 40)), SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('حروف وكلمات', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)), SizedBox(height: 4), Text('الحروف، والقراءة، والكتابة على السبورة', style: TextStyle(color: Colors.white70))]))])),
                const SizedBox(height: 16),
                Button3D(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const G1HarakatHub())), color: const Color(0xFF2979FF), padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22), child: const Row(children: [Text('◌َ', style: TextStyle(fontSize: 40)), SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('الحركات', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)), SizedBox(height: 4), Text('الفتحة والضمة والكسرة مع النطق والكتابة', style: TextStyle(color: Colors.white70))]))])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
