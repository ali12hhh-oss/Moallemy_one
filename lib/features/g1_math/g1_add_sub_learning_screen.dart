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
      leftCount: 2,
      rightEmoji: '🍎',
      rightCount: 1,
      operation: '٢ + ١ = ٣',
      resultText: 'لدينا تفاحتان، أضفنا تفاحة واحدة، فأصبح لدينا ٣ تفاحات.',
    ),
    _MathLesson(
      title: 'نجمع خطوة بخطوة',
      explanation: 'ابدأ بالعدد الأول، ثم أضف إليه العدد الثاني.',
      leftEmoji: '🐶',
      leftCount: 3,
      rightEmoji: '🐶',
      rightCount: 2,
      operation: '٣ + ٢ = ٥',
      resultText: 'ثلاثة كلاب مع كلبين آخرين يساوون خمسة كلاب.',
    ),
    _MathLesson(
      title: 'الجمع بالمركبات',
      explanation: 'يمكننا الجمع باستخدام الأشياء التي نراها كل يوم.',
      leftEmoji: '🚗',
      leftCount: 2,
      rightEmoji: '🚌',
      rightCount: 2,
      operation: '٢ + ٢ = ٤',
      resultText: 'سيارتان مع حافلتين تساوي ٤ مركبات.',
    ),
    _MathLesson(
      title: 'مثال آخر',
      explanation: 'كلما أضفنا مجموعة جديدة، يزداد العدد.',
      leftEmoji: '🍌',
      leftCount: 4,
      rightEmoji: '🍓',
      rightCount: 3,
      operation: '٤ + ٣ = ٧',
      resultText: 'أربع موزات مع ثلاث فراولات تساوي ٧ فواكه.',
    ),
    _MathLesson(
      title: 'هيا نجمع!',
      explanation: 'تذكّر: علامة + تعني أننا نضيف ونضم الأشياء معًا.',
      leftEmoji: '🐰',
      leftCount: 5,
      rightEmoji: '🐰',
      rightCount: 3,
      operation: '٥ + ٣ = ٨',
      resultText: 'خمسة أرانب مع ثلاثة أرانب تساوي ٨ أرانب.',
    ),
  ];

  static const _subtractionLessons = <_MathLesson>[
    _MathLesson(
      title: 'ما هو الطرح؟',
      explanation: 'الطرح يعني أن نأخذ بعض الأشياء من مجموعة لنعرف كم بقي.',
      leftEmoji: '🍎',
      leftCount: 3,
      rightEmoji: '🍎',
      rightCount: 1,
      operation: '٣ − ١ = ٢',
      resultText: 'لدينا ٣ تفاحات، أخذنا تفاحة واحدة، فبقيت تفاحتان.',
    ),
    _MathLesson(
      title: 'نطرح خطوة بخطوة',
      explanation: 'ابدأ بالعدد الأول، ثم أزل منه العدد الثاني.',
      leftEmoji: '🐱',
      leftCount: 5,
      rightEmoji: '🐱',
      rightCount: 2,
      operation: '٥ − ٢ = ٣',
      resultText: 'خمسة قطط، أخذنا قطتين، فبقيت ٣ قطط.',
    ),
    _MathLesson(
      title: 'الطرح بالمركبات',
      explanation: 'عندما تبتعد بعض المركبات، نستخدم الطرح لمعرفة ما بقي.',
      leftEmoji: '🚗',
      leftCount: 6,
      rightEmoji: '🚗',
      rightCount: 2,
      operation: '٦ − ٢ = ٤',
      resultText: 'لدينا ٦ سيارات، غادرت سيارتان، فبقيت ٤ سيارات.',
    ),
    _MathLesson(
      title: 'مثال آخر',
      explanation: 'كلما أخذنا أشياء من المجموعة، يقل العدد.',
      leftEmoji: '🍓',
      leftCount: 7,
      rightEmoji: '🍓',
      rightCount: 3,
      operation: '٧ − ٣ = ٤',
      resultText: 'سبع فراولات، أخذنا ثلاثًا، فبقيت ٤ فراولات.',
    ),
    _MathLesson(
      title: 'هيا نطرح!',
      explanation: 'تذكّر: علامة − تعني أننا نزيل أشياء من المجموعة.',
      leftEmoji: '🐰',
      leftCount: 8,
      rightEmoji: '🐰',
      rightCount: 3,
      operation: '٨ − ٣ = ٥',
      resultText: 'ثمانية أرانب، ابتعدت ثلاثة، فبقيت ٥ أرانب.',
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
