import 'dart:math';

import 'package:flutter/material.dart';

import '../../data/content.dart';
import '../../core/localization/arabic_numbers.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  @override
  State<QuizScreen> createState() => _S();
}

class _S extends State<QuizScreen> {
  final r = Random();
  int q = 1, score = 0;
  late ArabicLetter target;
  late List<ArabicLetter> opts;

  @override
  void initState() {
    super.initState();
    next();
  }

  void next() {
    target = arabicLetters[r.nextInt(arabicLetters.length)];
    final s = <ArabicLetter>{target};
    while (s.length < 3) {
      s.add(arabicLetters[r.nextInt(arabicLetters.length)]);
    }
    opts = s.toList()..shuffle();
  }

  void answer(ArabicLetter x) {
    if (x.letter == target.letter) score++;
    if (q == 10) {
      showDialog<void>(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('نتيجة الاختبار 🎉'),
              content: Text('النتيجة: ${arNum(score)} من ${arNum(10)}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      q = 1;
                      score = 0;
                      next();
                    });
                  },
                  child: const Text('إعادة الاختبار'),
                ),
              ],
            ),
      );
    } else {
      setState(() {
        q++;
        next();
      });
    }
  }

  @override
  Widget build(BuildContext c) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الاختبارات')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'السؤال ${arNum(q)} من ${arNum(10)}',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 24),
              Text(target.emoji, style: const TextStyle(fontSize: 70)),
              Text(
                'اختر الحرف الصحيح لكلمة ${target.word}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 23),
              ),
              const SizedBox(height: 24),
              ...opts.map(
                (x) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => answer(x),
                      child: Text(
                        x.letter,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
