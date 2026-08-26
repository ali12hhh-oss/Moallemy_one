import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/adaptive/adaptive_learning_engine_v24.dart';
import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../core/storage/progress_v8.dart';
import '../../data/content.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

class _ExamQ {
  final String category;
  final String skillKey;
  final String prompt;
  final Widget visual;
  final List<String> options;
  final int correct;
  final VoidCallback? speak;

  _ExamQ({
    required this.category,
    required this.skillKey,
    required this.prompt,
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
  ('شبه منحرف', _ShapeKind.trapezoid),
  ('متوازي الأضلاع', _ShapeKind.oblique),
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

  // أسئلة سمعية للحروف: 8 أهداف مختلفة في كل اختبار، بلا تكرار.
  final letterTargets = [...arabicLetters]..shuffle(rnd);
  for (final target in letterTargets.take(8)) {
    final others = [...arabicLetters]..shuffle(rnd);
    others.removeWhere((l) => l.letter == target.letter);
    final opts = [target.letter, ...others.take(3).map((l) => l.letter)]..shuffle(rnd);
    bank.add(_ExamQ(
      category: 'الحروف',
      skillKey: 'exam.letters',
      prompt: 'استمع لصوت الحرف واختر الحرف الصحيح',
      visual: const Icon(Icons.hearing_rounded, size: 54),
      options: opts,
      correct: opts.indexOf(target.letter),
      speak: () => VoiceService.arabicLetterSound(target.letter, fallbackText: target.sound),
    ));
  }

  // أسئلة سمعية للأرقام: 8 أرقام مختلفة من 1 إلى 10، بلا تكرار.
  final numberTargets = List.generate(10, (i) => i + 1)..shuffle(rnd);
  for (final n in numberTargets.take(8)) {
    final others = List.generate(10, (i) => i + 1).where((x) => x != n).toList()..shuffle(rnd);
    final opts = [n, ...others.take(3)]..shuffle(rnd);
    bank.add(_ExamQ(
      category: 'الأرقام',
      skillKey: 'exam.numbers',
      prompt: 'استمع للعدد واختر الرقم الصحيح',
      visual: const Icon(Icons.hearing_rounded, size: 54),
      options: opts.map(arNum).toList(),
      correct: opts.indexOf(n),
      speak: () => VoiceService.arabic(_numberWords[n] ?? '$n'),
    ));
  }

  // الألوان: أربعة ألوان مختلفة في كل اختبار، بلا تكرار.
  final colorTargets = [..._examColors]..shuffle(rnd);
  for (final target in colorTargets.take(4)) {
    final others = [..._examColors]..shuffle(rnd);
    others.removeWhere((c) => c.$1 == target.$1);
    final opts = [target.$1, ...others.take(3).map((c) => c.$1)]..shuffle(rnd);
    bank.add(_ExamQ(
      category: 'الألوان',
      skillKey: 'exam.colors',
      prompt: 'ما اسم هذا اللون؟ اختر الإجابة الصحيحة',
      visual: Container(
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          color: target.$2,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black12, width: 2),
        ),
      ),
      options: opts,
      correct: opts.indexOf(target.$1),
    ));
  }

  // الأشكال: أربعة أشكال مختلفة في كل اختبار، بلا تكرار.
  final shapeTargets = [..._examShapes]..shuffle(rnd);
  for (final target in shapeTargets.take(4)) {
    final others = [..._examShapes]..shuffle(rnd);
    others.removeWhere((s) => s.$1 == target.$1);
    final opts = [target.$1, ...others.take(3).map((s) => s.$1)]..shuffle(rnd);
    bank.add(_ExamQ(
      category: 'الأشكال',
      skillKey: 'exam.shapes',
      prompt: 'اختر الشكل الذي اسمه مكتوب في السؤال',
      visual: Text(
        target.$1,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
      ),
      options: opts,
      correct: opts.indexOf(target.$1),
    ));
  }

  // دمج الحروف: أربعة أزواج مختلفة في كل اختبار، بلا تكرار.
  final pairTargets = [..._examPairs]..shuffle(rnd);
  for (final target in pairTargets.take(4)) {
    final correctStr = '${target.$1}${target.$2}';
    final others = _examPairs
        .map((p) => '${p.$1}${p.$2}')
        .where((c) => c != correctStr)
        .toList()
      ..shuffle(rnd);
    final opts = [correctStr, ...others.take(3)]..shuffle(rnd);
    bank.add(_ExamQ(
      category: 'دمج الحروف',
      skillKey: 'exam.combine',
      prompt: 'ادمج الحرفين واختر الإجابة الصحيحة',
      visual: Text(
        '${target.$1}  +  ${target.$2}',
        textDirection: TextDirection.rtl,
        style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900),
      ),
      options: opts,
      correct: opts.indexOf(correctStr),
    ));
  }

  // الآحاد: أربعة أعداد مختلفة في كل اختبار، بلا تكرار.
  final onesTargets = List.generate(9, (i) => i + 1)..shuffle(rnd);
  for (final n in onesTargets.take(4)) {
    final icon = _icons[rnd.nextInt(_icons.length)];
    final others = List.generate(9, (i) => i + 1).where((x) => x != n).toList()..shuffle(rnd);
    final opts = [n, ...others.take(3)]..shuffle(rnd);
    bank.add(_ExamQ(
      category: 'آحاد',
      skillKey: 'exam.ones',
      prompt: 'عدّ الصور واختر العدد الصحيح',
      visual: Wrap(
        alignment: WrapAlignment.center,
        spacing: 5,
        runSpacing: 3,
        children: List.generate(n, (_) => Text(icon, style: const TextStyle(fontSize: 23))),
      ),
      options: opts.map(arNum).toList(),
      correct: opts.indexOf(n),
    ));
  }

  // العشرات: جميع القيم الخمس المختلفة، بلا تكرار.
  final tensTargets = [..._tensList]..shuffle(rnd);
  for (final n in tensTargets) {
    final others = _tensList.where((x) => x != n).toList()..shuffle(rnd);
    final opts = [n, ...others.take(3)]..shuffle(rnd);
    final groups = n ~/ 10;
    bank.add(_ExamQ(
      category: 'عشرات',
      skillKey: 'exam.tens',
      prompt: 'كم عشرة ترى؟ اختر العدد الصحيح',
      visual: Wrap(
        alignment: WrapAlignment.center,
        spacing: 5,
        children: List.generate(
          groups,
          (_) => Container(
            width: 34,
            height: 34,
            padding: const EdgeInsets.all(3),
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
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(color: Color(0xFF00C853), shape: BoxShape.circle),
                ),
              ),
            ),
          ),
        ),
      ),
      options: opts.map(arNum).toList(),
      correct: opts.indexOf(n),
    ));
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
    final w = size.width;
    final h = size.height;
    final path = Path();
    switch (kind) {
      case _ShapeKind.square:
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(5, 5, w - 10, h - 10), const Radius.circular(8)), paint);
      case _ShapeKind.rectangle:
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(2, h * .24, w - 4, h * .52), const Radius.circular(8)), paint);
      case _ShapeKind.circle:
        canvas.drawCircle(Offset(w / 2, h / 2), min(w, h) / 2 - 3, paint);
      case _ShapeKind.triangle:
        path.moveTo(w / 2, 3);
        path.lineTo(w - 4, h - 4);
        path.lineTo(4, h - 4);
        path.close();
        canvas.drawPath(path, paint);
      case _ShapeKind.trapezoid:
        path.moveTo(w * .27, 5);
        path.lineTo(w * .73, 5);
        path.lineTo(w - 4, h - 5);
        path.lineTo(4, h - 5);
        path.close();
        canvas.drawPath(path, paint);
      case _ShapeKind.oblique:
        path.moveTo(w * .28, 5);
        path.lineTo(w - 4, 5);
        path.lineTo(w * .72, h - 5);
        path.lineTo(4, h - 5);
        path.close();
        canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ExamShapePainter oldDelegate) => oldDelegate.kind != kind;
}

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
    WidgetsBinding.instance.addPostFrameCallback((_) => questions[0].speak?.call());
  }

  void _answer(int chosen) {
    final q = questions[index];
    if (chosen == q.correct) {
      if (!missedThisQuestion) correctFirstTry++;
      AdaptiveLearningEngineV24.record(q.skillKey, !missedThisQuestion);
      ProgressV8.addRewards(stars: 1, xp: 5);
      setState(() => cheer = kCheers[rnd.nextInt(kCheers.length)]);
      Future.delayed(const Duration(milliseconds: 1100), () {
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
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) setState(() => cheer = null);
      });
    }
  }

  Future<void> _finish() async {
    final total = questions.length;
    final passed = correctFirstTry / total >= .6;
    await ProgressV8.recordFinalExam('prep', correctFirstTry, total, passed);
  }

  Widget _optionContent(_ExamQ q, int i) {
    if (q.category == 'الأشكال') {
      final shape = _examShapes.firstWhere((s) => s.$1 == q.options[i]).$2;
      return CustomPaint(size: const Size(70, 70), painter: _ExamShapePainter(shape));
    }
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        q.options[i],
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (finished) return _ResultScreen(score: correctFirstTry, total: questions.length);
    final q = questions[index];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('اختبار التمهيدي • ${arNum(index + 1)} / ${arNum(questions.length)}')),
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
                child: Column(
                  children: [
                    LinearProgressIndicator(value: (index + 1) / questions.length),
                    const SizedBox(height: 7),
                    Chip(label: Text(q.category, style: const TextStyle(fontWeight: FontWeight.bold)), visualDensity: VisualDensity.compact),
                    const SizedBox(height: 3),
                    Text(q.prompt, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 5),
                    SizedBox(height: 78, child: Center(child: q.visual)),
                    if (q.speak != null)
                      SizedBox(
                        height: 38,
                        child: IconButton(
                          iconSize: 34,
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.volume_up_rounded),
                          onPressed: q.speak,
                        ),
                      ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final tileWidth = (constraints.maxWidth - 12) / 2;
                          final tileHeight = (constraints.maxHeight - 12) / 2;
                          return GridView.count(
                            primary: false,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: tileWidth / tileHeight,
                            children: List.generate(q.options.length, (i) {
                              return Button3D(
                                onTap: () => _answer(i),
                                color: const Color(0xFF7C4DFF),
                                padding: const EdgeInsets.all(8),
                                child: Center(child: _optionContent(q, i)),
                              );
                            }),
                          );
                        },
                      ),
                    ),
                  ],
                ),
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
                  colors: passed ? const [Color(0xFFFFD54F), Color(0xFFFF7043)] : const [Color(0xFF90CAF9), Color(0xFF64B5F6)],
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(passed ? '🏆🎉⭐' : '💪🌟', style: const TextStyle(fontSize: 50)),
                  const SizedBox(height: 14),
                  Text(
                    passed ? 'مبروك! اجتزت اختبار التمهيدي' : 'أحسنت المحاولة!',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text('النتيجة: ${arNum(score)} من ${arNum(total)}', style: const TextStyle(fontSize: 20, color: Colors.white)),
                  const SizedBox(height: 6),
                  Text(
                    passed ? 'أضفنا ٥٠ نجمة و ختمًا جديدًا لسجلّك! 💎' : 'راجع الروضة الأولى والثانية وحاول مرة أخرى قريبًا.',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 22),
                  Button3D(
                    onTap: () => Navigator.pop(context),
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                    child: Text(
                      'عودة',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: passed ? const Color(0xFFFF7043) : const Color(0xFF1E88E5)),
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
