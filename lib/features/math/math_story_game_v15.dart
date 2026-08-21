
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/math/math_practice_engine_v15.dart';

class MathStoryGameV15 extends StatefulWidget {
  final int grade;
  const MathStoryGameV15({super.key, required this.grade});
  @override State<MathStoryGameV15> createState() => _MathStoryGameV15State();
}

class _MathStoryGameV15State extends State<MathStoryGameV15> {
  final _random = Random();
  int a = 2, b = 3;
  String action = 'أضاف';
  int score = 0;
  int total = 0;
  bool locked = false;
  int? selected;

  @override
  void initState() {
    super.initState();
    _new();
  }

  void _new() {
    setState(() {
      a = _random.nextInt(widget.grade == 1 ? 5 : 12) + 1;
      b = _random.nextInt(widget.grade == 1 ? 5 : 12) + 1;
      action = _random.nextBool() ? 'أضاف' : 'أخذ';
      if (action == 'أخذ' && b > a) {
        final t = a;
        a = b;
        b = t;
      }
      locked = false;
      selected = null;
    });
  }

  int get answer => action == 'أضاف' ? a + b : a - b;

  List<int> options() {
    final set = <int>{answer};
    while (set.length < 4) {
      set.add(max(0, answer + _random.nextInt(7) - 3));
    }
    return set.toList()..shuffle(_random);
  }

  String ar(int n) => MathPracticeEngineV15.ar(n);

  Future<void> _answer(int n) async {
    if (locked) return;
    final ok = n == answer;
    await MathPracticeEngineV15.recordAnswer(
      skillId: 'word_problems_g${widget.grade}',
      correct: ok,
    );
    if (!mounted) return;
    setState(() {
      locked = true;
      selected = n;
      total++;
      if (ok) score++;
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) _new();
    });
  }

  @override
  Widget build(BuildContext context) {
    final icon = action == 'أضاف' ? '🍎' : '🍪';
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('لعبة المسألة المصورة')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      '$icon  $icon  $icon',
                      style: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      action == 'أضاف'
                          ? 'لدى الطفل ${ar(a)} تفاحات، ثم أضاف ${ar(b)} تفاحات. كم أصبح لديه؟'
                          : 'لدى الطفل ${ar(a)} قطع، ثم أخذ ${ar(b)} قطع. كم بقي لديه؟',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22, height: 1.5),
                    ),
                    const SizedBox(height: 18),
                    ...options().map(
                      (n) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: SizedBox(
                          width: double.infinity,
                          child: FilledButton.tonal(
                            onPressed: locked ? null : () => _answer(n),
                            child: Text(ar(n), style: const TextStyle(fontSize: 22)),
                          ),
                        ),
                      ),
                    ),
                    if (locked)
                      Text(
                        selected == answer
                            ? 'أحسنت! ⭐'
                            : 'الإجابة الصحيحة ${ar(answer)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Center(child: Text('النقاط: ${ar(score)} / ${ar(total)}')),
          ],
        ),
      ),
    );
  }
}
