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

  Widget _genderCard({
    required String word,
    required String emoji,
    required Color color,
  }) {
    return SizedBox(
      width: 155,
      height: 112,
      child: Button3D(
        onTap: () => VoiceService.arabic(word),
        color: color,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 30)),
              const SizedBox(height: 2),
              Text(
                word,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 155,
                        child: const Center(
                          child: Text(
                            'المؤنث',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                      const SizedBox(width: 28),
                      const SizedBox(
                        width: 155,
                        child: const Center(
                          child: Text(
                            'المذكر',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(14, 4, 14, 20),
                      itemCount: genderPairs.length,
                      itemBuilder: (_, i) {
                        final p = genderPairs[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _genderCard(
                                word: p.feminine,
                                emoji: p.emojiF,
                                color: colors[1],
                              ),
                              const SizedBox(width: 28),
                              _genderCard(
                                word: p.masculine,
                                emoji: p.emojiM,
                                color: colors[0],
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
