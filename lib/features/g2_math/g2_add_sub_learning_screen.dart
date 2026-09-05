import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../widgets/button_3d.dart';

/// صفحة تعلم الجمع والطرح من مرتبتين (آحاد وعشرات) بالطريقتين الأفقية والعمودية.
class G2AddSubLearningScreen extends StatefulWidget {
  final bool isAddition;

  const G2AddSubLearningScreen({super.key, required this.isAddition});

  @override
  State<G2AddSubLearningScreen> createState() => _G2AddSubLearningScreenState();
}

class _G2AddSubLearningScreenState extends State<G2AddSubLearningScreen> {
  int _page = 0;

  static const _additionLessons = <_TwoDigitLesson>[
    _TwoDigitLesson(
      title: 'نبدأ بالآحاد ثم العشرات',
      explanation: 'في العدد ذي المرتبتين، ننظر إلى الآحاد أولًا ثم العشرات.',
      a: 12,
      b: 23,
      result: 35,
      horizontalSteps: ['١٢ + ٢٣', 'الآحاد: ٢ + ٣ = ٥', 'العشرات: ١ + ٢ = ٣', 'الناتج: ٣٥'],
      verticalSteps: ['نكتب الآحاد تحت الآحاد والعشرات تحت العشرات.', '٢ + ٣ = ٥ آحاد.', '١ + ٢ = ٣ عشرات.', 'إذن ١٢ + ٢٣ = ٣٥.'],
      carry: null,
    ),
    _TwoDigitLesson(
      title: 'مثال آخر بدون حمل',
      explanation: 'إذا كان مجموع الآحاد أقل من ١٠، نكتب الناتج مباشرة في الآحاد.',
      a: 24,
      b: 15,
      result: 39,
      horizontalSteps: ['٢٤ + ١٥', 'الآحاد: ٤ + ٥ = ٩', 'العشرات: ٢ + ١ = ٣', 'الناتج: ٣٩'],
      verticalSteps: ['٤ + ٥ = ٩ آحاد، فلا يوجد حمل.', '٢ + ١ = ٣ عشرات.', 'الناتج العمودي هو ٣٩.'],
      carry: null,
    ),
    _TwoDigitLesson(
      title: 'الجمع مع حمل واحد',
      explanation: 'إذا أصبح مجموع الآحاد ١٠ أو أكثر، نكتب الآحاد ونحمل عشرة إلى العشرات.',
      a: 17,
      b: 25,
      result: 42,
      horizontalSteps: ['١٧ + ٢٥', 'الآحاد: ٧ + ٥ = ١٢', 'نكتب ٢ في الآحاد ونحمل ١ عشرة', 'العشرات: ١ + ٢ + ١ = ٤', 'الناتج: ٤٢'],
      verticalSteps: ['٧ + ٥ = ١٢؛ نكتب ٢ ونحمل ١.', '١ + ٢ + ١ الحمل = ٤ عشرات.', 'إذن ١٧ + ٢٥ = ٤٢.'],
      carry: '١ حمل',
    ),
    _TwoDigitLesson(
      title: 'نوضح الحمل بالتفاح',
      explanation: '١٠ آحاد يمكن تحويلها إلى عشرة واحدة، وهذه العشرة نضعها مع العشرات.',
      a: 18,
      b: 14,
      result: 32,
      horizontalSteps: ['١٨ + ١٤', '٨ + ٤ = ١٢', '١٢ آحاد = ٢ آحاد + عشرة واحدة', 'العشرات: ١ + ١ + ١ = ٣', 'الناتج: ٣٢'],
      verticalSteps: ['🍎🍎🍎🍎🍎🍎🍎🍎 + 🍎🍎🍎🍎', '٨ + ٤ = ١٢؛ نحتفظ بـ٢ ونحوّل ١٠ إلى عشرة.', 'العشرات تصبح ٣.', 'الناتج ٣٢.'],
      carry: '١ عشرة محمولة',
    ),
    _TwoDigitLesson(
      title: 'الجمع بالمركبات',
      explanation: 'نجمع الآحاد مع الآحاد، ثم العشرات مع العشرات، ولا نخلط بين المرتبتين.',
      a: 26,
      b: 17,
      result: 43,
      horizontalSteps: ['٢٦ + ١٧', '٦ + ٧ = ١٣', 'نكتب ٣ ونحمل ١', '٢ + ١ + ١ = ٤', 'الناتج: ٤٣'],
      verticalSteps: ['🚗🚗🚗🚗🚗🚗 + 🚗🚗🚗🚗🚗🚗🚗', 'الآحاد: ٦ + ٧ = ١٣؛ نكتب ٣ ونحمل ١.', 'العشرات: ٢ + ١ + الحمل = ٤.', 'الناتج ٤٣ مركبة.'],
      carry: '١ حمل',
    ),
    _TwoDigitLesson(
      title: 'الجمع عندما يصبح الناتج ٥٠',
      explanation: 'نستمر بالطريقة نفسها: آحاد، ثم العشرات مع الحمل.',
      a: 28,
      b: 22,
      result: 50,
      horizontalSteps: ['٢٨ + ٢٢', '٨ + ٢ = ١٠', 'نكتب ٠ ونحمل ١', '٢ + ٢ + ١ = ٥', 'الناتج: ٥٠'],
      verticalSteps: ['٨ + ٢ = ١٠؛ نكتب صفر الآحاد ونحمل عشرة واحدة.', '٢ + ٢ + ١ = ٥ عشرات.', 'الناتج ٥٠.'],
      carry: '١ حمل',
    ),
    _TwoDigitLesson(
      title: 'تذكّر ترتيب المراتب',
      explanation: 'في الطريقة العمودية يجب أن تكون الآحاد فوق الآحاد، والعشرات فوق العشرات.',
      a: 31,
      b: 28,
      result: 59,
      horizontalSteps: ['٣١ + ٢٨', '١ + ٨ = ٩', '٣ + ٢ = ٥', 'الناتج: ٥٩'],
      verticalSteps: ['نضع ١ فوق ٨ في خانة الآحاد.', 'نضع ٣ فوق ٢ في خانة العشرات.', '١ + ٨ = ٩، ثم ٣ + ٢ = ٥.', 'الناتج ٥٩.'],
      carry: null,
    ),
    _TwoDigitLesson(
      title: 'مثال مع حمل مرة أخرى',
      explanation: 'الحمل ليس خطأ؛ هو طريقة لتحويل ١٠ آحاد إلى عشرة واحدة.',
      a: 36,
      b: 27,
      result: 63,
      horizontalSteps: ['٣٦ + ٢٧', '٦ + ٧ = ١٣', 'نكتب ٣ ونحمل ١', '٣ + ٢ + ١ = ٦', 'الناتج: ٦٣'],
      verticalSteps: ['٦ + ٧ = ١٣؛ نكتب ٣ ونحمل ١.', '٣ + ٢ + ١ = ٦ عشرات.', 'إذن الناتج ٦٣.'],
      carry: '١ حمل',
    ),
    _TwoDigitLesson(
      title: 'نحل خطوة خطوة',
      explanation: 'لا تستعجل. افصل الآحاد عن العشرات ثم اجمع كل مرتبة وحدها.',
      a: 42,
      b: 16,
      result: 58,
      horizontalSteps: ['٤٢ + ١٦', 'الآحاد: ٢ + ٦ = ٨', 'العشرات: ٤ + ١ = ٥', 'الناتج: ٥٨'],
      verticalSteps: ['٢ + ٦ = ٨ آحاد.', '٤ + ١ = ٥ عشرات.', 'الناتج ٥٨.'],
      carry: null,
    ),
    _TwoDigitLesson(
      title: 'أحسنت! مثال شامل',
      explanation: 'الآن طبّق القاعدة كاملة: الآحاد أولًا، ثم العشرات، والحمل إذا احتجنا إليه.',
      a: 47,
      b: 25,
      result: 72,
      horizontalSteps: ['٤٧ + ٢٥', '٧ + ٥ = ١٢', 'نكتب ٢ ونحمل ١', '٤ + ٢ + ١ = ٧', 'الناتج: ٧٢'],
      verticalSteps: ['٧ + ٥ = ١٢؛ نكتب ٢ ونحمل ١.', '٤ + ٢ + ١ = ٧ عشرات.', 'إذن ٤٧ + ٢٥ = ٧٢.'],
      carry: '١ حمل',
    ),
  ];

  static const _subtractionLessons = <_TwoDigitLesson>[
    _TwoDigitLesson(
      title: 'نبدأ بالآحاد ثم العشرات',
      explanation: 'في الطرح نطرح الآحاد من الآحاد، ثم العشرات من العشرات.',
      a: 35,
      b: 12,
      result: 23,
      horizontalSteps: ['٣٥ − ١٢', 'الآحاد: ٥ − ٢ = ٣', 'العشرات: ٣ − ١ = ٢', 'الناتج: ٢٣'],
      verticalSteps: ['نكتب الآحاد تحت الآحاد والعشرات تحت العشرات.', '٥ − ٢ = ٣ آحاد.', '٣ − ١ = ٢ عشرات.', 'إذن ٣٥ − ١٢ = ٢٣.'],
      carry: null,
    ),
    _TwoDigitLesson(
      title: 'مثال آخر بدون اقتراض',
      explanation: 'إذا كان الآحاد في العدد الأول أكبر أو مساويًا للآحاد المطروح، نطرح مباشرة.',
      a: 48,
      b: 25,
      result: 23,
      horizontalSteps: ['٤٨ − ٢٥', '٨ − ٥ = ٣', '٤ − ٢ = ٢', 'الناتج: ٢٣'],
      verticalSteps: ['٨ − ٥ = ٣ آحاد.', '٤ − ٢ = ٢ عشرات.', 'الناتج ٢٣.'],
      carry: null,
    ),
    _TwoDigitLesson(
      title: 'ما هو الاقتراض؟',
      explanation: 'إذا لم نستطع طرح الآحاد، نأخذ عشرة واحدة من العشرات ونحوّلها إلى ١٠ آحاد.',
      a: 32,
      b: 15,
      result: 17,
      horizontalSteps: ['٣٢ − ١٥', '٢ لا تكفي لطرح ٥', 'نقترض عشرة من ٣ عشرات فتصبح ٢ عشرات', 'تصبح الآحاد ١٢', '١٢ − ٥ = ٧، ثم ٢ − ١ = ١', 'الناتج: ١٧'],
      verticalSteps: ['الآحاد: ٢ − ٥ لا يمكن.', 'نقترض عشرة من العشرات: ٣ عشرات تصبح ٢، و٢ آحاد تصبح ١٢.', '١٢ − ٥ = ٧.', '٢ − ١ = ١ عشرة.', 'الناتج ١٧.'],
      carry: '١ عشرة مُقترضة',
    ),
    _TwoDigitLesson(
      title: 'نشرح الاقتراض بالفواكه',
      explanation: 'العشرة الواحدة يمكن تحويلها إلى ١٠ فواكه في خانة الآحاد.',
      a: 41,
      b: 23,
      result: 18,
      horizontalSteps: ['٤١ − ٢٣', '١ لا تكفي لطرح ٣', 'نحوّل عشرة واحدة إلى ١٠ آحاد: تصبح ١١', '١١ − ٣ = ٨', '٣ − ٢ = ١', 'الناتج: ١٨'],
      verticalSteps: ['🍎 ١ آحاد لا تكفي لطرح ٣.', 'نأخذ 🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎 من عشرة ونضعها مع الآحاد.', '١١ − ٣ = ٨.', 'بعد الاقتراض بقيت ٣ عشرات؛ ٣ − ٢ = ١.', 'الناتج ١٨.'],
      carry: '١ عشرة مُقترضة',
    ),
    _TwoDigitLesson(
      title: 'الطرح بالمركبات',
      explanation: 'نستخدم الاقتراض عندما لا يكفي عدد الآحاد في المركبة الأولى.',
      a: 52,
      b: 27,
      result: 25,
      horizontalSteps: ['٥٢ − ٢٧', '٢ لا تكفي لطرح ٧', 'نقترض عشرة فتصبح ١٢ آحاد وتبقى ٤ عشرات', '١٢ − ٧ = ٥', '٤ − ٢ = ٢', 'الناتج: ٢٥'],
      verticalSteps: ['الآحاد: ٢ − ٧ لا يمكن.', 'نقترض عشرة: ٥ تصبح ٤ عشرات، و٢ تصبح ١٢ آحاد.', '١٢ − ٧ = ٥.', '٤ − ٢ = ٢.', 'الناتج ٢٥ مركبة.'],
      carry: '١ عشرة مُقترضة',
    ),
    _TwoDigitLesson(
      title: 'نطرح ونراقب المراتب',
      explanation: 'لا نطرح العشرات من الآحاد. كل مرتبة لها مكانها.',
      a: 63,
      b: 21,
      result: 42,
      horizontalSteps: ['٦٣ − ٢١', '٣ − ١ = ٢ آحاد', '٦ − ٢ = ٤ عشرات', 'الناتج: ٤٢'],
      verticalSteps: ['٣ − ١ = ٢.', '٦ − ٢ = ٤.', 'الناتج ٤٢.'],
      carry: null,
    ),
    _TwoDigitLesson(
      title: 'اقتراض مرة أخرى',
      explanation: 'نستطيع استخدام الاقتراض كلما كان الآحاد في العدد الأول أصغر من الآحاد المطروح.',
      a: 54,
      b: 18,
      result: 36,
      horizontalSteps: ['٥٤ − ١٨', '٤ لا تكفي لطرح ٨', 'نقترض عشرة: ٤ تصبح ١٤، و٥ عشرات تصبح ٤', '١٤ − ٨ = ٦', '٤ − ١ = ٣', 'الناتج: ٣٦'],
      verticalSteps: ['٤ − ٨ لا يمكن، فنقترض عشرة.', 'تصبح ٤ آحاد = ١٤ آحاد، وتبقى ٤ عشرات.', '١٤ − ٨ = ٦.', '٤ − ١ = ٣.', 'الناتج ٣٦.'],
      carry: '١ عشرة مُقترضة',
    ),
    _TwoDigitLesson(
      title: 'مثال سهل للتثبيت',
      explanation: 'رتّب العددين جيدًا، ثم ابدأ دائمًا من الآحاد.',
      a: 76,
      b: 34,
      result: 42,
      horizontalSteps: ['٧٦ − ٣٤', '٦ − ٤ = ٢', '٧ − ٣ = ٤', 'الناتج: ٤٢'],
      verticalSteps: ['٦ − ٤ = ٢ آحاد.', '٧ − ٣ = ٤ عشرات.', 'الناتج ٤٢.'],
      carry: null,
    ),
    _TwoDigitLesson(
      title: 'نراجع الاقتراض خطوة بخطوة',
      explanation: 'تذكّر: عند الاقتراض نأخذ عشرة من العشرات ونضيفها إلى الآحاد.',
      a: 70,
      b: 24,
      result: 46,
      horizontalSteps: ['٧٠ − ٢٤', '٠ لا تكفي لطرح ٤', 'نقترض عشرة: تصبح الآحاد ١٠ وتبقى ٦ عشرات', '١٠ − ٤ = ٦', '٦ − ٢ = ٤', 'الناتج: ٤٦'],
      verticalSteps: ['٠ − ٤ لا يمكن.', 'نقترض عشرة من ٧ عشرات: تصبح ٦ عشرات، والآحاد تصبح ١٠.', '١٠ − ٤ = ٦.', '٦ − ٢ = ٤.', 'الناتج ٤٦.'],
      carry: '١ عشرة مُقترضة',
    ),
    _TwoDigitLesson(
      title: 'أحسنت! مثال شامل',
      explanation: 'طبّق القاعدة كاملة: الآحاد أولًا، والاقتراض عند الحاجة، ثم العشرات.',
      a: 82,
      b: 37,
      result: 45,
      horizontalSteps: ['٨٢ − ٣٧', '٢ لا تكفي لطرح ٧', 'نقترض عشرة: ٢ تصبح ١٢ و٨ تصبح ٧', '١٢ − ٧ = ٥', '٧ − ٣ = ٤', 'الناتج: ٤٥'],
      verticalSteps: ['٢ − ٧ لا يمكن، فنقترض عشرة.', 'تصبح الآحاد ١٢، وتصبح العشرات ٧.', '١٢ − ٧ = ٥ آحاد.', '٧ − ٣ = ٤ عشرات.', 'إذن ٨٢ − ٣٧ = ٤٥.'],
      carry: '١ عشرة مُقترضة',
    ),
  ];

  List<_TwoDigitLesson> get _lessons => widget.isAddition ? _additionLessons : _subtractionLessons;
  _TwoDigitLesson get _lesson => _lessons[_page];

  void _speakLesson() {
    final operation = widget.isAddition ? 'الجمع' : 'الطرح';
    final horizontal = _lesson.horizontalSteps.join(' ');
    final vertical = _lesson.verticalSteps.join(' ');
    VoiceService.arabic(
      '${_lesson.title}. ${_lesson.explanation} ${_lesson.a} ${widget.isAddition ? 'زائد' : 'ناقص'} ${_lesson.b} يساوي ${_lesson.result}. $operation أفقيًا: $horizontal. $operation عموديًا: $vertical. ${_lesson.carry ?? ''}',
    );
  }

  void _next() {
    if (_page == _lessons.length - 1) return;
    setState(() => _page++);
    _speakLesson();
  }

  void _previous() {
    if (_page == 0) return;
    setState(() => _page--);
    _speakLesson();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakLesson());
  }

  @override
  Widget build(BuildContext context) {
    final addition = widget.isAddition;
    final accent = addition ? const Color(0xFF00C853) : const Color(0xFFFF6B35);
    final op = addition ? '+' : '−';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            addition ? 'تعلم الجمع من مرتبتين' : 'تعلم الطرح من مرتبتين',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'الآحاد والعشرات',
                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: accent),
                      ),
                    ),
                    Text(
                      '${arNum(_page + 1)} / ${arNum(_lessons.length)}',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: Card(
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
                              style: const TextStyle(fontSize: 19, height: 1.5, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 14),
                            _buildPlaceValueHeader(accent),
                            const SizedBox(height: 12),
                            _buildHorizontalExample(op, accent),
                            const SizedBox(height: 16),
                            _buildVerticalExample(op, accent),
                            if (_lesson.carry != null) ...[
                              const SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: accent.withValues(alpha: .12),
                                  border: Border.all(color: accent.withValues(alpha: .45)),
                                ),
                                child: Text(
                                  addition ? '💡 التوضيح: ${_lesson.carry} — كل ١٠ آحاد تتحول إلى عشرة واحدة.' : '💡 التوضيح: ${_lesson.carry} — نأخذ عشرة من العشرات ونضيفها إلى الآحاد.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: accent),
                                ),
                              ),
                            ],
                            const SizedBox(height: 14),
                            Text(
                              'الإجابة: ${arNum(_lesson.result)}',
                              style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900, color: accent),
                            ),
                            const SizedBox(height: 8),
                            IconButton.filled(
                              onPressed: _speakLesson,
                              icon: const Icon(Icons.volume_up_rounded),
                              tooltip: 'استمع للشرح',
                            ),
                          ],
                        ),
                      ),
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
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_back_rounded, color: Colors.white),
                            SizedBox(width: 6),
                            Text('السابق', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Button3D(
                        onTap: _next,
                        color: _page == _lessons.length - 1 ? Colors.grey : accent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('التالي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                            SizedBox(width: 6),
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

  Widget _buildPlaceValueHeader(Color accent) {
    return Row(
      children: [
        Expanded(child: _placeValueChip('آحاد', accent)),
        const SizedBox(width: 8),
        Expanded(child: _placeValueChip('عشرات', accent)),
      ],
    );
  }

  Widget _placeValueChip(String text, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: accent.withValues(alpha: .10),
      ),
      child: Text(text, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w900, color: accent)),
    );
  }

  Widget _buildHorizontalExample(String op, Color accent) {
    return Column(
      children: [
        const Text('الطريقة الأفقية', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
        const SizedBox(height: 7),
        Text(
          '${arNum(_lesson.a)} $op ${arNum(_lesson.b)} = ${arNum(_lesson.result)}',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: accent),
        ),
        const SizedBox(height: 8),
        ..._lesson.horizontalSteps.map(
          (step) => Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text('• $step', style: const TextStyle(fontSize: 16, height: 1.35, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalExample(String op, Color accent) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: .35), width: 2),
      ),
      child: Column(
        children: [
          const Text('الطريقة العمودية', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(arNum(_lesson.a), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(op, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                    const SizedBox(width: 8),
                    Text(arNum(_lesson.b), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
                  ],
                ),
                Divider(thickness: 3, color: accent),
                Text(arNum(_lesson.result), style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: accent)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ..._lesson.verticalSteps.map(
            (step) => Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text('✓ $step', style: const TextStyle(fontSize: 16, height: 1.35, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TwoDigitLesson {
  final String title;
  final String explanation;
  final int a;
  final int b;
  final int result;
  final List<String> horizontalSteps;
  final List<String> verticalSteps;
  final String? carry;

  const _TwoDigitLesson({
    required this.title,
    required this.explanation,
    required this.a,
    required this.b,
    required this.result,
    required this.horizontalSteps,
    required this.verticalSteps,
    required this.carry,
  });
}
