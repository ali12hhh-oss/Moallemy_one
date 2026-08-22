import 'dart:math' as math;

import '../storage/child_progress_repository.dart';
import '../adaptive/adaptive_learning_engine_v24.dart';

class MathQuestionV15 {
  final String skillId;
  final String prompt;
  final int answer;
  final List<int> options;
  final String explanation;
  final List<String>? optionLabels;

  const MathQuestionV15({
    required this.skillId,
    required this.prompt,
    required this.answer,
    required this.options,
    required this.explanation,
    this.optionLabels,
  });
}

class MathPracticeEngineV15 {
  static final math.Random _random = math.Random();

  static int mathMax(int a, int b) => math.max(a, b);
  static int mathMin(int a, int b) => math.min(a, b);

  static String ar(int n) =>
      n.toString().split('').map((d) => '٠١٢٣٤٥٦٧٨٩'[int.parse(d)]).join();

  static String _operationPrompt(int a, int b, String op) {
    if (!_random.nextBool()) return '${ar(a)} $op ${ar(b)} = ؟';
    return '${ar(a)}\n$op ${ar(b)}\n──────\n؟';
  }

  /// Always returns exactly four distinct non-negative options.
  static List<int> _options(int answer, {int spread = 4}) {
    final values = <int>{answer};
    final safeSpread = math.max(1, spread.abs());
    for (var d = 1; values.length < 4 && d <= safeSpread * 4 + 10; d++) {
      final candidates = [answer - d, answer + d];
      for (final candidate in candidates) {
        if (candidate >= 0) values.add(candidate);
        if (values.length == 4) break;
      }
    }
    var next = answer + safeSpread + 1;
    while (values.length < 4) values.add(next++);
    final result = values.toList()..shuffle(_random);
    return result;
  }

  static MathQuestionV15 addition({required String skillId, required int max}) {
    final limit = math.max(0, max);
    var a = _random.nextInt(limit + 1);
    var b = _random.nextInt(limit + 1);
    while (a + b > limit) {
      a = _random.nextInt(limit + 1);
      b = _random.nextInt(limit + 1);
    }
    final answer = a + b;
    return MathQuestionV15(
        skillId: skillId,
        prompt: _operationPrompt(a, b, '+'),
        answer: answer,
        options: _options(answer),
        explanation: '${ar(a)} + ${ar(b)} = ${ar(answer)}');
  }

  static MathQuestionV15 subtraction(
      {required String skillId, required int max}) {
    final limit = math.max(0, max);
    final a = _random.nextInt(limit + 1);
    final b = _random.nextInt(a + 1);
    final answer = a - b;
    return MathQuestionV15(
        skillId: skillId,
        prompt: _operationPrompt(a, b, '−'),
        answer: answer,
        options: _options(answer),
        explanation: '${ar(a)} − ${ar(b)} = ${ar(answer)}');
  }

  static MathQuestionV15 comparison(
      {required String skillId, required int max}) {
    final limit = math.max(0, max);
    final a = _random.nextInt(limit + 1);
    final b = _random.nextInt(limit + 1);
    final answer = a > b ? 1 : (a < b ? -1 : 0);
    const options = [1, 0, -1];
    const labels = ['>', '=', '<'];
    return MathQuestionV15(
      skillId: skillId,
      prompt: '${ar(a)}  ؟  ${ar(b)}',
      answer: answer,
      options: options,
      optionLabels: labels,
      explanation:
          '${ar(a)} ${answer == 1 ? 'أكبر من' : answer == -1 ? 'أصغر من' : 'يساوي'} ${ar(b)}',
    );
  }

  static MathQuestionV15 missingNumber(
      {required String skillId, required int max}) {
    final limit = math.max(0, max);
    final a = _random.nextInt(limit + 1);
    final b = _random.nextInt(math.min(20, limit) + 1);
    final answer = a + b;
    return MathQuestionV15(
        skillId: skillId,
        prompt: '${ar(a)} + ؟ = ${ar(answer)}',
        answer: b,
        options: _options(b, spread: 3),
        explanation: '${ar(a)} + ${ar(b)} = ${ar(answer)}');
  }

  static MathQuestionV15 placeValue(
      {required String skillId, required int max}) {
    final value = max >= 1000
        ? _random.nextInt(9000) + 1000
        : math.max(10, _random.nextInt(math.max(1, max - 9)) + 10);
    final digits = value.toString().split('');
    final placeIndex = _random.nextInt(digits.length);
    final digit = int.parse(digits[placeIndex]);
    final place = digits.length - placeIndex - 1;
    final answer = digit * math.pow(10, place).toInt();
    final placeName = switch (place) {
      0 => 'الآحاد',
      1 => 'العشرات',
      2 => 'المئات',
      3 => 'الآلاف',
      _ => 'القيمة المكانية',
    };
    return MathQuestionV15(
        skillId: skillId,
        prompt: 'ما قيمة الرقم ${ar(digit)} في العدد ${ar(value)}؟',
        answer: answer,
        options: _options(answer, spread: math.max(10, answer ~/ 2 + 1)),
        explanation:
            'الرقم ${ar(digit)} في منزلة $placeName، وقيمته ${ar(answer)}');
  }

  static MathQuestionV15 pattern({required String skillId, required int max}) {
    final limit = math.max(4, max);
    final step = _random.nextInt(math.min(9, math.max(1, limit ~/ 4))) + 1;
    final maxStart = math.max(0, limit - step * 3);
    final start = _random.nextInt(maxStart + 1);
    final answer = start + step * 3;
    return MathQuestionV15(
        skillId: skillId,
        prompt:
            '${ar(start)} ، ${ar(start + step)} ، ${ar(start + step * 2)} ، ؟',
        answer: answer,
        options: _options(answer, spread: step + 2),
        explanation: 'النمط يزيد بمقدار ${ar(step)} كل مرة.');
  }

  static bool _sameList(List<int> a, List<int> b) =>
      a.length == b.length &&
      List.generate(a.length, (i) => a[i] == b[i]).every((x) => x);

  static MathQuestionV15 ordering(
      {required String skillId, required int max, required bool ascending}) {
    final upper = math.max(4, math.min(math.max(4, max), 999999));
    final values = <int>{};
    while (values.length < 4) values.add(_random.nextInt(upper) + 1);
    final sortedAsc = values.toList()..sort();
    final sorted = ascending ? sortedAsc : sortedAsc.reversed.toList();
    final correctText = sorted.map(ar).join(' ، ');
    final candidates = <List<int>>[];
    void addCandidate(List<int> value) {
      if (!candidates.any((x) => _sameList(x, value))) candidates.add(value);
    }

    addCandidate(sorted);
    for (var i = 0; candidates.length < 4 && i < 4; i++) {
      final rotated = [...sorted]..insert(0, sorted[(i + 1) % 4]);
      rotated.removeAt(1);
      addCandidate(rotated);
    }
    for (var i = 0; candidates.length < 4 && i < 24; i++) {
      final candidate = [...sorted]..shuffle(_random);
      addCandidate(candidate);
    }
    final correctIndex = candidates.indexWhere((x) => _sameList(x, sorted));
    return MathQuestionV15(
        skillId: skillId,
        prompt:
            'رتّب الأعداد ${values.map(ar).join(' ، ')} ${ascending ? 'تصاعدياً' : 'تنازلياً'}',
        answer: correctIndex,
        options: List<int>.generate(4, (i) => i),
        optionLabels: candidates.map((x) => x.map(ar).join(' ، ')).toList(),
        explanation: 'الترتيب الصحيح: $correctText');
  }

  static MathQuestionV15 multiplication(
      {required String skillId, required int table}) {
    final b = _random.nextInt(10) + 1;
    final answer = table * b;
    return MathQuestionV15(
        skillId: skillId,
        prompt: '${ar(table)} × ${ar(b)} = ؟',
        answer: answer,
        options: _options(answer, spread: 4),
        explanation: '${ar(table)} × ${ar(b)} = ${ar(answer)}');
  }

  static Future<void> recordAnswer(
      {required String skillId, required bool correct}) async {
    await ChildProgressRepository.recordSkill(skillId, correct);
    await AdaptiveLearningEngineV24.record(skillId, correct);
  }

  static Future<int> mastery(String skillId) =>
      ChildProgressRepository.skillMastery(skillId);

  static Future<void> addRewards({required int stars, required int xp}) =>
      ChildProgressRepository.addRewards(stars: stars, xp: xp);

  static Future<int> stars() => ChildProgressRepository.stars();
  static Future<int> xp() => ChildProgressRepository.xp();
}
