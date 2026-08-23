import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/storage/progress_v8.dart';
import '../../data/grammar_data.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

class G3QuestionWordsScreen extends StatefulWidget {
  const G3QuestionWordsScreen({super.key});
  @override
  State<G3QuestionWordsScreen> createState() => _G3QuestionWordsScreenState();
}

class _G3QuestionWordsScreenState extends State<G3QuestionWordsScreen> {
  bool learnMode = true;
  final rnd = Random();
  late QuestionWord target;
  late List<String> options;
  int score = 0;
  String? cheer;

  @override
  void initState() {
    super.initState();
    _nextQuiz();
  }

  void _nextQuiz() {
    target = questionWords[rnd.nextInt(questionWords.length)];
    final others =
        questionWords.map((q) => q.word).where((w) => w != target.word).toList()
          ..shuffle(rnd);
    options = [target.word, ...others.take(3)]..shuffle(rnd);
  }

  void _answer(String chosen) {
    if (chosen == target.word) {
      score++;
      setState(() => cheer = kCheers[rnd.nextInt(kCheers.length)]);
      ProgressV8.addRewards(stars: 1, xp: 5);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => cheer = null);
          _nextQuiz();
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
        appBar: AppBar(title: const Text('أدوات الاستفهام')),
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
                          onTap: () => setState(() => learnMode = true),
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
                          onTap: () => setState(() => learnMode = false),
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
                    child: ListView.builder(
                      padding: const EdgeInsets.all(14),
                      itemCount: questionWords.length,
                      itemBuilder: (_, i) {
                        final q = questionWords[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Button3D(
                            onTap: () => VoiceService.arabic(q.example),
                            color: const Color(0xFF2979FF),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 16,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  q.emoji,
                                  style: const TextStyle(fontSize: 26),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        q.word,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        q.example,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        q.usage,
                                        style: const TextStyle(
                                          color: Colors.white60,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            'أي أداة استفهام نستخدمها هنا؟',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            target.usage,
                            style: const TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: 2,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              children: options
                                  .map(
                                    (o) => Button3D(
                                      onTap: () => _answer(o),
                                      color: const Color(0xFF2979FF),
                                      child: Center(
                                        child: Text(
                                          o,
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
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
