import 'package:flutter/material.dart';

import '../../core/math/math_practice_engine_v15.dart';

class MathPracticeV15 extends StatefulWidget {
  final String skillId;
  final String title;
  final String category;
  final int maxNumber;
  final int? table;

  const MathPracticeV15({
    super.key,
    required this.skillId,
    required this.title,
    required this.category,
    required this.maxNumber,
    this.table,
  });

  @override
  State<MathPracticeV15> createState() => _MathPracticeV15State();
}

class _MathPracticeV15State extends State<MathPracticeV15> {
  MathQuestionV15? question;
  int correct = 0;
  int total = 0;
  bool locked = false;
  int? selected;

  @override
  void initState() {
    super.initState();
    _newQuestion();
  }

  MathQuestionV15 _generate() {
    switch (widget.category) {
      case 'الجمع':
        return MathPracticeEngineV15.addition(
          skillId: widget.skillId,
          max: widget.maxNumber,
        );
      case 'الطرح':
        return MathPracticeEngineV15.subtraction(
          skillId: widget.skillId,
          max: widget.maxNumber,
        );
      case 'المقارنة':
        return MathPracticeEngineV15.comparison(
          skillId: widget.skillId,
          max: widget.maxNumber,
        );
      case 'العدد الناقص':
        return MathPracticeEngineV15.missingNumber(
          skillId: widget.skillId,
          max: widget.maxNumber,
        );
      case 'القيمة المكانية':
        return MathPracticeEngineV15.placeValue(
          skillId: widget.skillId,
          max: widget.maxNumber,
        );
      case 'الأنماط':
        return MathPracticeEngineV15.pattern(
          skillId: widget.skillId,
          max: widget.maxNumber,
        );
      case 'الترتيب':
        return MathPracticeEngineV15.ordering(
          skillId: widget.skillId,
          max: widget.maxNumber,
          ascending: widget.skillId.startsWith('ascending'),
        );
      case 'الضرب':
        return MathPracticeEngineV15.multiplication(
          skillId: widget.skillId,
          table: widget.table ?? 1,
        );
      default:
        return MathPracticeEngineV15.addition(
          skillId: widget.skillId,
          max: widget.maxNumber,
        );
    }
  }

  void _newQuestion() {
    setState(() {
      question = _generate();
      selected = null;
      locked = false;
    });
  }

  Future<void> _answer(int value) async {
    if (locked || question == null) return;
    final ok = value == question!.answer;
    await MathPracticeEngineV15.recordAnswer(
      skillId: widget.skillId,
      correct: ok,
    );
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
      Future.delayed(const Duration(milliseconds: 850), () {
        if (mounted) _newQuestion();
      });
    } else {
      // لا ننتقل للسؤال التالي عند الخطأ؛ يبقى السؤال نفسه حتى ينجح الطفل.
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => selected = null);
      });
    }
  }

  String _ar(int n) => MathPracticeEngineV15.ar(n);

  @override
  Widget build(BuildContext context) {
    final q = question;
    if (q == null) {
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
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Text(
                      q.prompt,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ...q.options.map(
                      (value) => Padding(
                        padding: const EdgeInsets.only(bottom: 9),
                        child: SizedBox(
                          width: double.infinity,
                          child: FilledButton.tonal(
                            onPressed: locked ? null : () => _answer(value),
                            child: Text(
                              widget.category == 'المقارنة'
                                  ? ({
                                          1: 'أكبر',
                                          0: 'يساوي',
                                          -1: 'أصغر',
                                        }[value] ??
                                        _ar(value))
                                  : widget.category == 'الترتيب'
                                  ? (q.optionLabels?[value] ?? 'ترتيب آخر')
                                  : _ar(value),
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (selected != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        selected == q.answer
                            ? 'أحسنت! ⭐ انتقلنا للسؤال التالي'
                            : 'ليست هذه الإجابة 💪 حاول مرة أخرى، ولن ننتقل حتى تنجح',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: selected == q.answer
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(q.explanation, textAlign: TextAlign.center),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'نتيجة الجلسة: ${_ar(correct)} / ${_ar(total)}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
