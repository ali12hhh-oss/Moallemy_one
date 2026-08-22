import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/adaptive/adaptive_learning_engine_v24.dart';
import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../core/storage/progress_v8.dart';
import '../../data/content.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

/// نموذج سؤال موحّد يغطي كل فئات الاختبار: عرض بصري + ٤ خيارات نصية.
class _ExamQ {
  final String category;
  final String skillKey;
  final Widget visual;
  final List<String> options;
  final int correct;
  final VoidCallback? speak;
  _ExamQ({
    required this.category,
    required this.skillKey,
    required this.visual,
    required this.options,
    required this.correct,
    this.speak,
  });
}

const _examColors = <(String, Color)>[
  ('أحمر', Color(0xFFE53935)),
  ('أزرق', Color(0xFF1E88E5)),
  ('أصفر', Color(0xFFFDD835)),
  ('أخضر', Color(0xFF43A047)),
  ('برتقالي', Color(0xFFFB8C00)),
  ('بنفسجي', Color(0xFF8E24AA)),
  ('أبيض', Color(0xFFECEFF1)),
  ('أسود', Color(0xFF212121)),
];

enum _ShapeKind { square, triangle, circle, rectangle, trapezoid, oblique }

const _examShapes = <(String, _ShapeKind)>[
  ('مربع', _ShapeKind.square),
  ('مثلث', _ShapeKind.triangle),
  ('دائرة', _ShapeKind.circle),
  ('مستطيل', _ShapeKind.rectangle),
  ('منحرف', _ShapeKind.oblique),
  ('شبه منحرف', _ShapeKind.trapezoid),
];

const _examPairs = <(String, String)>[
  ('د', 'ا'),
  ('ن', 'ا'),
  ('ب', 'ا'),
  ('م', 'ا'),
  ('س', 'ا'),
  ('ل', 'ا'),
  ('ف', 'ي'),
  ('ه', 'ي'),
];

const _numberWords = <int, String>{
  1: 'واحد',
  2: 'اثنان',
  3: 'ثلاثة',
  4: 'أربعة',
  5: 'خمسة',
  6: 'ستة',
  7: 'سبعة',
  8: 'ثمانية',
  9: 'تسعة',
  10: 'عشرة',
};

const _icons = ['🍎', '⭐', '🎈', '🐝', '🌸', '🍓'];
const _tensList = [10, 20, 30, 40, 50];

List<_ExamQ> _buildBank(Random rnd) {
  final bank = <_ExamQ>[];

  // ١) الحروف: استمع للحرف واختر شكله الصحيح.
  for (var k = 0; k < 2; k++) {
    final target = arabicLetters[rnd.nextInt(arabicLetters.length)];
    final others = [...arabicLetters]..shuffle(rnd);
    others.removeWhere((l) => l.letter == target.letter);
    final opts = [target.letter, ...others.take(3).map((l) => l.letter)]
      ..shuffle(rnd);
    bank.add(
      _ExamQ(
        category: 'الحروف',
        skillKey: 'exam.letters',
        visual: const Icon(Icons.hearing_rounded, size: 60),
        options: opts,
        correct: opts.indexOf(target.letter),
        speak: () => VoiceService.arabicLetterSound(
          target.letter,
          fallbackText: target.sound,
        ),
      ),
    );
  }

  // ٢) الأرقام: استمع للعدد (١-١٠) واختر رقمه الصحيح.
  for (var k = 0; k < 2; k++) {
    final n = 1 + rnd.nextInt(10);
    final others = List.generate(10, (i) => i + 1).where((x) => x != n).toList()
      ..shuffle(rnd);
    final opts = [n, ...others.take(3)]..shuffle(rnd);
    bank.add(
      _ExamQ(
        category: 'الأرقام',
        skillKey: 'exam.numbers',
        visual: const Icon(Icons.hearing_rounded, size: 60),
        options: opts.map(arNum).toList(),
        correct: opts.indexOf(n),
        speak: () => VoiceService.arabic(_numberWords[n] ?? '$n'),
      ),
    );
  }

  // ٣) الألوان: شاهد اللون واختر اسمه.
  for (var k = 0; k < 2; k++) {
    final target = _examColors[rnd.nextInt(_examColors.length)];
    final others = [..._examColors]..shuffle(rnd);
    others.removeWhere((c) => c.$1 == target.$1);
    final opts = [target.$1, ...others.take(3).map((c) => c.$1)]..shuffle(rnd);
    bank.add(
      _ExamQ(
        category: 'الألوان',
        skillKey: 'exam.colors',
        visual: Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: target.$2,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black12, width: 2),
          ),
        ),
        options: opts,
        correct: opts.indexOf(target.$1),
      ),
    );
  }

  // ٤) الأشكال: شاهد الشكل واختر اسمه.
  for (var k = 0; k < 2; k++) {
    final target = _examShapes[rnd.nextInt(_examShapes.length)];
    final others = [..._examShapes]..shuffle(rnd);
    others.removeWhere((s) => s.$1 == target.$1);
    final opts = [target.$1, ...others.take(3).map((s) => s.$1)]..shuffle(rnd);
    bank.add(
      _ExamQ(
        category: 'الأشكال',
        skillKey: 'exam.shapes',
        visual: SizedBox(
          width: 90,
          height: 90,
          child: CustomPaint(painter: _ExamShapePainter(target.$2)),
        ),
        options: opts,
        correct: opts.indexOf(target.$1),
      ),
    );
  }

  // ٥) دمج الحروف: شاهد حرفين واختر ناتج دمجهما.
  for (var k = 0; k < 2; k++) {
    final target = _examPairs[rnd.nextInt(_examPairs.length)];
    final correctStr = '${target.$1}${target.$2}';
    final others =
        _examPairs
            .map((p) => '${p.$1}${p.$2}')
            .where((c) => c != correctStr)
            .toList()
          ..shuffle(rnd);
    final opts = [correctStr, ...others.take(3)]..shuffle(rnd);
    bank.add(
      _ExamQ(
        category: 'دمج الحروف',
        skillKey: 'exam.combine',
        visual: Text(
          '${target.$1} + ${target.$2}',
          style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w900),
        ),
        options: opts,
        correct: opts.indexOf(correctStr),
      ),
    );
  }

  // ٦) آحاد: عدّ الصور (١-٩) واختر العدد الصحيح.
  for (var k = 0; k < 2; k++) {
    final n = 1 + rnd.nextInt(9);
    final icon = _icons[rnd.nextInt(_icons.length)];
    final others = List.generate(9, (i) => i + 1).where((x) => x != n).toList()
      ..shuffle(rnd);
    final opts = [n, ...others.take(3)]..shuffle(rnd);
    bank.add(
      _ExamQ(
        category: 'آحاد',
        skillKey: 'exam.ones',
        visual: Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          children: List.generate(
            n,
            (_) => Text(icon, style: const TextStyle(fontSize: 26)),
          ),
        ),
        options: opts.map(arNum).toList(),
        correct: opts.indexOf(n),
      ),
    );
  }

  // ٧) عشرات: شاهد مجموعات العشرة واختر العدد الصحيح.
  for (var k = 0; k < 2; k++) {
    final n = _tensList[rnd.nextInt(_tensList.length)];
    final others = _tensList.where((x) => x != n).toList()..shuffle(rnd);
    final opts = [n, ...others.take(3)]..shuffle(rnd);
    final groups = n ~/ 10;
    bank.add(
      _ExamQ(
        category: 'عشرات',
        skillKey: 'exam.tens',
        visual: Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          runSpacing: 6,
          children: List.generate(
            groups,
            (_) => Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Wrap(
                spacing: 2,
                runSpacing: 2,
                children: List.generate(
                  10,
                  (_) => Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00C853),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        options: opts.map(arNum).toList(),
        correct: opts.indexOf(n),
      ),
    );
  }

  bank.shuffle(rnd);
  return bank;
}

class _ExamShapePainter extends CustomPainter {
  final _ShapeKind kind;
  _ExamShapePainter(this.kind);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF7C4DFF)
      ..style = PaintingStyle.fill;
    final w = size.width, h = size.height;
    final path = Path();
    switch (kind) {
      case _ShapeKind.square:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(4, 4, w - 8, h - 8),
            const Radius.circular(8),
          ),
          paint,
        );
      case _ShapeKind.rectangle:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 14, w, h - 28),
            const Radius.circular(8),
          ),
          paint,
        );
      case _ShapeKind.circle:
        canvas.drawCircle(Offset(w / 2, h / 2), w / 2 - 2, paint);
      case _ShapeKind.triangle:
        path.moveTo(w / 2, 2);
        path.lineTo(w - 4, h - 4);
        path.lineTo(4, h - 4);
        path.close();
        canvas.drawPath(path, paint);
      case _ShapeKind.trapezoid:
        path.moveTo(w * .28, 6);
        path.lineTo(w * .72, 6);
        path.lineTo(w - 4, h - 6);
        path.lineTo(4, h - 6);
        path.close();
        canvas.drawPath(path, paint);
      case _ShapeKind.oblique:
        path.moveTo(w * .32, 4);
        path.lineTo(w - 4, 4);
        path.lineTo(w * .68, h - 4);
        path.lineTo(4, h - 4);
        path.close();
        canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ExamShapePainter oldDelegate) =>
      oldDelegate.kind != kind;
}

/// شاشة الاختبار الشامل لمرحلة التمهيدي: تراجع كل ما تعلّمه الطفل في
/// الروضة الأولى والثانية (حروف، أرقام، ألوان، أشكال، دمج حروف، آحاد،
/// عشرات) في ١٤ سؤالًا، ثم تعرض النتيجة النهائية وتُرسلها لصفحة الوالدين.
class PrepExamScreen extends StatefulWidget {
  const PrepExamScreen({super.key});
  @override
  State<PrepExamScreen> createState() => _PrepExamScreenState();
}

class _PrepExamScreenState extends State<PrepExamScreen> {
  final rnd = Random();
  late List<_ExamQ> questions;
  int index = 0;
  int correctFirstTry = 0;
  bool missedThisQuestion = false;
  String? cheer;
  bool finished = false;

  @override
  void initState() {
    super.initState();
    questions = _buildBank(rnd);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => questions[0].speak?.call(),
    );
  }

  void _answer(int chosen) {
    final q = questions[index];
    if (chosen == q.correct) {
      if (!missedThisQuestion) correctFirstTry++;
      AdaptiveLearningEngineV24.record(q.skillKey, !missedThisQuestion);
      ProgressV8.addRewards(stars: 1, xp: 5);
      setState(() => cheer = kCheers[rnd.nextInt(kCheers.length)]);
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() {
          cheer = null;
          if (index + 1 < questions.length) {
            index++;
            missedThisQuestion = false;
            questions[index].speak?.call();
          } else {
            finished = true;
          }
        });
        if (finished) _finish();
      });
    } else {
      missedThisQuestion = true;
      setState(() => cheer = 'حاول مرة أخرى 💪');
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) setState(() => cheer = null);
      });
    }
  }

  Future<void> _finish() async {
    final total = questions.length;
    final passed = correctFirstTry / total >= .6;
    await ProgressV8.recordFinalExam('prep', correctFirstTry, total, passed);
  }

  @override
  Widget build(BuildContext context) {
    if (finished)
      return _ResultScreen(score: correctFirstTry, total: questions.length);
    final q = questions[index];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('اختبار التمهيدي • ${index + 1} / ${questions.length}'),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: (index + 1) / questions.length,
                  ),
                  const SizedBox(height: 16),
                  Chip(
                    label: Text(
                      q.category,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (q.speak != null) ...[
                    IconButton(
                      iconSize: 54,
                      icon: const Icon(Icons.volume_up_rounded),
                      onPressed: q.speak,
                    ),
                    const Text(
                      'استمع واختر الإجابة الصحيحة',
                      style: TextStyle(fontSize: 14),
                    ),
                  ] else
                    q.visual,
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      children: List.generate(q.options.length, (i) {
                        return Button3D(
                          onTap: () => _answer(i),
                          color: const Color(0xFF7C4DFF),
                          child: Center(
                            child: Text(
                              q.options[i],
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }),
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

class _ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  const _ResultScreen({required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    final passed = score / total >= .6;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 34),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: passed
                      ? const [Color(0xFFFFD54F), Color(0xFFFF7043)]
                      : const [Color(0xFF90CAF9), Color(0xFF64B5F6)],
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    passed ? '🏆🎉⭐' : '💪🌟',
                    style: const TextStyle(fontSize: 50),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    passed ? 'مبروك! اجتزت اختبار التمهيدي' : 'أحسنت المحاولة!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'النتيجة: ${arNum(score)} من ${arNum(total)}',
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    passed
                        ? 'أضفنا ٥٠ نجمة و ختمًا جديدًا لسجلّك! 💎'
                        : 'راجع الروضة الأولى والثانية وحاول مرة أخرى قريبًا.',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 22),
                  Button3D(
                    onTap: () => Navigator.pop(context),
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 30,
                    ),
                    child: Text(
                      'عودة',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: passed
                            ? const Color(0xFFFF7043)
                            : const Color(0xFF1E88E5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
