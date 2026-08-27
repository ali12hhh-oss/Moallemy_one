import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/storage/progress_v8.dart';
import '../../data/grammar_data.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

class G2NounVerbScreen extends StatefulWidget {
  const G2NounVerbScreen({super.key});
  @override
  State<G2NounVerbScreen> createState() => _G2NounVerbScreenState();
}

class _G2NounVerbScreenState extends State<G2NounVerbScreen> {
  bool learnMode = true;
  final rnd = Random();
  late NounVerbWord target;
  int score = 0;
  String? cheer;

  @override
  void initState() {
    super.initState();
    _next();
  }

  void _next() {
    target = nounVerbWords[rnd.nextInt(nounVerbWords.length)];
    if (!learnMode) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => VoiceService.arabic(target.word),
      );
    }
  }

  void _answer(bool chosenVerb) {
    if (chosenVerb == target.isVerb) {
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

  void _setMode(bool learn) {
    setState(() {
      learnMode = learn;
      if (!learnMode) {
        _next();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الاسم والفعل')),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Button3D(
                          onTap: () => _setMode(true),
                          color: learnMode
                              ? const Color(0xFF7C4DFF)
                              : const Color(0xFFB39DDB),
                          depth: learnMode ? 2 : 7,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: const Center(
                            child: Text(
                              'تعلّم',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Button3D(
                          onTap: () => _setMode(false),
                          color: !learnMode
                              ? const Color(0xFF00C853)
                              : const Color(0xFFA5D6A7),
                          depth: !learnMode ? 2 : 7,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: const Center(
                            child: Text(
                              'تدرّب',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (learnMode)
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        const Text(
                          'الاسم والفعل',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'الاسم يدل على إنسان أو حيوان أو شيء، أما الفعل فيدل على حدث أو عمل يحدث أو حدث أو سيُطلب القيام به.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 19, height: 1.5),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'أمثلة على الاسم',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...nounVerbWords.where((item) => !item.isVerb).map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Button3D(
                              onTap: () => VoiceService.arabic(item.word),
                              color: const Color(0xFF2979FF),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Center(
                                child: Text(
                                  '${item.emoji}  ${item.word}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'أمثلة على الفعل',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...nounVerbWords.where((item) => item.isVerb).map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Button3D(
                              onTap: () => VoiceService.arabic(item.word),
                              color: const Color(0xFF00C853),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Center(
                                child: Text(
                                  '${item.emoji}  ${item.word}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            'هل هذه الكلمة اسم أم فعل؟',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 18),
                          GestureDetector(
                            onTap: () => VoiceService.arabic(target.word),
                            child: Column(
                              children: [
                                Text(
                                  target.emoji,
                                  style: const TextStyle(fontSize: 60),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  target.word,
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
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
                                      'اسم',
                                      style: TextStyle(
                                        fontSize: 20,
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
                                      'فعل',
                                      style: TextStyle(
                                        fontSize: 20,
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
                  ),
              ],
            ),
            CelebrationOverlay(message: cheer),
          ],
        ),
      ),
    );
  }
}
