import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../widgets/button_3d.dart';

class G1AddSubLearningScreen extends StatefulWidget {
  final bool isAddition;

  const G1AddSubLearningScreen({super.key, required this.isAddition});

  @override
  State<G1AddSubLearningScreen> createState() => _G1AddSubLearningScreenState();
}

class _G1AddSubLearningScreenState extends State<G1AddSubLearningScreen> {
  int _page = 0;

  static const _additionLessons = <_MathLesson>[
    _MathLesson(
      title: 'ما هو الجمع؟',
      explanation: 'الجمع يعني أن نضع مجموعتين معًا لنرى كم أصبح لدينا.',
      leftEmoji: '🍎',
      leftCount: 1,
      rightEmoji: '🍎',
      rightCount: 1,
      operation: '١ + ١ = ٢',
      resultText: 'تفاحة واحدة مع تفاحة واحدة تساوي تفاحتين.',
    ),
    _MathLesson(
      title: 'نجمع تفاحات',
      explanation: 'نبدأ بالعدد الأول، ثم نضيف إليه العدد الثاني.',
      leftEmoji: '🍎',
      leftCount: 2,
      rightEmoji: '🍎',
      rightCount: 1,
      operation: '٢ + ١ = ٣',
      resultText: 'تفاحتان مع تفاحة واحدة تساوي ٣ تفاحات.',
    ),
    _MathLesson(
      title: 'نجمع حيوانات',
      explanation: 'عندما نضم مجموعتين من الحيوانات، نستخدم الجمع.',
      leftEmoji: '🐶',
      leftCount: 2,
      rightEmoji: '🐶',
      rightCount: 2,
      operation: '٢ + ٢ = ٤',
      resultText: 'كلبان مع كلبين يساويان ٤ كلاب.',
    ),
    _MathLesson(
      title: 'نجمع فواكه',
      explanation: 'أضفنا مجموعة صغيرة إلى مجموعة أخرى، فزاد العدد.',
      leftEmoji: '🍌',
      leftCount: 3,
      rightEmoji: '🍓',
      rightCount: 1,
      operation: '٣ + ١ = ٤',
      resultText: '٣ فواكه مع فاكهة واحدة تساوي ٤ فواكه.',
    ),
    _MathLesson(
      title: 'نجمع سيارات',
      explanation: 'يمكننا استخدام المركبات لفهم الجمع بطريقة سهلة.',
      leftEmoji: '🚗',
      leftCount: 2,
      rightEmoji: '🚗',
      rightCount: 3,
      operation: '٢ + ٣ = ٥',
      resultText: 'سيارتان مع ٣ سيارات تساوي ٥ سيارات.',
    ),
    _MathLesson(
      title: 'مثال بسيط',
      explanation: 'كلما أضفنا أشياء جديدة، يصبح العدد أكبر.',
      leftEmoji: '🐱',
      leftCount: 3,
      rightEmoji: '🐱',
      rightCount: 2,
      operation: '٣ + ٢ = ٥',
      resultText: '٣ قطط مع قطتين تساوي ٥ قطط.',
    ),
    _MathLesson(
      title: 'نجمع كرات',
      explanation: 'نجمع العددين معًا لنجد العدد الكلي.',
      leftEmoji: '⚽',
      leftCount: 4,
      rightEmoji: '⚽',
      rightCount: 1,
      operation: '٤ + ١ = ٥',
      resultText: '٤ كرات مع كرة واحدة تساوي ٥ كرات.',
    ),
    _MathLesson(
      title: 'نجمع حافلات',
      explanation: 'ضع المجموعتين معًا، ثم عد كل الأشياء.',
      leftEmoji: '🚌',
      leftCount: 3,
      rightEmoji: '🚌',
      rightCount: 3,
      operation: '٣ + ٣ = ٦',
      resultText: '٣ حافلات مع ٣ حافلات تساوي ٦ حافلات.',
    ),
    _MathLesson(
      title: 'نجمع أرانب',
      explanation: 'الجمع يجعل العدد يزداد عندما نضيف مجموعة جديدة.',
      leftEmoji: '🐰',
      leftCount: 4,
      rightEmoji: '🐰',
      rightCount: 2,
      operation: '٤ + ٢ = ٦',
      resultText: '٤ أرانب مع أرنبين تساوي ٦ أرانب.',
    ),
    _MathLesson(
      title: 'هيا نجمع!',
      explanation: 'تذكّر: علامة + تعني أننا نضيف الأشياء معًا.',
      leftEmoji: '🍓',
      leftCount: 5,
      rightEmoji: '🍓',
      rightCount: 2,
      operation: '٥ + ٢ = ٧',
      resultText: '٥ فراولات مع فراولتين تساويان ٧ فراولات.',
    ),
  ];

  static const _subtractionLessons = <_MathLesson>[
    _MathLesson(
      title: 'ما هو الطرح؟',
      explanation: 'الطرح يعني أن نأخذ بعض الأشياء من مجموعة لنعرف كم بقي.',
      leftEmoji: '🍎',
      leftCount: 2,
      rightEmoji: '🍎',
      rightCount: 1,
      operation: '٢ − ١ = ١',
      resultText: 'لدينا تفاحتان، أخذنا تفاحة واحدة، فبقيت تفاحة واحدة.',
    ),
    _MathLesson(
      title: 'نطرح تفاحات',
      explanation: 'نبدأ بالعدد الأول، ثم نأخذ منه العدد الثاني.',
      leftEmoji: '🍎',
      leftCount: 3,
      rightEmoji: '🍎',
      rightCount: 1,
      operation: '٣ − ١ = ٢',
      resultText: 'لدينا ٣ تفاحات، أخذنا تفاحة واحدة، فبقيت تفاحتان.',
    ),
    _MathLesson(
      title: 'نطرح حيوانات',
      explanation: 'عندما تبتعد بعض الحيوانات، نستخدم الطرح لمعرفة ما بقي.',
      leftEmoji: '🐶',
      leftCount: 4,
      rightEmoji: '🐶',
      rightCount: 1,
      operation: '٤ − ١ = ٣',
      resultText: 'لدينا ٤ كلاب، ابتعد كلب واحد، فبقيت ٣ كلاب.',
    ),
    _MathLesson(
      title: 'نطرح قططًا',
      explanation: 'نأخذ جزءًا من المجموعة، فيصبح العدد أقل.',
      leftEmoji: '🐱',
      leftCount: 5,
      rightEmoji: '🐱',
      rightCount: 2,
      operation: '٥ − ٢ = ٣',
      resultText: 'لدينا ٥ قطط، أخذنا قطتين، فبقيت ٣ قطط.',
    ),
    _MathLesson(
      title: 'نطرح سيارات',
      explanation: 'عندما تغادر بعض السيارات، نطرح عددها من العدد الكلي.',
      leftEmoji: '🚗',
      leftCount: 5,
      rightEmoji: '🚗',
      rightCount: 1,
      operation: '٥ − ١ = ٤',
      resultText: 'لدينا ٥ سيارات، غادرت سيارة واحدة، فبقيت ٤ سيارات.',
    ),
    _MathLesson(
      title: 'مثال بسيط',
      explanation: 'كلما أخذنا أشياء من المجموعة، يقل العدد.',
      leftEmoji: '🍌',
      leftCount: 5,
      rightEmoji: '🍌',
      rightCount: 2,
      operation: '٥ − ٢ = ٣',
      resultText: 'لدينا ٥ موزات، أخذنا موزتين، فبقيت ٣ موزات.',
    ),
    _MathLesson(
      title: 'نطرح كرات',
      explanation: 'عدّ الكرات أولًا، ثم أزل العدد المطلوب منها.',
      leftEmoji: '⚽',
      leftCount: 6,
      rightEmoji: '⚽',
      rightCount: 1,
      operation: '٦ − ١ = ٥',
      resultText: 'لدينا ٦ كرات، أخذنا كرة واحدة، فبقيت ٥ كرات.',
    ),
    _MathLesson(
      title: 'نطرح حافلات',
      explanation: 'الطرح يساعدنا على معرفة عدد الأشياء التي بقيت.',
      leftEmoji: '🚌',
      leftCount: 6,
      rightEmoji: '🚌',
      rightCount: 2,
      operation: '٦ − ٢ = ٤',
      resultText: 'لدينا ٦ حافلات، غادرت حافلتان، فبقيت ٤ حافلات.',
    ),
    _MathLesson(
      title: 'نطرح أرانب',
      explanation: 'نأخذ جزءًا من المجموعة ونعد ما تبقى.',
      leftEmoji: '🐰',
      leftCount: 7,
      rightEmoji: '🐰',
      rightCount: 2,
      operation: '٧ − ٢ = ٥',
      resultText: 'لدينا ٧ أرانب، ابتعد أرنبان، فبقيت ٥ أرانب.',
    ),
    _MathLesson(
      title: 'هيا نطرح!',
      explanation: 'تذكّر: علامة − تعني أننا نزيل أشياء من المجموعة.',
      leftEmoji: '🍓',
      leftCount: 7,
      rightEmoji: '🍓',
      rightCount: 3,
      operation: '٧ − ٣ = ٤',
      resultText: 'لدينا ٧ فراولات، أخذنا ٣ فراولات، فبقيت ٤ فراولات.',
    ),
  ];

  List<_MathLesson> get _lessons => widget.isAddition ? _additionLessons : _subtractionLessons;

  _MathLesson get _lesson => _lessons[_page];

  void _speakLesson() {
    final action = widget.isAddition ? 'الجمع' : 'الطرح';
    VoiceService.arabic(
      '${_lesson.title}. ${_lesson.explanation} ${_lesson.operation}. ${_lesson.resultText} تعلم $action خطوة بخطوة.',
    );
  }

  void _previous() {
    if (_page == 0) return;
    setState(() => _page--);
    _speakLesson();
  }

  void _next() {
    if (_page == _lessons.length - 1) return;
    setState(() => _page++);
    _speakLesson();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakLesson());
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isAddition ? 'تعلم الجمع' : 'تعلم الطرح';
    final accent = widget.isAddition ? const Color(0xFF00C853) : const Color(0xFFFF6B35);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Text(
                  '${arNum(_page + 1)} / ${arNum(_lessons.length)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: accent),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              children: [
                                Text(
                                  _lesson.title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900, color: accent),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  _lesson.explanation,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 20, height: 1.5, fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 18),
                                _buildGroups(),
                                const SizedBox(height: 16),
                                Text(
                                  _lesson.operation,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: accent),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  _lesson.resultText,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 19, height: 1.5, fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 10),
                                IconButton.filled(
                                  onPressed: _speakLesson,
                                  icon: const Icon(Icons.volume_up_rounded),
                                  tooltip: 'استمع للشرح',
                                ),
                              ],
                            ),
                          ),
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
                        onTap: _previous,
                        color: _page == 0 ? Colors.grey : accent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_back_rounded, color: Colors.white),
                            SizedBox(width: 7),
                            Text('السابق', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Button3D(
                        onTap: _next,
                        color: _page == _lessons.length - 1 ? Colors.grey : accent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('التالي', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: Colors.white)),
                            SizedBox(width: 7),
                            Icon(Icons.arrow_forward_rounded, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroups() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: _emojiGroup(_lesson.leftEmoji, _lesson.leftCount)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(widget.isAddition ? '➕' : '−', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
        ),
        Expanded(child: _emojiGroup(_lesson.rightEmoji, _lesson.rightCount)),
      ],
    );
  }

  Widget _emojiGroup(String emoji, int count) {
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 4,
          runSpacing: 4,
          children: List.generate(count, (_) => Text(emoji, style: const TextStyle(fontSize: 38))),
        ),
        const SizedBox(height: 5),
        Text(arNum(count), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
      ],
    );
  }
}

class _MathLesson {
  final String title;
  final String explanation;
  final String leftEmoji;
  final int leftCount;
  final String rightEmoji;
  final int rightCount;
  final String operation;
  final String resultText;

  const _MathLesson({
    required this.title,
    required this.explanation,
    required this.leftEmoji,
    required this.leftCount,
    required this.rightEmoji,
    required this.rightCount,
    required this.operation,
    required this.resultText,
  });
}
