import 'package:flutter/material.dart';

import '../../core/arabic/arabic_practice_engine_v16.dart';

class ArabicPracticeV16 extends StatefulWidget {
  final String skillId;
  final String title;
  const ArabicPracticeV16({
    super.key,
    required this.skillId,
    required this.title,
  });
  @override
  State<ArabicPracticeV16> createState() => _ArabicPracticeV16State();
}

class _ArabicPracticeV16State extends State<ArabicPracticeV16> {
  ArabicQuestionV16? q;
  bool locked = false;
  String? selected;
  int correct = 0;
  int total = 0;

  @override
  void initState() {
    super.initState();
    _newQuestion();
  }

  ArabicQuestionV16 _generate() {
    final id = widget.skillId;
    if (id == 'harakat') return ArabicPracticeEngineV16.harakat(id);
    if (id == 'sukun') return ArabicPracticeEngineV16.sukun(id);
    if (id == 'shadda') return ArabicPracticeEngineV16.shadda(id);
    if (id == 'tanween') return ArabicPracticeEngineV16.tanween(id);
    if (id == 'long_vowels') return ArabicPracticeEngineV16.longVowels(id);
    if (id == 'syllables' || id == 'word_building') {
      return ArabicPracticeEngineV16.syllables(id);
    }
    if (id == 'sun_moon_lam') return ArabicPracticeEngineV16.sunMoon(id);
    if (id == 'prepositions') return ArabicPracticeEngineV16.preposition(id);
    if (id == 'al_definition') return ArabicPracticeEngineV16.alDefinition(id);
    if (id == 'singular_plural')
      return ArabicPracticeEngineV16.singularPlural(id);
    if (id == 'masculine_feminine')
      return ArabicPracticeEngineV16.masculineFeminine(id);
    if (id == 'sentence_building')
      return ArabicPracticeEngineV16.sentenceBuilding(id);
    if (id == 'spelling') return ArabicPracticeEngineV16.spelling(id);
    if (id == 'word_analysis') return ArabicPracticeEngineV16.wordAnalysis(id);
    return ArabicPracticeEngineV16.sentenceType(id);
  }

  void _newQuestion() {
    setState(() {
      q = _generate();
      locked = false;
      selected = null;
    });
  }

  Future<void> _answer(String value) async {
    if (locked || q == null) return;
    final ok = value == q!.answer;
    await ArabicPracticeEngineV16.record(skillId: widget.skillId, correct: ok);
    if (!mounted) return;
    setState(() {
      selected = value;
      total++;
      if (ok) {
        correct++;
        locked = true;
      }
    });
    if (ok) {
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) _newQuestion();
      });
    } else {
      // الخطأ يعيد المحاولة على السؤال نفسه ولا يسمح بتجاوز المهارة.
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => selected = null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = q;
    if (question == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      question.prompt,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ...question.options.map(
                      (option) => Padding(
                        padding: const EdgeInsets.only(bottom: 9),
                        child: SizedBox(
                          width: double.infinity,
                          child: FilledButton.tonal(
                            onPressed: locked ? null : () => _answer(option),
                            child: Text(
                              option,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 21),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (selected != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        selected == question.answer
                            ? 'أحسنت! ⭐ انتقلنا للسؤال التالي'
                            : 'ليست هذه الإجابة 💪 حاول مرة أخرى، ولن ننتقل حتى تنجح',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: selected == question.answer
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(question.explanation, textAlign: TextAlign.center),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(child: Text('نتيجة التدريب: $correct / $total')),
          ],
        ),
      ),
    );
  }
}
