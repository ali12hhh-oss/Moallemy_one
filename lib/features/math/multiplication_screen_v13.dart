import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/math/multiplication_engine_v13.dart';
import '../../data/multiplication_curriculum_v13.dart';

class MultiplicationScreenV13 extends StatefulWidget {
  const MultiplicationScreenV13({super.key});
  @override
  State<MultiplicationScreenV13> createState() =>
      _MultiplicationScreenV13State();
}

class _MultiplicationScreenV13State extends State<MultiplicationScreenV13> {
  int _grade = 1;
  int? _selectedTable;
  int _a = 1, _b = 1;
  final _random = Random();
  int? _answer;
  bool _showResult = false;
  bool _started = false;
  int _sessionCorrect = 0;
  int _sessionTotal = 0;

  List<MultiplicationTableV13> get _tables => tablesForGradeV13(_grade);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('جدول الضرب')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'اختر الصف',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final g in [1, 2, 3])
                          ChoiceChip(
                            label: Text('الصف ${_arabic(g)}'),
                            selected: _grade == g,
                            onSelected: (_) => setState(() {
                              _grade = g;
                              _selectedTable = null;
                              _started = false;
                              _showResult = false;
                            }),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _grade == 1
                          ? 'للصف الأول: جدول ١ و٢ اختياري ويمكن التخطي دون التأثير على نجاح المرحلة.'
                          : _grade == 2
                          ? 'للصف الثاني: من جدول ١ إلى جدول ٥ ضمن مسار الرياضيات.'
                          : 'للصف الثالث: من جدول ١ إلى جدول ١٠ مع مراجعة متدرجة.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'الجداول',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._tables.map(_tableCard),
            if (_selectedTable != null) ...[
              const SizedBox(height: 14),
              _practiceCard(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tableCard(MultiplicationTableV13 item) {
    return FutureBuilder<int>(
      future: MultiplicationEngineV13.mastery(item.table),
      builder: (context, snap) {
        final mastery = snap.data ?? 0;
        return Card(
          child: ListTile(
            leading: CircleAvatar(child: Text(_arabic(item.table))),
            title: Text('جدول ${_arabic(item.table)}'),
            subtitle: Text(
              item.optional
                  ? 'اختياري للصف الأول • الإتقان ${_arabic(mastery)}٪'
                  : 'إتقان ${_arabic(mastery)}٪',
            ),
            trailing: const Icon(Icons.arrow_back_ios_new_rounded),
            onTap: () => setState(() {
              _selectedTable = item.table;
              _newQuestion();
            }),
          ),
        );
      },
    );
  }

  Widget _practiceCard() {
    final table = _selectedTable!;
    final answer = _a * _b;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'تدريب جدول ${_arabic(table)}',
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '$_arabicText${_arabic(_a)} × ${_arabic(_b)} = ؟',
              style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            if (!_started)
              FilledButton.icon(
                onPressed: () => setState(() {
                  _started = true;
                  _newQuestion();
                }),
                icon: const Icon(Icons.play_arrow),
                label: const Text('ابدأ التدريب'),
              )
            else ...[
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final n in _options(answer))
                    SizedBox(
                      width: 90,
                      child: FilledButton.tonal(
                        onPressed: _showResult
                            ? null
                            : () => _submit(n, answer),
                        child: Text(
                          _arabic(n),
                          style: const TextStyle(fontSize: 23),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              if (_showResult)
                Text(
                  _answer == answer
                      ? 'أحسنت! ⭐ انتقل للسؤال التالي'
                      : 'حاول مرة أخرى 💪 — السؤال نفسه حتى تنجح',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _answer == answer ? Colors.green : Colors.red,
                  ),
                ),
              const SizedBox(height: 10),
              Text(
                'نتيجة الجلسة: ${_arabic(_sessionCorrect)} / ${_arabic(_sessionTotal)}',
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _newQuestion() {
    final table = _selectedTable!;
    setState(() {
      _a = table;
      _b = _random.nextInt(10) + 1;
      _answer = null;
      _showResult = false;
    });
  }

  Future<void> _submit(int value, int correct) async {
    final ok = value == correct;
    await MultiplicationEngineV13.record(
      table: _selectedTable!,
      multiplier: _b,
      correct: ok,
    );
    if (!mounted) return;
    setState(() {
      _answer = value;
      _showResult = ok;
      _sessionTotal++;
      if (ok) _sessionCorrect++;
    });
    if (ok) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted && _selectedTable != null) _newQuestion();
      });
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted)
          setState(() {
            _answer = null;
            _showResult = false;
          });
      });
    }
  }

  List<int> _options(int correct) {
    final set = <int>{correct};
    while (set.length < 4) {
      final delta = _random.nextInt(7) - 3;
      final candidate = max(1, correct + delta);
      set.add(candidate);
    }
    final list = set.toList()..shuffle(_random);
    return list;
  }

  String _arabic(int n) =>
      n.toString().split('').map((d) => '٠١٢٣٤٥٦٧٨٩'[int.parse(d)]).join();
  String get _arabicText => '';
}
