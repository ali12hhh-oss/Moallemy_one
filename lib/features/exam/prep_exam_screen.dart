import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/adaptive/adaptive_learning_engine_v24.dart';
import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../core/storage/progress_v8.dart';
import '../../data/content.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

/// سؤال موحّد لاختبار تحديد المستوى.
class _ExamQ {
  final String category;
  final String skillKey;
  final Widget visual;
  final List<String> options;
  final int correct;
  final VoidCallback? speak;

  const _ExamQ({
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

enum _ShapeKind {
  square,
  triangle,
  circle,
  rectangle,
  trapezoid,
  oblique,
  pentagon,
  hexagon,
  rhombus,
}

const _examShapes = <(String, _ShapeKind)>[
  ('مربع', _ShapeKind.square),
  ('مثلث', _ShapeKind.triangle),
  ('دائرة', _ShapeKind.circle),
  ('مستطيل', _ShapeKind.rectangle),
  ('منحرف', _ShapeKind.oblique),
  ('شبه منحرف', _ShapeKind.trapezoid),
  ('خماسي', _ShapeKind.pentagon),
  ('سداسي', _ShapeKind.hexagon),
  ('معيّن', _ShapeKind.rhombus),
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
  ('ر', 'ا'),
  ('ت', 'و'),
  ('ك', 'ا'),
  ('ج', 'ا'),
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

const _sectionInfo = <({String title, String subtitle, IconData icon, Color color})>[
  (
    title: 'الحروف',
    subtitle: 'التعرف على الحروف',
    icon: Icons.translate_rounded,
    color: Color(0xFF7C4DFF),
  ),
  (
    title: 'أصوات الحروف',
    subtitle: 'الاستماع لصوت الحرف',
    icon: Icons.record_voice_over_rounded,
    color: Color(0xFF00897B),
  ),
  (
    title: 'الأرقام',
    subtitle: 'التعرف على الأرقام وترتيبها',
    icon: Icons.looks_one_rounded,
    color: Color(0xFF1E88E5),
  ),
  (
    title: 'الألوان',
    subtitle: 'تمييز الألوان',
    icon: Icons.palette_rounded,
    color: Color(0xFFFF7043),
  ),
  (
    title: 'الأشكال',
    subtitle: 'تمييز الأشكال',
    icon: Icons.category_rounded,
    color: Color(0xFF43A047),
  ),
  (
    title: 'الكتابة',
    subtitle: 'تمييز الحروف والأرقام المكتوبة',
    icon: Icons.edit_rounded,
    color: Color(0xFF8E24AA),
  ),
  (
    title: 'دمج الحروف',
    subtitle: 'قراءة الحروف المدمجة',
    icon: Icons.extension_rounded,
    color: Color(0xFFF4511E),
  ),
  (
    title: 'الآحاد والعشرات',
    subtitle: 'فهم القيمة المكانية',
    icon: Icons.grid_view_rounded,
    color: Color(0xFF3949AB),
  ),
];

List<_ExamQ> _buildBank(Random rnd) {
  final bank = <_ExamQ>[];

  // ١) الحروف: ٤ أسئلة.
  for (var k = 0; k < 4; k++) {
    final target = arabicLetters[rnd.nextInt(arabicLetters.length)];
    final others = [...arabicLetters]..shuffle(rnd);
    others.removeWhere((l) => l.letter == target.letter);
    final opts = [target.letter, ...others.take(3).map((l) => l.letter)]..shuffle(rnd);
    bank.add(
      _ExamQ(
        category: 'الحروف',
        skillKey: 'exam.letters',
        visual: Text(
          target.letter,
          style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w900),
        ),
        options: opts,
        correct: opts.indexOf(target.letter),
        speak: () => VoiceService.arabicLetterSound(
          target.letter,
          fallbackText: target.sound,
        ),
      ),
    );
  }

  // ٢) أصوات الحروف: ٤ أسئلة، مع التركيز على صوت الحرف لا اسمه.
  for (var k = 0; k < 4; k++) {
    final target = arabicLetters[rnd.nextInt(arabicLetters.length)];
    final others = [...arabicLetters]..shuffle(rnd);
    others.removeWhere((l) => l.letter == target.letter);
    final opts = [target.letter, ...others.take(3).map((l) => l.letter)]..shuffle(rnd);
    bank.add(
      _ExamQ(
        category: 'أصوات الحروف',
        skillKey: 'exam.letterSounds',
        visual: const Icon(Icons.hearing_rounded, size: 68),
        options: opts,
        correct: opts.indexOf(target.letter),
        speak: () => VoiceService.arabicLetterSound(
          target.letter,
          fallbackText: target.sound,
        ),
      ),
    );
  }

  // ٣) الأرقام: ٤ أسئلة من ١ إلى ١٠ مع تنويع السابق واللاحق.
  for (var k = 0; k < 4; k++) {
    final n = 1 + rnd.nextInt(10);
    final mode = k % 3;
    final optionsNumbers = <int>[];
    int answer;
    String prompt;
    if (mode == 0) {
      answer = n;
      prompt = 'استمع للعدد واختر رقمه';
    } else if (mode == 1) {
      answer = n == 10 ? 9 : n + 1;
      prompt = 'ما الرقم الذي يأتي بعد ${arNum(n)}؟';
    } else {
      answer = n == 1 ? 2 : n - 1;
      prompt = 'ما الرقم الذي يأتي قبل ${arNum(n)}؟';
    }
    final candidates = List.generate(10, (i) => i + 1)
      ..remove(answer)
      ..shuffle(rnd);
    optionsNumbers.add(answer);
    optionsNumbers.addAll(candidates.take(3));
    optionsNumbers.shuffle(rnd);
    bank.add(
      _ExamQ(
        category: 'الأرقام',
        skillKey: 'exam.numbers',
        visual: Text(
          prompt,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        options: optionsNumbers.map(arNum).toList(),
        correct: optionsNumbers.indexOf(answer),
        speak: mode == 0
            ? () => VoiceService.arabic(_numberWords[n] ?? '$n')
            : null,
      ),
    );
  }

  // ٤) الألوان: ٣ أسئلة بصرية وسمعية.
  for (var k = 0; k < 3; k++) {
    final target = _examColors[rnd.nextInt(_examColors.length)];
    final others = [..._examColors]..shuffle(rnd);
    others.removeWhere((c) => c.$1 == target.$1);
    final opts = [target.$1, ...others.take(3).map((c) => c.$1)]..shuffle(rnd);
    bank.add(
      _ExamQ(
        category: 'الألوان',
        skillKey: 'exam.colors',
        visual: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: target.$2,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black12, width: 2),
          ),
        ),
        options: opts,
        correct: opts.indexOf(target.$1),
        speak: k == 1 ? () => VoiceService.arabic(target.$1) : null,
      ),
    );
  }

  // ٥) الأشكال: ٣ أسئلة وتشمل الأشكال التسعة الموجودة في الروضة الثانية.
  for (var k = 0; k < 3; k++) {
    final target = _examShapes[rnd.nextInt(_examShapes.length)];
    final others = [..._examShapes]..shuffle(rnd);
    others.removeWhere((s) => s.$1 == target.$1);
    final opts = [target.$1, ...others.take(3).map((s) => s.$1)]..shuffle(rnd);
    bank.add(
      _ExamQ(
        category: 'الأشكال',
        skillKey: 'exam.shapes',
        visual: SizedBox(
          width: 110,
          height: 110,
          child: CustomPaint(painter: _ExamShapePainter(target.$2)),
        ),
        options: opts,
        correct: opts.indexOf(target.$1),
        speak: k == 1 ? () => VoiceService.arabic(target.$1) : null,
      ),
    );
  }

  // ٦) الكتابة: سؤالان لتمييز شكل حرف ورقم مكتوبين.
  final targetLetter = arabicLetters[rnd.nextInt(arabicLetters.length)];
  final letterOthers = [...arabicLetters]..shuffle(rnd);
  letterOthers.removeWhere((l) => l.letter == targetLetter.letter);
  final letterOpts = [targetLetter.letter, ...letterOthers.take(3).map((l) => l.letter)]..shuffle(rnd);
  bank.add(
    _ExamQ(
      category: 'الكتابة',
      skillKey: 'exam.writing',
      visual: Text(
        targetLetter.letter,
        style: const TextStyle(fontSize: 80, fontWeight: FontWeight.w900),
      ),
      options: letterOpts,
      correct: letterOpts.indexOf(targetLetter.letter),
      speak: () => VoiceService.arabicLetterSound(
        targetLetter.letter,
        fallbackText: targetLetter.sound,
      ),
    ),
  );
  final writtenNumber = 1 + rnd.nextInt(20);
  final numberOthers = List.generate(20, (i) => i + 1)
    ..remove(writtenNumber)
    ..shuffle(rnd);
  final writtenOpts = [writtenNumber, ...numberOthers.take(3)]..shuffle(rnd);
  bank.add(
    _ExamQ(
      category: 'الكتابة',
      skillKey: 'exam.writing',
      visual: Text(
        arNum(writtenNumber),
        style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w900),
      ),
      options: writtenOpts.map(arNum).toList(),
      correct: writtenOpts.indexOf(writtenNumber),
      speak: () => VoiceService.arabic(_numberWords[writtenNumber] ?? '$writtenNumber'),
    ),
  );

  // ٧) دمج الحروف: ٤ أسئلة.
  for (var k = 0; k < 4; k++) {
    final target = _examPairs[rnd.nextInt(_examPairs.length)];
    final correctStr = '${target.$1}${target.$2}';
    final others = _examPairs
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
          style: const TextStyle(fontSize: 46, fontWeight: FontWeight.w900),
        ),
        options: opts,
        correct: opts.indexOf(correctStr),
        speak: () => VoiceService.arabic(correctStr),
      ),
    );
  }

  // ٨) الآحاد والعشرات: ٤ أسئلة، والآحاد يمين والعشرات يسار في العرض.
  for (var k = 0; k < 4; k++) {
    final n = 10 + rnd.nextInt(41);
    final ones = n % 10;
    final tens = n ~/ 10;
    final askOnes = k.isEven;
    final answer = askOnes ? ones : tens;
    final label = askOnes ? 'الآحاد' : 'العشرات';
    final candidates = List.generate(10, (i) => i)
      ..remove(answer)
      ..shuffle(rnd);
    final opts = [answer, ...candidates.take(3)]..shuffle(rnd);
    bank.add(
      _ExamQ(
        category: 'الآحاد والعشرات',
        skillKey: askOnes ? 'exam.ones' : 'exam.tens',
        visual: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _PlaceValueBox(label: 'الآحاد', value: ones, active: askOnes),
              const SizedBox(width: 14),
              _PlaceValueBox(label: 'العشرات', value: tens, active: !askOnes),
            ],
          ),
        ),
        options: opts.map(arNum).toList(),
        correct: opts.indexOf(answer),
        speak: () => VoiceService.arabic('أين $label؟'),
      ),
    );
  }

  bank.shuffle(rnd);
  return bank;
}

class _PlaceValueBox extends StatelessWidget {
  final String label;
  final int value;
  final bool active;

  const _PlaceValueBox({
    required this.label,
    required this.value,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF3949AB) : const Color(0xFFE8EAF6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: active ? const Color(0xFF1A237E) : Colors.black12,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : const Color(0xFF3949AB),
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            arNum(value),
            style: TextStyle(
              color: active ? Colors.white : const Color(0xFF3949AB),
              fontSize: 36,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExamShapePainter extends CustomPainter {
  final _ShapeKind kind;
  const _ExamShapePainter(this.kind);

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
      case _ShapeKind.rhombus:
        path.moveTo(w / 2, 2);
        path.lineTo(w - 4, h / 2);
        path.lineTo(w / 2, h - 2);
        path.lineTo(4, h / 2);
        path.close();
        canvas.drawPath(path, paint);
      case _ShapeKind.pentagon:
        _polygon(path, w, h, 5);
        canvas.drawPath(path, paint);
      case _ShapeKind.hexagon:
        _polygon(path, w, h, 6);
        canvas.drawPath(path, paint);
    }
  }

  static void _polygon(Path path, double w, double h, int sides) {
    final cx = w / 2;
    final cy = h / 2;
    final r = min(w, h) / 2 - 3;
    for (var i = 0; i < sides; i++) {
      final angle = -pi / 2 + i * 2 * pi / sides;
      final x = cx + r * cos(angle);
      final y = cy + r * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
  }

  @override
  bool shouldRepaint(covariant _ExamShapePainter oldDelegate) =>
      oldDelegate.kind != kind;
}

/// اختبار تحديد المستوى للمرحلتين السابقتين.
/// البطاقات الثمانية في البداية تنظيمية فقط؛ عند البدء يبدأ اختبار واحد
/// متدرج ومختلط من جميع المهارات.
class PrepExamScreen extends StatefulWidget {
  const PrepExamScreen({super.key});

  @override
  State<PrepExamScreen> createState() => _PrepExamScreenState();
}

class _PrepExamScreenState extends State<PrepExamScreen> {
  final rnd = Random();
  late List<_ExamQ> questions;
  final Map<String, int> correctByCategory = {};
  final Map<String, int> totalByCategory = {};
  int index = 0;
  int correctFirstTry = 0;
  bool missedThisQuestion = false;
  bool locked = false;
  String? cheer;
  bool started = false;
  bool finished = false;
  String resultTitle = 'المستكشف الصغير';
  String resultGift = '🎁 هدية البداية';

  @override
  void initState() {
    super.initState();
    questions = _buildBank(rnd);
    for (final q in questions) {
      totalByCategory[q.category] = (totalByCategory[q.category] ?? 0) + 1;
    }
  }

  void _start() {
    setState(() {
      started = true;
      index = 0;
      correctFirstTry = 0;
      missedThisQuestion = false;
      locked = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) questions[index].speak?.call();
    });
  }

  void _answer(int chosen) {
    if (locked || finished) return;
    final q = questions[index];
    if (chosen != q.correct) {
      missedThisQuestion = true;
      setState(() => cheer = 'حاول مرة أخرى 💪');
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) setState(() => cheer = null);
      });
      return;
    }

    locked = true;
    if (!missedThisQuestion) {
      correctFirstTry++;
      correctByCategory[q.category] = (correctByCategory[q.category] ?? 0) + 1;
    }
    AdaptiveLearningEngineV24.record(q.skillKey, !missedThisQuestion);
    ProgressV8.addRewards(stars: 1, xp: 5);
    setState(() => cheer = kCheers[rnd.nextInt(kCheers.length)]);

    Future.delayed(const Duration(milliseconds: 1100), () async {
      if (!mounted) return;
      if (index + 1 < questions.length) {
        setState(() {
          cheer = null;
          index++;
          missedThisQuestion = false;
          locked = false;
        });
        questions[index].speak?.call();
      } else {
        await _finish();
      }
    });
  }

  Future<void> _finish() async {
    final total = questions.length;
    final ratio = correctFirstTry / total;
    final passed = ratio >= .6;
    final title = _titleForScore(ratio);
    final gift = _giftForScore(ratio);
    resultTitle = title;
    resultGift = gift;

    final state = await ProgressV8.load();
    state['placementTitle'] = title;
    state['placementGift'] = gift;
    state['placementScore'] = correctFirstTry;
    state['placementTotal'] = total;
    state['placementDate'] = DateTime.now().toIso8601String();
    await ProgressV8.save(state);
    await ProgressV8.recordFinalExam('prep', correctFirstTry, total, passed);

    if (!mounted) return;
    setState(() {
      cheer = null;
      finished = true;
      locked = false;
    });
  }

  String _titleForScore(double ratio) {
    if (ratio >= .9) return 'العبقري الصغير';
    if (ratio >= .8) return 'النجم المتألق';
    if (ratio >= .7) return 'البطل الصغير';
    if (ratio >= .6) return 'المجتهد الرائع';
    return 'المستكشف الصغير';
  }

  String _giftForScore(double ratio) {
    if (ratio >= .9) return '🏆 وسام العبقري الصغير';
    if (ratio >= .8) return '🌟 وسام النجم المتألق';
    if (ratio >= .7) return '🥇 وسام البطل الصغير';
    if (ratio >= .6) return '💪 وسام المجتهد الرائع';
    return '🌱 وسام المستكشف الصغير';
  }

  @override
  Widget build(BuildContext context) {
    if (finished) {
      return _ResultScreen(
        score: correctFirstTry,
        total: questions.length,
        title: resultTitle,
        gift: resultGift,
        breakdown: _breakdown(),
      );
    }
    if (!started) return _IntroScreen(onStart: _start);
    return _ExamScreen(
      question: questions[index],
      index: index,
      total: questions.length,
      cheer: cheer,
      onAnswer: _answer,
    );
  }

  Map<String, String> _breakdown() {
    final result = <String, String>{};
    for (final entry in totalByCategory.entries) {
      final correct = correctByCategory[entry.key] ?? 0;
      final ratio = correct / entry.value;
      result[entry.key] = _levelText(ratio);
    }
    return result;
  }

  String _levelText(double ratio) {
    if (ratio >= .9) return 'ممتاز';
    if (ratio >= .75) return 'جيد جدًا';
    if (ratio >= .6) return 'جيد';
    return 'يحتاج تدريب';
  }
}

class _IntroScreen extends StatelessWidget {
  final VoidCallback onStart;

  const _IntroScreen({required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('🎓 اختبار تحديد المستوى')),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C4DFF), Color(0xFF00BFA5)],
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Column(
                children: [
                  Text('🌟', style: TextStyle(fontSize: 54)),
                  SizedBox(height: 8),
                  Text(
                    'لنكتشف مستواك!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'أسئلة قصيرة ومتنوعة من مهارات الروضة الأولى والثانية. أجب بهدوء واستمع للسؤال عندما يظهر زر السماعة.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            ..._sectionInfo.map(
              (section) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  decoration: BoxDecoration(
                    color: section.color.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: section.color.withValues(alpha: .28)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: section.color,
                        child: Icon(section.icon, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              section.title,
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
                            ),
                            Text(section.subtitle),
                          ],
                        ),
                      ),
                      const Icon(Icons.check_circle_outline_rounded),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Button3D(
              onTap: onStart,
              color: const Color(0xFF00BFA5),
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32),
                  SizedBox(width: 8),
                  Text(
                    'ابدأ تحديد المستوى',
                    style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExamScreen extends StatelessWidget {
  final _ExamQ question;
  final int index;
  final int total;
  final String? cheer;
  final void Function(int) onAnswer;

  const _ExamScreen({
    required this.question,
    required this.index,
    required this.total,
    required this.cheer,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('تحديد المستوى • ${arNum(index + 1)} / ${arNum(total)}'),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: (index + 1) / total,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C4DFF).withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      question.category,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Center(child: question.visual),
                        ),
                        if (question.speak != null) ...[
                          Button3D(
                            onTap: question.speak!,
                            color: const Color(0xFF00897B),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.volume_up_rounded, color: Colors.white, size: 30),
                                SizedBox(width: 8),
                                Text(
                                  'استمع للسؤال',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        SizedBox(
                          height: 230,
                          child: GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            children: List.generate(question.options.length, (i) {
                              return Button3D(
                                onTap: () => onAnswer(i),
                                color: const Color(0xFF7C4DFF),
                                child: Center(
                                  child: Text(
                                    question.options[i],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 24,
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
  final String title;
  final String gift;
  final Map<String, String> breakdown;

  const _ResultScreen({
    required this.score,
    required this.total,
    required this.title,
    required this.gift,
    required this.breakdown,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = score / total;
    final passed = ratio >= .6;
    final level = ratio >= .8 ? 'الروضة الثانية' : 'الروضة الأولى';
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('نتيجة تحديد المستوى')),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: passed
                      ? const [Color(0xFFFFD54F), Color(0xFFFF7043)]
                      : const [Color(0xFF90CAF9), Color(0xFF64B5F6)],
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                children: [
                  Text(passed ? '🏆🎉⭐' : '🌱💪', style: const TextStyle(fontSize: 50)),
                  const SizedBox(height: 8),
                  Text(
                    passed ? 'أحسنت! اكتشفنا مستواك' : 'بداية جميلة! استمر',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'النتيجة: ${arNum(score)} من ${arNum(total)}',
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'المستوى المقترح: $level',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFFFB74D)),
              ),
              child: Column(
                children: [
                  const Text('🎁 هديتك الجديدة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Text(title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 5),
                  Text(gift, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    passed ? '⭐ حصلت على مكافأة الاختبار أيضًا' : '🌱 هذا اللقب بداية طريقك الجميل',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'تحليل المهارات',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            ...breakdown.entries.map(
              (entry) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.check_circle_rounded),
                  title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w800)),
                  trailing: Text(
                    entry.value,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Button3D(
              onTap: () => Navigator.pop(context),
              color: const Color(0xFF7C4DFF),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Text(
                'عودة',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
