import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/storage/progress_v8.dart';
import '../../data/grammar_data.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

class G3SentenceTypeScreen extends StatefulWidget {
  const G3SentenceTypeScreen({super.key});
  @override
  State<G3SentenceTypeScreen> createState() => _G3SentenceTypeScreenState();
}

class _G3SentenceTypeScreenState extends State<G3SentenceTypeScreen> {
  final rnd = Random();
  late SentenceTypeItem target;
  int score = 0;
  String? cheer;

  @override
  void initState() {
    super.initState();
    _next();
  }

  void _next() {
    target = sentenceTypes[rnd.nextInt(sentenceTypes.length)];
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => VoiceService.arabic(target.sentence),
    );
  }

  void _answer(bool chosenVerbal) {
    if (chosenVerbal == target.isVerbal) {
      score++;
      setState(() => cheer = kCheers[rnd.nextInt(kCheers.length)]);
      ProgressV8.addRewards(stars: 1, xp: 5);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => cheer = null);
          _next();
        }
      });
    } else {
      setState(() => cheer = 'حاول مرة أخرى 💪');
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) setState(() => cheer = null);
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('نوع الجملة')),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'الجملة الاسمية تبدأ باسم. الجملة الفعلية تبدأ بفعل.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 26),
                  GestureDetector(
                    onTap: () => VoiceService.arabic(target.sentence),
                    child: Text(
                      target.sentence,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: Button3D(
                          onTap: () => _answer(false),
                          color: const Color(0xFF2979FF),
                          padding: const EdgeInsets.symmetric(vertical: 22),
                          child: const Center(
                            child: Text(
                              'اسمية',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Button3D(
                          onTap: () => _answer(true),
                          color: const Color(0xFF00C853),
                          padding: const EdgeInsets.symmetric(vertical: 22),
                          child: const Center(
                            child: Text(
                              'فعلية',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CelebrationOverlay(message: cheer),
          ],
        ),
      ),
    );
  }
}
