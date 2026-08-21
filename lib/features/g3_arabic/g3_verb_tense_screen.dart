import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/audio/voice_service.dart';
import '../../core/storage/progress_v8.dart';
import '../../data/grammar_data.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

class G3VerbTenseScreen extends StatefulWidget {
  const G3VerbTenseScreen({super.key});
  @override
  State<G3VerbTenseScreen> createState() => _G3VerbTenseScreenState();
}

class _G3VerbTenseScreenState extends State<G3VerbTenseScreen> {
  bool learnMode = true;
  final rnd = Random();
  late VerbTense target;
  late int correctIndex; // 0=ماضٍ 1=مضارع 2=مستقبل
  late String shownForm;
  int score = 0;
  String? cheer;

  static const labels = ['ماضٍ', 'مضارع', 'مستقبل'];
  static const colors = [Color(0xFFFF6B35), Color(0xFF2979FF), Color(0xFF00C853)];

  @override
  void initState() {
    super.initState();
    _nextQuiz();
  }

  void _nextQuiz() {
    target = verbTenses[rnd.nextInt(verbTenses.length)];
    correctIndex = rnd.nextInt(3);
    shownForm = [target.past, target.present, target.future][correctIndex];
  }

  void _answer(int chosen) {
    if (chosen == correctIndex) {
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
        appBar: AppBar(title: const Text('أزمنة الفعل')),
        body: Stack(children: [
          Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
              child: Row(children: [
                Expanded(
                  child: Button3D(
                    onTap: () => setState(() => learnMode = true),
                    color: learnMode ? const Color(0xFF7C4DFF) : const Color(0xFFB39DDB),
                    depth: learnMode ? 2 : 7,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: const Center(child: Text('تعلّم', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white))),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Button3D(
                    onTap: () => setState(() => learnMode = false),
                    color: !learnMode ? const Color(0xFF00C853) : const Color(0xFFA5D6A7),
                    depth: !learnMode ? 2 : 7,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: const Center(child: Text('تدرّب', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white))),
                  ),
                ),
              ]),
            ),
            if (learnMode) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('الماضي: حدث وانتهى. المضارع: يحدث الآن. المستقبل: سيحدث لاحقًا.', textAlign: TextAlign.center),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(14),
                  itemCount: verbTenses.length,
                  itemBuilder: (_, i) {
                    final v = verbTenses[i];
                    final forms = [v.past, v.present, v.future];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(children: [
                        Text(v.emoji, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 6),
                        ...List.generate(3, (j) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3),
                              child: Button3D(
                                onTap: () => VoiceService.arabic(forms[j]),
                                color: colors[j],
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Column(children: [
                                  Text(forms[j], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white)),
                                  Text(labels[j], style: const TextStyle(fontSize: 10, color: Colors.white70)),
                                ]),
                              ),
                            ),
                          );
                        }),
                      ]),
                    );
                  },
                ),
              ),
            ] else
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    Text('هل هذا الفعل ماضٍ أم مضارع أم مستقبل؟', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 10),
                    Text('${target.emoji}  $shownForm', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 24),
                    Row(children: List.generate(3, (i) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Button3D(
                            onTap: () => _answer(i),
                            color: colors[i],
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            child: Center(child: Text(labels[i], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white))),
                          ),
                        ),
                      );
                    })),
                  ]),
                ),
              ),
          ]),
          CelebrationOverlay(message: cheer),
        ]),
      ),
    );
  }
}
