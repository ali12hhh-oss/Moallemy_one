import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../data/short_words.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

/// شاشة قراءة فقرة قصيرة مع أسئلة فهم — تدرّب الطفل على القراءة المتصلة
/// وفهم المعنى، وليس فقط التهجئة.
class G3ReadingPassageScreen extends StatefulWidget {
  const G3ReadingPassageScreen({super.key});
  @override
  State<G3ReadingPassageScreen> createState() => _G3ReadingPassageScreenState();
}

class _G3ReadingPassageScreenState extends State<G3ReadingPassageScreen> {
  int passageIndex = 0;
  int questionIndex = 0;
  bool showQuestions = false;
  String? cheer;

  void _startQuestions() => setState(() {
        showQuestions = true;
        questionIndex = 0;
      });

  void _answer(int chosen) {
    final q = readingPassages[passageIndex].questions[questionIndex];
    if (chosen == q.correctIndex) {
      setState(() => cheer = kCheers[questionIndex % kCheers.length]);
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() {
          cheer = null;
          if (questionIndex + 1 <
              readingPassages[passageIndex].questions.length) {
            questionIndex++;
          } else {
            showQuestions = false;
            passageIndex = (passageIndex + 1) % readingPassages.length;
          }
        });
      });
    } else {
      setState(() => cheer = 'حاول مرة أخرى 💪');
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) setState(() => cheer = null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final passage = readingPassages[passageIndex];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(passage.title)),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: !showQuestions
                  ? Column(
                      children: [
                        Text(
                          passage.emoji,
                          style: const TextStyle(fontSize: 50),
                        ),
                        const SizedBox(height: 10),
                        IconButton(
                          icon: const Icon(Icons.volume_up_rounded),
                          iconSize: 34,
                          onPressed: () => VoiceService.arabic(passage.text),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              passage.text,
                              style: const TextStyle(
                                fontSize: 19,
                                height: 1.9,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                        FilledButton.icon(
                          onPressed: _startQuestions,
                          icon: const Icon(Icons.quiz_rounded),
                          label: const Text('أسئلة الفهم'),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton(
                          onPressed: () => setState(
                            () => passageIndex =
                                (passageIndex + 1) % readingPassages.length,
                          ),
                          child: const Text('الفقرة التالية'),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        LinearProgressIndicator(
                          value: (questionIndex + 1) / passage.questions.length,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          passage.questions[questionIndex].question,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView(
                            children: passage.questions[questionIndex].options
                                .asMap()
                                .entries
                                .map((e) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 12,
                                ),
                                child: Button3D(
                                  onTap: () => _answer(e.key),
                                  color: const Color(0xFF7C4DFF),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 16,
                                  ),
                                  child: Text(
                                    e.value,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
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
