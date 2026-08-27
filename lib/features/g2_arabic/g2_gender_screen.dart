import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/storage/progress_v8.dart';
import '../../data/grammar_data.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

class G2GenderScreen extends StatefulWidget {
  const G2GenderScreen({super.key});
  @override
  State<G2GenderScreen> createState() => _G2GenderScreenState();
}

class _G2GenderScreenState extends State<G2GenderScreen> {
  bool learnMode = true;
  final rnd = Random();
  late GenderPair pair;
  late bool showFeminine;
  int score = 0;
  String? cheer;

  static const labels = ['مذكر', 'مؤنث'];
  static const learnHeaders = ['المذكر', 'المؤنث'];
  static const colors = [Color(0xFF2979FF), Color(0xFFFF1E7E)];

  @override
  void initState() {
    super.initState();
    _nextQuiz();
  }

  void _nextQuiz() {
    pair = genderPairs[rnd.nextInt(genderPairs.length)];
    showFeminine = rnd.nextBool();
  }

  void _answer(bool chosenFeminine) {
    if (chosenFeminine == showFeminine) {
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
    final word = showFeminine ? pair.feminine : pair.masculine;
    final emoji = showFeminine ? pair.emojiF : pair.emojiM;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('مؤنث ومذكر')),
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
                          color: learnMode ? const Color(0xFF7C4DFF) : const Color(0xFFB39DDB),
                          depth: learnMode ? 2 : 7,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: const Center(
                            child: Text('تعلّم', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Button3D(
                          onTap: () => setState(() => learnMode = false),
                          color: !learnMode ? const Color(0xFF00C853) : const Color(0xFFA5D6A7),
                          depth: !learnMode ? 2 : 7,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: const Center(
                            child: Text('تدرّب', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (learnMode) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    child: Row(
                      children: List.generate(2, (j) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              learnHeaders[j],
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(14, 6, 14, 14),
                      itemCount: genderPairs.length,
                      itemBuilder: (_, i) {
                        final p = genderPairs[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 3),
                                  child: Button3D(
                                    onTap: () => VoiceService.arabic(p.masculine),
                                    color: colors[0],
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    child: Column(
                                      children: [
                                        Text(p.emojiM, style: const TextStyle(fontSize: 30)),
                                        Text(
                                          p.masculine,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 3),
                                  child: Button3D(
                                    onTap: () => VoiceService.arabic(p.feminine),
                                    color: colors[1],
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    child: Column(
                                      children: [
                                        Text(p.emojiF, style: const TextStyle(fontSize: 30)),
                                        Text(
                                          p.feminine,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                            'هل هذه الكلمة مؤنثة أم مذكرة؟',
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 10),
                          Text(emoji, style: const TextStyle(fontSize: 50)),
                          Text(word, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: Button3D(
                                  onTap: () => _answer(false),
                                  color: colors[0],
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  child: const Center(child: Text('مذكر', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white))),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Button3D(
                                  onTap: () => _answer(true),
                                  color: colors[1],
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  child: const Center(child: Text('مؤنث', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white))),
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
