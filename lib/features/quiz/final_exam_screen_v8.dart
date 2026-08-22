import 'package:flutter/material.dart';

import '../../data/curriculum_v8.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../core/storage/progress_v8.dart';
import '../../core/audio/voice_service.dart';

class FinalExamScreenV8 extends StatefulWidget {
  final CurriculumStageV8 stage;
  const FinalExamScreenV8({super.key, required this.stage});
  @override
  State<FinalExamScreenV8> createState() => _FinalExamScreenV8State();
}

class _FinalExamScreenV8State extends State<FinalExamScreenV8> {
  late final List<_Question> questions;
  int index = 0, score = 0;
  bool answered = false;

  @override
  void initState() {
    super.initState();
    questions = _questions(widget.stage.id);
  }

  @override
  Widget build(BuildContext context) {
    if (index >= questions.length) return _result();
    final q = questions[index];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('اختبار ${widget.stage.title}')),
        body: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'السؤال ${arNum(index + 1)} من ${arNum(questions.length)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('النتيجة: ${arNum(score)} ⭐'),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: (index + 1) / questions.length,
                minHeight: 9,
              ),
              const SizedBox(height: 28),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      Text(q.emoji, style: const TextStyle(fontSize: 70)),
                      const SizedBox(height: 12),
                      Text(
                        q.prompt,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (q.voiceText != null)
                        IconButton(
                          onPressed: () => VoiceService.arabic(q.voiceText!),
                          icon: const Icon(Icons.volume_up),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              ...q.options.map(
                (option) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonal(
                      onPressed:
                          answered ? null : () => _answer(option == q.answer),
                      child: Text(option, style: const TextStyle(fontSize: 21)),
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

  void _answer(bool correct) {
    if (answered) return;
    setState(() {
      answered = true;
      if (correct) score++;
    });
    Future.delayed(const Duration(milliseconds: 650), () {
      if (!mounted) return;
      setState(() {
        index++;
        answered = false;
      });
    });
  }

  Widget _result() {
    final passed = score * 100 >= questions.length * 70;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ProgressV8.recordFinalExam(
        widget.stage.id,
        score,
        questions.length,
        passed,
      );
    });
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('نتيجة الاختبار النهائي')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  passed ? '🎉' : '🌱',
                  style: const TextStyle(fontSize: 90),
                ),
                Text(
                  passed
                      ? 'أحسنت! اجتزت المرحلة'
                      : 'أحسنت المحاولة! نراجع ثم نعيد الاختبار',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'نتيجتك: ${arNum(score)} من ${arNum(questions.length)}',
                  style: const TextStyle(fontSize: 23),
                ),
                Text(
                  'النسبة: ${arNum((score / questions.length * 100).round())}٪',
                  style: const TextStyle(fontSize: 23),
                ),
                const SizedBox(height: 20),
                Text(
                  passed
                      ? '🏆 حصلت على ٥٠ نجمة و٥٠٠ نقطة تعليمية'
                      : '🔄 راجع المهارات الضعيفة ثم حاول مرة أخرى',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('العودة إلى المنهج'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<_Question> _questions(String id) {
    final common = <_Question>[
      const _Question(
        'أي خيار يمثل الحرف ب؟',
        ['ب', 'ت', 'ث', 'ن'],
        'ب',
        '🔤',
        'بَ',
      ),
      const _Question(
        'ما الكلمة التي تبدأ بصوت مَ؟',
        ['موز', 'كتاب', 'قلم', 'باب'],
        'موز',
        '🍌',
        'موز',
      ),
      const _Question('كم يساوي ٢ + ٣؟', ['٤', '٥', '٦', '٧'], '٥', '➕', null),
      const _Question(
        'اختر الكلمة المناسبة للصورة',
        ['شمس', 'قمر', 'كتاب', 'باب'],
        'شمس',
        '☀️',
        null,
      ),
      const _Question(
        'ما اسم الحرف الإنجليزي B؟',
        ['Bee', 'Dee', 'Kay', 'Em'],
        'Bee',
        '🇬🇧',
        null,
      ),
    ];
    if (id == 'kg1') return common.sublist(0, 3);
    if (id == 'kg2')
      return [
        ...common.sublist(0, 4),
        const _Question(
          'اختر العدد الأكبر',
          ['٣', '٥', '٢', '٤'],
          '٥',
          '🔢',
          null,
        ),
      ];
    if (id == 'prep')
      return [
        ...common,
        const _Question(
          'اختر الكلمة المقسمة إلى مقطعين',
          ['مَدْرَسَة', 'باب', 'قلم', 'نور'],
          'مَدْرَسَة',
          '📚',
          null,
        ),
      ];
    if (id == 'g1')
      return [
        ...common,
        const _Question(
          'كم يساوي ٧ - ٢؟',
          ['٣', '٤', '٥', '٦'],
          '٥',
          '➖',
          null,
        ),
        const _Question(
          'اختر صوت الحرف B في كلمة ball',
          ['buh', 'sss', 'mmm', 'tuh'],
          'buh',
          '⚽',
          null,
        ),
      ];
    if (id == 'g2')
      return [
        ...common,
        const _Question(
          'أي جملة صحيحة؟',
          ['الولد يقرأ.', 'يقرأ الولد؟', 'الولد قراءة.', 'قراءة الولد هو.'],
          'الولد يقرأ.',
          '📖',
          null,
        ),
      ];
    return [
      ...common,
      const _Question(
        'ما قيمة الرقم ٥ في ٥٢٣؟',
        ['٥', '٥٠', '٥٠٠', '٥٠٠٠'],
        '٥٠٠',
        '🔢',
        null,
      ),
      const _Question(
        'اختر بداية مناسبة لجملة إنجليزية',
        ['I am', 'Am I a', 'Is am', 'I are'],
        'I am',
        '🇬🇧',
        null,
      ),
    ];
  }
}

class _Question {
  final String prompt, answer, emoji;
  final List<String> options;
  final String? voiceText;
  const _Question(
    this.prompt,
    this.options,
    this.answer,
    this.emoji,
    this.voiceText,
  );
}
