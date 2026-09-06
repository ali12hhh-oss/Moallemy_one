import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../widgets/button_3d.dart';

/// تعلم الجمع والطرح للصف الثاني: أمثلة واضحة وصحيحة ومناسبة للشرح الصوتي.
class G2AddSubLearningScreen extends StatefulWidget {
  final bool isAddition;
  const G2AddSubLearningScreen({super.key, required this.isAddition});

  @override
  State<G2AddSubLearningScreen> createState() => _G2AddSubLearningScreenState();
}

class _G2AddSubLearningScreenState extends State<G2AddSubLearningScreen> {
  int _page = 0;

  static const _addition = <_Lesson>[
    _Lesson('الجمع بدون حمل', 12, 23, 35, null,
        'نجمع الآحاد أولًا: اثنان زائد ثلاثة يساوي خمسة آحاد. ثم نجمع العشرات: عشرة زائد عشرون يساوي ثلاثين. إذن الناتج خمسة وثلاثون.',
        ['الآحاد: ٢ + ٣ = ٥.', 'العشرات: ١ + ٢ = ٣.', 'الناتج: ٣٥.']),
    _Lesson('مثال آخر بدون حمل', 24, 15, 39, null,
        'أربعة آحاد زائد خمسة آحاد تساوي تسعة آحاد. ثم نجمع العشرات: عشرتان زائد عشرة واحدة تساوي ثلاث عشرات. الناتج تسعة وثلاثون.',
        ['٤ + ٥ = ٩ آحاد.', '٢ + ١ = ٣ عشرات.', 'الناتج: ٣٩.']),
    _Lesson('الجمع مع حمل واحد', 17, 25, 42, '١',
        'سبعة زائد خمسة يساوي اثني عشر آحادًا. نكتب اثنين في الآحاد، ونحوّل عشرة آحاد إلى عشرة واحدة، فنحمل واحدًا إلى العشرات. ثم واحد زائد اثنين زائد واحد يساوي أربعة عشرات. الناتج اثنان وأربعون.',
        ['٧ + ٥ = ١٢ آحادًا.', 'نكتب ٢ آحادًا ونحمل ١ عشرة.', '١ + ٢ + ١ = ٤ عشرات.', 'الناتج: ٤٢.']),
    _Lesson('الحمل باستخدام التفاح', 18, 14, 32, '١',
        'لدينا ثمانية تفاحات وأضفنا أربعة تفاحات، فأصبح لدينا اثنا عشر تفاحة. نحتفظ باثنتين في الآحاد، ونحوّل عشر تفاحات إلى عشرة واحدة نضيفها إلى العشرات. لذلك الناتج اثنان وثلاثون تفاحة.',
        ['٨ + ٤ = ١٢.', '١٢ = ٢ آحاد + ١ عشرة.', '١ + ١ + ١ = ٣ عشرات.', 'الناتج: ٣٢ تفاحة.']),
    _Lesson('الحمل باستخدام السيارات', 26, 17, 43, '١',
        'لدينا ست وعشرون سيارة وأضفنا سبع عشرة سيارة. ستة زائد سبعة يساوي ثلاثة عشر، فنكتب ثلاثة ونحمل عشرة واحدة. ثم اثنتان زائد واحدة زائد عشرة الحمل تساوي أربع عشرات. الناتج ثلاث وأربعون سيارة.',
        ['٦ + ٧ = ١٣.', 'نكتب ٣ ونحمل ١ عشرة.', '٢ + ١ + ١ = ٤ عشرات.', 'الناتج: ٤٣ سيارة.']),
    _Lesson('عندما يصبح الناتج خمسين', 28, 22, 50, '١',
        'ثمانية زائد اثنين يساوي عشرة آحاد كاملة. نكتب صفرًا في الآحاد ونحوّل العشرة آحاد إلى عشرة واحدة. ثم اثنتان زائد اثنتان زائد عشرة الحمل تساوي خمس عشرات. الناتج خمسون.',
        ['٨ + ٢ = ١٠.', 'نكتب ٠ ونحمل ١ عشرة.', '٢ + ٢ + ١ = ٥ عشرات.', 'الناتج: ٥٠.']),
    _Lesson('حمل مرة أخرى', 36, 27, 63, '١',
        'ستة زائد سبعة يساوي ثلاثة عشر. نكتب ثلاثة ونحمل عشرة واحدة. ثم ثلاث عشرات زائد عشرتين زائد عشرة الحمل تساوي ست عشرات. الناتج ثلاثة وستون.',
        ['٦ + ٧ = ١٣.', 'نكتب ٣ ونحمل ١ عشرة.', '٣ + ٢ + ١ = ٦ عشرات.', 'الناتج: ٦٣.']),
    _Lesson('نجمع خطوة خطوة', 42, 16, 58, null,
        'اثنان زائد ستة يساوي ثمانية آحاد. وأربع عشرات زائد عشرة واحدة تساوي خمس عشرات. إذن الناتج ثمانية وخمسون.',
        ['٢ + ٦ = ٨ آحاد.', '٤ + ١ = ٥ عشرات.', 'الناتج: ٥٨.']),
    _Lesson('مثال شامل', 47, 25, 72, '١',
        'سبعة زائد خمسة يساوي اثني عشر. نكتب اثنين ونحمل عشرة واحدة. ثم أربع عشرات زائد عشرتين زائد عشرة الحمل تساوي سبع عشرات. الناتج اثنان وسبعون.',
        ['٧ + ٥ = ١٢.', 'نكتب ٢ ونحمل ١ عشرة.', '٤ + ٢ + ١ = ٧ عشرات.', 'الناتج: ٧٢.']),
    _Lesson('مراجعة الجمع', 55, 18, 73, '١',
        'خمسة زائد ثمانية يساوي ثلاثة عشر. نكتب ثلاثة ونحمل عشرة واحدة. ثم خمس عشرات زائد عشرة واحدة زائد عشرة الحمل تساوي سبع عشرات. الناتج ثلاثة وسبعون.',
        ['٥ + ٨ = ١٣.', 'نكتب ٣ ونحمل ١ عشرة.', '٥ + ١ + ١ = ٧ عشرات.', 'الناتج: ٧٣.']),
  ];

  static const _subtraction = <_Lesson>[
    _Lesson('الطرح بدون اقتراض', 35, 12, 23, null,
        'نطرح الآحاد أولًا: خمسة ناقص اثنين يساوي ثلاثة. ثم ثلاث عشرات ناقص عشرة واحدة تساوي عشرتين. الناتج ثلاثة وعشرون.',
        ['٥ − ٢ = ٣ آحاد.', '٣ − ١ = ٢ عشرات.', 'الناتج: ٢٣.']),
    _Lesson('مثال آخر بدون اقتراض', 48, 25, 23, null,
        'ثمانية ناقص خمسة يساوي ثلاثة آحاد. وأربع عشرات ناقص عشرتين تساوي عشرتين. إذن الناتج ثلاثة وعشرون.',
        ['٨ − ٥ = ٣ آحاد.', '٤ − ٢ = ٢ عشرات.', 'الناتج: ٢٣.']),
    _Lesson('الاقتراض من العشرات', 32, 15, 17, '١',
        'لا نستطيع طرح خمسة آحاد من آحاد عددها اثنان. نستعير عشرة واحدة من العشرات، فتصبح الآحاد اثني عشر، وتصبح العشرات اثنتين. اثنا عشر ناقص خمسة يساوي سبعة، واثنتان ناقص واحدة تساوي عشرة واحدة. الناتج سبعة عشر.',
        ['٢ − ٥ لا يمكن، فنقترض ١ عشرة.', '٣ عشرات تصبح ٢ عشرات، و٢ آحاد تصبح ١٢ آحادًا.', '١٢ − ٥ = ٧.', '٢ − ١ = ١ عشرة.', 'الناتج: ١٧.']),
    _Lesson('الاقتراض باستخدام الفواكه', 41, 16, 25, '١',
        'لدينا واحد وأربعون ثمرة، ونريد إزالة ست عشرة ثمرة. لا تكفي آحاد العدد واحد لطرح ستة، لذلك نقترض عشرة واحدة من العشرات. تصبح الآحاد أحد عشر، والعشرات ثلاثًا. أحد عشر ناقص ستة يساوي خمسة، وثلاث عشرات ناقص عشرة واحدة تساوي عشرتين. يبقى خمسة وعشرون.',
        ['١ − ٦ لا يمكن، فنقترض ١ عشرة.', '٤ عشرات تصبح ٣، و١ آحاد تصبح ١١.', '١١ − ٦ = ٥.', '٣ − ١ = ٢ عشرات.', 'الباقي: ٢٥.']),
    _Lesson('الاقتراض باستخدام السيارات', 53, 27, 26, '١',
        'لدينا ثلاث وخمسون سيارة، ونزيل سبعًا وعشرين سيارة. لا تكفي ثلاثة آحاد لطرح سبعة، فنقترض عشرة واحدة. تصبح الآحاد ثلاثة عشر، وتصبح العشرات أربعًا. ثلاثة عشر ناقص سبعة يساوي ستة، وأربع عشرات ناقص عشرتين تساوي عشرتين. يبقى ست وعشرون سيارة.',
        ['٣ − ٧ لا يمكن، فنقترض ١ عشرة.', '٥ عشرات تصبح ٤، و٣ آحاد تصبح ١٣.', '١٣ − ٧ = ٦.', '٤ − ٢ = ٢ عشرات.', 'الباقي: ٢٦ سيارة.']),
    _Lesson('اقتراض في مثال أكبر', 62, 38, 24, '١',
        'اثنان لا تكفي لطرح ثمانية، فنقترض عشرة من العشرات. تصبح الآحاد اثني عشر، والعشرات خمسًا. اثنا عشر ناقص ثمانية يساوي أربعة، وخمس عشرات ناقص ثلاث عشرات تساوي عشرتين. الناتج أربعة وعشرون.',
        ['٢ − ٨ لا يمكن، فنقترض ١ عشرة.', '٦ عشرات تصبح ٥، و٢ آحاد تصبح ١٢.', '١٢ − ٨ = ٤.', '٥ − ٣ = ٢ عشرات.', 'الناتج: ٢٤.']),
    _Lesson('الطرح خطوة خطوة', 74, 32, 42, null,
        'أربعة ناقص اثنين يساوي اثنين، وسبع عشرات ناقص ثلاث عشرات تساوي أربع عشرات. الناتج اثنان وأربعون.',
        ['٤ − ٢ = ٢ آحاد.', '٧ − ٣ = ٤ عشرات.', 'الناتج: ٤٢.']),
    _Lesson('اقتراض في مثال آخر', 65, 28, 37, '١',
        'خمسة آحاد لا تكفي لطرح ثمانية، لذلك نقترض عشرة. تصبح الآحاد خمسة عشر، وتصبح العشرات خمسًا. خمسة عشر ناقص ثمانية يساوي سبعة، وخمس عشرات ناقص عشرتين تساوي ثلاث عشرات. الناتج سبعة وثلاثون.',
        ['٥ − ٨ لا يمكن، فنقترض ١ عشرة.', '٦ عشرات تصبح ٥، و٥ آحاد تصبح ١٥.', '١٥ − ٨ = ٧.', '٥ − ٢ = ٣ عشرات.', 'الناتج: ٣٧.']),
    _Lesson('مثال شامل', 82, 46, 36, '١',
        'لا يكفي اثنان لطرح ستة، فنقترض عشرة من العشرات. تصبح الآحاد اثني عشر، والعشرات سبعًا. اثنا عشر ناقص ستة يساوي ستة، وسبع عشرات ناقص أربع عشرات تساوي ثلاث عشرات. الناتج ستة وثلاثون.',
        ['٢ − ٦ لا يمكن، فنقترض ١ عشرة.', '٨ عشرات تصبح ٧، و٢ آحاد تصبح ١٢.', '١٢ − ٦ = ٦.', '٧ − ٤ = ٣ عشرات.', 'الناتج: ٣٦.']),
    _Lesson('مراجعة الطرح', 91, 37, 54, '١',
        'واحد لا يكفي لطرح سبعة، فنقترض عشرة من العشرات. تصبح الآحاد أحد عشر، والعشرات ثمانيًا. أحد عشر ناقص سبعة يساوي أربعة، وثماني عشرات ناقص ثلاث عشرات تساوي خمس عشرات. الناتج أربعة وخمسون.',
        ['١ − ٧ لا يمكن، فنقترض ١ عشرة.', '٩ عشرات تصبح ٨، و١ آحاد تصبح ١١.', '١١ − ٧ = ٤.', '٨ − ٣ = ٥ عشرات.', 'الناتج: ٥٤.']),
  ];

  List<_Lesson> get _lessons => widget.isAddition ? _addition : _subtraction;
  _Lesson get _lesson => _lessons[_page];

  void _speak() => VoiceService.arabic('${_lesson.title}. ${_lesson.voice}');

  void _move(int delta) {
    final next = _page + delta;
    if (next < 0 || next >= _lessons.length) return;
    setState(() => _page = next);
    _speak();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speak());
  }

  @override
  void dispose() {
    VoiceService.stopEducational();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.isAddition ? const Color(0xFF00A86B) : const Color(0xFFFF6B35);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.isAddition ? 'تعلم الجمع' : 'تعلم الطرح')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(children: [
              Text('المثال ${arNum(_page + 1)} من ${arNum(_lessons.length)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: accent)),
              const SizedBox(height: 8),
              Expanded(child: SingleChildScrollView(child: _lessonCard(accent))),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: Button3D(onTap: _page == 0 ? null : () => _move(-1), color: const Color(0xFF2979FF), child: const Center(child: Text('السابق', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white))))),
                const SizedBox(width: 10),
                Expanded(child: Button3D(onTap: _page == _lessons.length - 1 ? null : () => _move(1), color: accent, child: const Center(child: Text('التالي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white))))),
              ]),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _lessonCard(Color accent) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Text(_lesson.title, textAlign: TextAlign.center, softWrap: true, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: accent)),
          const SizedBox(height: 10),
          Text(_lesson.voice, textAlign: TextAlign.center, softWrap: true, style: const TextStyle(fontSize: 17, height: 1.55, fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          Text('${arNum(_lesson.a)} ${widget.isAddition ? '+' : '−'} ${arNum(_lesson.b)} = ${arNum(_lesson.result)}', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: accent)),
          const SizedBox(height: 14),
          _verticalMath(accent),
          const SizedBox(height: 14),
          _stepsBox(accent),
          const SizedBox(height: 14),
          Button3D(onTap: _speak, color: accent, child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.volume_up_rounded, color: Colors.white), SizedBox(width: 8), Text('استمع للشرح', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white))])),
        ]),
      ),
    );
  }

  Widget _verticalMath(Color accent) {
    final op = widget.isAddition ? '+' : '−';
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(color: accent.withValues(alpha: .30), width: 2)),
      child: Column(children: [
        Text(widget.isAddition ? 'الطريقة العمودية — الحمل فوق المسألة' : 'الطريقة العمودية — الاقتراض فوق المسألة', textAlign: TextAlign.center, softWrap: true, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: accent)),
        const SizedBox(height: 8),
        if (_lesson.carry != null) Text(widget.isAddition ? 'رقم الحمل: ${_lesson.carry}' : 'رقم الاقتراض: ${_lesson.carry}', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: accent)),
        const SizedBox(height: 4),
        SizedBox(width: 180, child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          if (_lesson.carry != null && widget.isAddition) Align(alignment: Alignment.centerRight, child: Text(_lesson.carry!, style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: accent))),
          Text(arNum(_lesson.a), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text(op, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)), const SizedBox(width: 8), Text(arNum(_lesson.b), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900))]),
          const Divider(thickness: 3),
          Text(arNum(_lesson.result), style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
        ])),
        if (!widget.isAddition && _lesson.carry != null) ...[
          const SizedBox(height: 6),
          Text('نحوّل عشرة واحدة من العشرات إلى عشرة آحاد.', textAlign: TextAlign.center, softWrap: true, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: accent)),
        ],
      ]),
    );
  }

  Widget _stepsBox(Color accent) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: accent.withValues(alpha: .07), borderRadius: BorderRadius.circular(18)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text('الشرح خطوة بخطوة', textAlign: TextAlign.center, style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: accent)),
        const SizedBox(height: 8),
        for (var i = 0; i < _lesson.steps.length; i++)
          Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Text('${arNum(i + 1)}. ${_lesson.steps[i]}', textAlign: TextAlign.right, softWrap: true, style: const TextStyle(fontSize: 16, height: 1.45, fontWeight: FontWeight.w700))),
      ]),
    );
  }
}

class _Lesson {
  final String title;
  final int a;
  final int b;
  final int result;
  final String? carry;
  final String voice;
  final List<String> steps;

  const _Lesson(this.title, this.a, this.b, this.result, this.carry, this.voice, this.steps);
}
