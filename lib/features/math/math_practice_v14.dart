import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/math/math_skills_engine_v14.dart';
import '../../data/math_curriculum_v14.dart';

class MathPracticeV14 extends StatefulWidget {
  final MathSkillV14 skill;
  const MathPracticeV14({super.key, required this.skill});
  @override
  State<MathPracticeV14> createState() => _MathPracticeV14State();
}

class _MathPracticeV14State extends State<MathPracticeV14> {
  final r = Random();
  int a = 1, b = 1, correct = 0, total = 0;
  String op = '+';
  bool answered = false;
  int? chosen;

  @override
  void initState() {
    super.initState();
    _newQuestion();
  }

  void _newQuestion() {
    final maxN = widget.skill.maxNumber.clamp(10, 1000);
    if (widget.skill.category == 'الجمع') {
      a = r.nextInt(maxN ~/ 2) + 1;
      b = r.nextInt(maxN ~/ 2) + 1;
      op = '+';
    } else if (widget.skill.category == 'الطرح') {
      a = r.nextInt(maxN ~/ 2) + 2;
      b = r.nextInt(a - 1) + 1;
      op = '−';
    } else if (widget.skill.category == 'القيمة المكانية') {
      a = [10, 100, 1000, 1000000][r.nextInt(4)];
      b = r.nextInt(9) + 1;
      op = '?';
    } else {
      a = r.nextInt(10) + 1;
      b = r.nextInt(10) + 1;
      op = '?';
    }
    setState(() => answered = false);
  }

  int get answer {
    if (op == '+') return a + b;
    if (op == '−') return a - b;
    if (widget.skill.category == 'القيمة المكانية') {
      final zeros = (a.toString().length - 1);
      return zeros;
    }
    return a + b;
  }

  List<int> options() {
    final set = <int>{answer};
    while (set.length < 4) {
      final d = r.nextInt(9) - 4;
      set.add(max(0, answer + d));
    }
    final l = set.toList()..shuffle(r);
    return l;
  }

  String ar(int n) =>
      n.toString().split('').map((d) => '٠١٢٣٤٥٦٧٨٩'[int.parse(d)]).join();

  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: Text(widget.skill.title)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        widget.skill.category,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _questionText(),
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 18),
                      ...options().map(
                        (n) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: SizedBox(
                            width: double.infinity,
                            child: FilledButton.tonal(
                              onPressed: answered ? null : () => _answer(n),
                              child: Text(
                                ar(n),
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (answered)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            chosen == answer
                                ? 'أحسنت! ⭐'
                                : 'حاول مرة أخرى — الإجابة ${ar(answer)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      Text('نتيجة التدريب: ${ar(correct)} / ${ar(total)}'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  String _questionText() {
    if (widget.skill.category == 'القيمة المكانية') {
      return 'ما عدد الأصفار في ${ar(a)}؟';
    }
    if (widget.skill.category == 'الأنماط') {
      return '${ar(a)} ، ${ar(a + b)} ، ${ar(a + 2 * b)} ، ؟';
    }
    return '${ar(a)} $op ${ar(b)} = ؟';
  }

  Future<void> _answer(int n) async {
    final ok = n == answer;
    await MathSkillsEngineV14.record(widget.skill.id, correct: ok);
    if (!mounted) return;
    setState(() {
      chosen = n;
      answered = true;
      total++;
      if (ok) {
        correct++;
      }
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) _newQuestion();
    });
  }
}
