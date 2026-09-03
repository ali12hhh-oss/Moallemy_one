import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../core/storage/progress_v8.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

/// القسمة للصف الثالث: نتعلم المفهوم من خلال أمثلة محلولة ثم نتدرّب.
class G3DivisionScreen extends StatefulWidget {
  const G3DivisionScreen({super.key});
  @override
  State<G3DivisionScreen> createState() => _G3DivisionScreenState();
}

class _DivisionLesson {
  final int dividend;
  final int divisor;
  final int quotient;
  final String icon;
  final String explanation;
  final String detail;

  const _DivisionLesson({
    required this.dividend,
    required this.divisor,
    required this.quotient,
    required this.icon,
    required this.explanation,
    required this.detail,
  });
}

class _G3DivisionScreenState extends State<G3DivisionScreen> {
  bool learnMode = true;
  final rnd = Random();
  late int dividend, divisor, quotient;
  late List<int> options;
  int score = 0;
  String? cheer;
  int lessonIndex = 0;

  static const icons = ['🍎', '⭐', '🎈', '🍬', '⚽', '🚗', '🐶', '🍓'];
  late String icon;

  static const lessons = <_DivisionLesson>[
    _DivisionLesson(dividend: 6, divisor: 2, quotient: 3, icon: '🍎', explanation: 'نقسم ٦ تفاحات بالتساوي على مجموعتين.', detail: 'نعطي كل مجموعة ٣ تفاحات، لذلك ٦ ÷ ٢ = ٣.'),
    _DivisionLesson(dividend: 8, divisor: 2, quotient: 4, icon: '⭐', explanation: 'لدينا ٨ نجوم ونريد توزيعها بالتساوي على مجموعتين.', detail: 'كل مجموعة تحصل على ٤ نجوم، إذن ٨ ÷ ٢ = ٤.'),
    _DivisionLesson(dividend: 10, divisor: 2, quotient: 5, icon: '🎈', explanation: 'لدينا ١٠ بالونات ونقسمها إلى مجموعتين متساويتين.', detail: 'في كل مجموعة ٥ بالونات، إذن ١٠ ÷ ٢ = ٥.'),
    _DivisionLesson(dividend: 12, divisor: 3, quotient: 4, icon: '🍬', explanation: 'نوزع ١٢ قطعة حلوى بالتساوي على ٣ مجموعات.', detail: 'كل مجموعة تأخذ ٤ قطع، لذلك ١٢ ÷ ٣ = ٤.'),
    _DivisionLesson(dividend: 15, divisor: 3, quotient: 5, icon: '⚽', explanation: 'نوزع ١٥ كرة بالتساوي على ٣ مجموعات.', detail: 'كل مجموعة فيها ٥ كرات، إذن ١٥ ÷ ٣ = ٥.'),
    _DivisionLesson(dividend: 16, divisor: 4, quotient: 4, icon: '🚗', explanation: 'لدينا ١٦ سيارة لعبة ونقسمها بالتساوي على ٤ مجموعات.', detail: 'كل مجموعة تحصل على ٤ سيارات، لذلك ١٦ ÷ ٤ = ٤.'),
    _DivisionLesson(dividend: 18, divisor: 3, quotient: 6, icon: '🐶', explanation: 'نوزع ١٨ قطعة طعام بالتساوي على ٣ كلاب.', detail: 'كل كلب يحصل على ٦ قطع، إذن ١٨ ÷ ٣ = ٦.'),
    _DivisionLesson(dividend: 20, divisor: 4, quotient: 5, icon: '🍓', explanation: 'نقسم ٢٠ حبة فراولة بالتساوي على ٤ أطباق.', detail: 'في كل طبق ٥ حبات، لذلك ٢٠ ÷ ٤ = ٥.'),
    _DivisionLesson(dividend: 24, divisor: 4, quotient: 6, icon: '🍎', explanation: 'نقسم ٢٤ تفاحة بالتساوي على ٤ مجموعات.', detail: 'كل مجموعة تحصل على ٦ تفاحات، إذن ٢٤ ÷ ٤ = ٦.'),
    _DivisionLesson(dividend: 30, divisor: 5, quotient: 6, icon: '⭐', explanation: 'لدينا ٣٠ نجمة ونريد توزيعها بالتساوي على ٥ مجموعات.', detail: 'كل مجموعة تحصل على ٦ نجوم، لذلك ٣٠ ÷ ٥ = ٦.'),
  ];

  @override
  void initState() {
    super.initState();
    _generate();
  }

  void _generate() {
    divisor = 2 + rnd.nextInt(4);
    quotient = 2 + rnd.nextInt(5);
    dividend = divisor * quotient;
    icon = icons[rnd.nextInt(icons.length)];
    final others = {
      for (var i = max(1, quotient - 3); i <= quotient + 3; i++) i,
    }..remove(quotient);
    final list = others.toList()..shuffle(rnd);
    options = [quotient, ...list.take(3)]..shuffle(rnd);
  }

  void _answer(int chosen) {
    if (chosen == quotient) {
      score++;
      setState(() => cheer = kCheers[rnd.nextInt(kCheers.length)]);
      ProgressV8.addRewards(stars: 1, xp: 5);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => cheer = null);
          _generate();
        }
      });
    } else {
      setState(() => cheer = 'حاول مرة أخرى 💪');
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) setState(() => cheer = null);
      });
    }
    setState(() {});
  }

  void _speakLesson() {
    final l = lessons[lessonIndex];
    VoiceService.arabic(
      'المثال ${arNum(lessonIndex + 1)}. ${l.explanation} ${l.detail} ${arNum(l.dividend)} تقسيم ${arNum(l.divisor)} يساوي ${arNum(l.quotient)}.',
    );
  }

  void _nextLesson() {
    if (lessonIndex < lessons.length - 1) {
      setState(() => lessonIndex++);
      _speakLesson();
    }
  }

  void _previousLesson() {
    if (lessonIndex > 0) {
      setState(() => lessonIndex--);
      _speakLesson();
    }
  }

  Widget _lessonView() {
    final l = lessons[lessonIndex];
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'درس ${arNum(lessonIndex + 1)} من ${arNum(lessons.length)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                tooltip: 'استمع للشرح',
                iconSize: 34,
                onPressed: _speakLesson,
                icon: const Icon(Icons.volume_up_rounded),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: const Color(0xFF7C4DFF).withValues(alpha: .14),
                      border: Border.all(color: const Color(0xFF7C4DFF).withValues(alpha: .35)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${arNum(l.dividend)} ${l.icon}',
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          l.explanation,
                          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l.detail,
                          style: const TextStyle(fontSize: 17, height: 1.45),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${arNum(l.dividend)} ÷ ${arNum(l.divisor)} = ${arNum(l.quotient)}',
                          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'الفكرة: القسمة تعني توزيع الأشياء بالتساوي.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.deepPurple.shade700),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Button3D(
                  onTap: lessonIndex == 0 ? null : _previousLesson,
                  color: const Color(0xFF5C6BC0),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  child: const Center(
                    child: Text('السابق', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Button3D(
                  onTap: _speakLesson,
                  color: const Color(0xFFFF9800),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.volume_up_rounded, color: Colors.white),
                        SizedBox(width: 6),
                        Text('الصوت', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Button3D(
                  onTap: lessonIndex == lessons.length - 1 ? null : _nextLesson,
                  color: const Color(0xFF00A896),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  child: const Center(
                    child: Text('التالي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _practiceView() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'عندنا ${arNum(dividend)} $icon، ونريد توزيعها على ${arNum(divisor)} مجموعات متساوية.',
            style: const TextStyle(fontSize: 17),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 14,
            runSpacing: 10,
            children: List.generate(divisor, (g) {
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Wrap(
                  spacing: 2,
                  children: List.generate(quotient, (_) => Text(icon, style: const TextStyle(fontSize: 22))),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.volume_up_rounded),
                onPressed: () => VoiceService.arabic('${arNum(dividend)} تقسيم ${arNum(divisor)}'),
              ),
              Text(
                '${arNum(dividend)} ÷ ${arNum(divisor)} = ؟',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              children: options.map((o) {
                return Button3D(
                  onTap: () => _answer(o),
                  color: const Color(0xFF00C853),
                  child: Center(
                    child: Text(
                      arNum(o),
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('القسمة • ${arNum(score)} ⭐')),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Button3D(
                          onTap: () => setState(() => learnMode = true),
                          color: learnMode ? const Color(0xFF7C4DFF) : const Color(0xFFB39DDB),
                          depth: learnMode ? 2 : 7,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: const Center(child: Text('تعلّم', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white))),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Button3D(
                          onTap: () => setState(() => learnMode = false),
                          color: !learnMode ? const Color(0xFF00C853) : const Color(0xFFA5D6A7),
                          depth: !learnMode ? 2 : 7,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: const Center(child: Text('تدرّب', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white))),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: learnMode ? _lessonView() : _practiceView()),
              ],
            ),
            CelebrationOverlay(message: cheer),
          ],
        ),
      ),
    );
  }
}
