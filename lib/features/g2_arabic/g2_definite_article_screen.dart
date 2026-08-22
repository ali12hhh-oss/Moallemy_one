import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../data/grammar_data.dart';
import '../../core/storage/progress_v8.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

/// "ال" التعريف تُضاف في بداية الكلمة النكرة فتصبح كلمة معرفة: قلم ← القلم.
class G2DefiniteArticleScreen extends StatefulWidget {
  const G2DefiniteArticleScreen({super.key});
  @override
  State<G2DefiniteArticleScreen> createState() =>
      _G2DefiniteArticleScreenState();
}

class _G2DefiniteArticleScreenState extends State<G2DefiniteArticleScreen> {
  bool learnMode = true;
  final rnd = Random();
  late DefiniteArticlePair target;
  late List<String> options;
  int score = 0;
  String? cheer;

  @override
  void initState() {
    super.initState();
    _nextQuiz();
  }

  void _nextQuiz() {
    target = definiteArticlePairs[rnd.nextInt(definiteArticlePairs.length)];
    final others =
        definiteArticlePairs
            .map((p) => p.defined)
            .where((d) => d != target.defined)
            .toList()
          ..shuffle(rnd);
    options = [target.defined, ...others.take(3)]..shuffle(rnd);
  }

  void _answer(String chosen) {
    if (chosen == target.defined) {
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
        appBar: AppBar(title: const Text('ال التعريف')),
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
                          color:
                              learnMode
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
                          color:
                              !learnMode
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
                if (learnMode) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'عندما نضيف "ال" في بداية الكلمة، تتحوّل من كلمة عامة (نكرة) إلى كلمة محددة (معرفة).',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(14),
                      itemCount: definiteArticlePairs.length,
                      itemBuilder: (_, i) {
                        final p = definiteArticlePairs[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Button3D(
                            onTap:
                                () => VoiceService.arabic(
                                  '${p.bare}... ${p.defined}',
                                ),
                            color: const Color(0xFF7C4DFF),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  p.emoji,
                                  style: const TextStyle(fontSize: 26),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  p.bare,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.arrow_back_rounded,
                                  color: Colors.white70,
                                  size: 18,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  p.defined,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ] else
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            'ما الشكل المعرَّف لكلمة:',
                            style: TextStyle(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${target.emoji}  ${target.bare}',
                            style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: 2,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              children:
                                  options
                                      .map(
                                        (o) => Button3D(
                                          onTap: () => _answer(o),
                                          color: const Color(0xFF00C853),
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
