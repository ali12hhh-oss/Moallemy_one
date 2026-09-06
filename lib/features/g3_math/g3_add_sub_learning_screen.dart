import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../widgets/button_3d.dart';

/// تعلم الجمع والطرح للصف الثالث مع شرح المراتب والحمل والاقتراض.
class G3AddSubLearningScreen extends StatefulWidget {
  final bool isAddition;
  const G3AddSubLearningScreen({super.key, required this.isAddition});

  @override
  State<G3AddSubLearningScreen> createState() => _G3AddSubLearningScreenState();
}

class _G3AddSubLearningScreenState extends State<G3AddSubLearningScreen> {
  int _page = 0;

  static const _addition = <_Lesson>[
    _Lesson('١. نجمع المراتب بالترتيب', 123, 245, 368, null,
        'نرتب المئات والعشرات والآحاد. نبدأ من الآحاد: ثلاثة زائد خمسة يساوي ثمانية. ثم العشرات: عشرتان زائد أربع عشرات تساوي ست عشرات. ثم المئات: مئة واحدة زائد مئتين تساوي ثلاث مئات. الناتج ثلاثمئة وثمانية وستون.',
        ['الآحاد: ٣ + ٥ = ٨.', 'العشرات: ٢ + ٤ = ٦ عشرات.', 'المئات: ١ + ٢ = ٣ مئات.', 'الناتج: ٣٦٨.']),
    _Lesson('٢. الجمع أفقيًا ثم عموديًا', 214, 132, 346, null,
        'نستطيع قراءة المسألة أفقيًا، لكن عند الحل العمودي نضع كل مرتبة تحت نظيرتها. أربعة عشر آحادًا؟ لا، هنا الآحاد أربعة زائد اثنين يساوي ستة. والعشرات واحدة زائد ثلاث تساوي أربع عشرات، والمئات اثنتان زائد واحدة تساوي ثلاث مئات. الناتج ثلاثمئة وستة وأربعون.',
        ['٤ + ٢ = ٦ آحاد.', '١ + ٣ = ٤ عشرات.', '٢ + ١ = ٣ مئات.', 'الناتج: ٣٤٦.']),
    _Lesson('٣. الجمع العمودي', 321, 246, 567, null,
        'نرتب الأعداد عموديًا. واحد زائد ستة في الآحاد يساوي سبعة، واثنتان زائد أربع تساوي ست عشرات، وثلاث مئات زائد مئتين تساوي خمس مئات. الناتج خمسمئة وسبعة وستون.',
        ['١ + ٦ = ٧ آحاد.', '٢ + ٤ = ٦ عشرات.', '٣ + ٢ = ٥ مئات.', 'الناتج: ٥٦٧.']),
    _Lesson('٤. نجمع الآحاد أولًا', 135, 242, 377, null,
        'نبدأ من اليمين. خمسة زائد اثنين يساوي سبعة آحاد. ثلاثة زائد أربعة يساوي سبع عشرات. ومئة زائد مئتين تساوي ثلاث مئات. إذن الناتج ثلاثمئة وسبعة وسبعون.',
        ['٥ + ٢ = ٧.', '٣ + ٤ = ٧ عشرات.', '١ + ٢ = ٣ مئات.', 'الناتج: ٣٧٧.']),
    _Lesson('٥. الحمل في الآحاد', 128, 157, 285, '١',
        'ثمانية زائد سبعة يساوي خمسة عشر آحادًا. نكتب خمسة في الآحاد، ونحوّل عشرة آحاد إلى عشرة واحدة، ونضع رقم الحمل واحدًا فوق خانة العشرات. ثم نجمع: اثنتان زائد خمس عشرات زائد عشرة الحمل تساوي ثماني عشرات. ثم مئة واحدة زائد مئة واحدة تساوي مئتين. الناتج مئتان وخمسة وثمانون.',
        ['٨ + ٧ = ١٥ آحادًا.', 'نكتب ٥ آحادًا ونحمل ١ عشرة فوق العشرات.', '٢ + ٥ + ١ = ٨ عشرات.', '١ + ١ = ٢ مئات.', 'الناتج: ٢٨٥.']),
    _Lesson('٦. الحمل في العشرات', 264, 178, 442, '١',
        'نبدأ بالآحاد: أربعة زائد ثمانية يساوي اثني عشر. نكتب اثنين ونحمل عشرة واحدة إلى العشرات. ثم ست عشرات زائد سبع عشرات زائد عشرة الحمل تساوي أربع عشرة عشرة، فنكتب أربعة ونحمل مئة واحدة إلى المئات. ثم مئتان زائد مئة زائد مئة الحمل تساوي أربع مئات. الناتج أربعمئة واثنان وأربعون.',
        ['٤ + ٨ = ١٢: نكتب ٢ ونحمل ١ عشرة.', '٦ + ٧ + ١ = ١٤ عشرات: نكتب ٤ ونحمل ١ مئة.', '٢ + ١ + ١ = ٤ مئات.', 'الناتج: ٤٤٢.']),
    _Lesson('٧. حمل متتابع', 386, 257, 643, '١ ثم ١',
        'في الآحاد: ستة زائد سبعة يساوي ثلاثة عشر، فنكتب ثلاثة ونحمل عشرة. في العشرات: ثمانية زائد خمسة زائد عشرة الحمل يساوي أربعة عشر عشرة، فنكتب أربعة ونحمل مئة. في المئات: ثلاث مئات زائد مئتين زائد مئة الحمل تساوي ست مئات. الناتج ستمئة وثلاثة وأربعون.',
        ['٦ + ٧ = ١٣: نكتب ٣ ونحمل ١ عشرة.', '٨ + ٥ + ١ = ١٤: نكتب ٤ ونحمل ١ مئة.', '٣ + ٢ + ١ = ٦ مئات.', 'الناتج: ٦٤٣.']),
    _Lesson('٨. مثال أكبر', 475, 286, 761, '١ ثم ١',
        'خمسة زائد ستة يساوي أحد عشر، فنكتب واحدًا ونحمل عشرة. سبع عشرات زائد ثماني عشرات زائد عشرة الحمل تساوي ست عشرة عشرة، فنكتب ستة ونحمل مئة. أربع مئات زائد مئتين زائد مئة الحمل تساوي سبع مئات. الناتج سبعمئة وواحد وستون.',
        ['٥ + ٦ = ١١: نكتب ١ ونحمل ١ عشرة.', '٧ + ٨ + ١ = ١٦: نكتب ٦ ونحمل ١ مئة.', '٤ + ٢ + ١ = ٧ مئات.', 'الناتج: ٧٦١.']),
    _Lesson('٩. عندما يكون الحمل عشرة كاملة', 532, 198, 730, '١ ثم ١',
        'اثنان زائد ثمانية يساوي عشرة آحاد. نكتب صفرًا ونحمل عشرة واحدة. ثلاث عشرات زائد تسع عشرات زائد عشرة الحمل تساوي ثلاث عشرة عشرة، فنكتب ثلاثة ونحمل مئة. خمس مئات زائد مئة زائد مئة الحمل تساوي سبع مئات. الناتج سبعمئة وثلاثون.',
        ['٢ + ٨ = ١٠: نكتب ٠ ونحمل ١ عشرة.', '٣ + ٩ + ١ = ١٣: نكتب ٣ ونحمل ١ مئة.', '٥ + ١ + ١ = ٧ مئات.', 'الناتج: ٧٣٠.']),
    _Lesson('١٠. مراجعة الجمع', 648, 275, 923, '١ ثم ١',
        'ثمانية زائد خمسة يساوي ثلاثة عشر، فنكتب ثلاثة ونحمل عشرة. أربع عشرات زائد سبع عشرات زائد عشرة الحمل تساوي اثنتي عشرة عشرة، فنكتب اثنين ونحمل مئة. ست مئات زائد مئتين زائد مئة الحمل تساوي تسع مئات. الناتج تسعمئة وثلاثة وعشرون.',
        ['٨ + ٥ = ١٣: نكتب ٣ ونحمل ١ عشرة.', '٤ + ٧ + ١ = ١٢: نكتب ٢ ونحمل ١ مئة.', '٦ + ٢ + ١ = ٩ مئات.', 'الناتج: ٩٢٣.']),
  ];

  static const _subtraction = <_Lesson>[
    _Lesson('١. الطرح بدون اقتراض', 356, 124, 232, null,
        'نبدأ بالآحاد: ستة ناقص أربعة يساوي اثنين. ثم خمس عشرات ناقص عشرتين تساوي ثلاث عشرات. ثم ثلاث مئات ناقص مئة واحدة تساوي مئتين. الناتج مئتان واثنان وثلاثون.',
        ['٦ − ٤ = ٢ آحاد.', '٥ − ٢ = ٣ عشرات.', '٣ − ١ = ٢ مئات.', 'الناتج: ٢٣٢.']),
    _Lesson('٢. الطرح أفقيًا وعموديًا', 487, 235, 252, null,
        'نرتب المراتب ثم نطرح من اليمين إلى اليسار. سبعة ناقص خمسة يساوي اثنين، وثماني عشرات ناقص ثلاث عشرات تساوي خمس عشرات، وأربع مئات ناقص مئتين تساوي مئتين. الناتج مئتان واثنان وخمسون.',
        ['٧ − ٥ = ٢.', '٨ − ٣ = ٥ عشرات.', '٤ − ٢ = ٢ مئات.', 'الناتج: ٢٥٢.']),
    _Lesson('٣. الطرح العمودي', 621, 310, 311, null,
        'نطرح الآحاد ثم العشرات ثم المئات. واحد ناقص صفر يساوي واحدًا، واثنتان ناقص واحدة تساوي عشرة واحدة، وست مئات ناقص ثلاث مئات تساوي ثلاث مئات. الناتج ثلاثمئة وأحد عشر.',
        ['١ − ٠ = ١.', '٢ − ١ = ١ عشرة.', '٦ − ٣ = ٣ مئات.', 'الناتج: ٣١١.']),
    _Lesson('٤. بدون اقتراض', 754, 321, 433, null,
        'أربعة آحاد ناقص واحد يساوي ثلاثة. خمس عشرات ناقص عشرتين تساوي ثلاث عشرات. سبع مئات ناقص ثلاث مئات تساوي أربع مئات. الناتج أربعمئة وثلاثة وثلاثون.',
        ['٤ − ١ = ٣.', '٥ − ٢ = ٣ عشرات.', '٧ − ٣ = ٤ مئات.', 'الناتج: ٤٣٣.']),
    _Lesson('٥. الاقتراض من العشرات', 432, 158, 274, '١',
        'اثنان لا يكفيان لطرح ثمانية. نستعير عشرة واحدة من العشرات، فتصبح الآحاد اثني عشر، وتصبح العشرات اثنتين. اثنا عشر ناقص ثمانية يساوي أربعة. ثم اثنتان ناقص خمس لا تكفي، لذلك نستعير مئة واحدة من المئات، فتصبح العشرات اثنتي عشرة، والمئات ثلاثًا. اثنتا عشرة ناقص خمس تساوي سبع عشرات، وثلاث مئات ناقص مئة تساوي مئتين. الناتج مئتان وأربعة وسبعون.',
        ['٢ − ٨ لا يمكن: نقترض ١ عشرة، فتصبح ١٢ آحادًا.', '١٢ − ٨ = ٤.', '٢ عشرات − ٥ عشرات لا يمكن: نقترض ١ مئة، فتصبح ١٢ عشرة.', '١٢ − ٥ = ٧ عشرات.', '٣ − ١ = ٢ مئات.', 'الناتج: ٢٧٤.']),
    _Lesson('٦. الاقتراض في العشرات', 562, 287, 275, '١ ثم ١',
        'اثنان لا يكفيان لطرح سبعة، فنقترض عشرة واحدة فتصبح الآحاد اثني عشر والعشرات خمسًا. اثنا عشر ناقص سبعة يساوي خمسة. ثم خمس عشرات لا تكفي لطرح ثماني عشرات، فنقترض مئة واحدة، فتصبح العشرات خمس عشرة، والمئات أربعًا. خمس عشرة ناقص ثماني عشرات تساوي سبع عشرات، وأربع مئات ناقص مئتين تساوي مئتين. الناتج مئتان وخمسة وسبعون.',
        ['٢ − ٧ لا يمكن: تصبح الآحاد ١٢ والعشرات ٥.', '١٢ − ٧ = ٥.', '٥ عشرات − ٨ عشرات لا يمكن: تصبح العشرات ١٥ والمئات ٤.', '١٥ − ٨ = ٧ عشرات.', '٤ − ٢ = ٢ مئات.', 'الناتج: ٢٧٥.']),
    _Lesson('٧. الاقتراض المتتابع', 703, 268, 435, '١ ثم ١',
        'ثلاثة لا تكفي لطرح ثمانية، لكن خانة العشرات صفر، لذلك نحتاج أولًا إلى الاستعارة من المئات. تصبح المئات ستًا، والعشرات عشرًا. نستعير عشرة من العشرات فتصبح الآحاد ثلاثة عشر، والعشرات تسعًا. ثلاثة عشر ناقص ثمانية يساوي خمسة. تسع عشرات ناقص ست تساوي ثلاث عشرات. ست مئات ناقص مئتين تساوي أربع مئات. الناتج أربعمئة وخمسة وثلاثون.',
        ['نستعير ١ مئة: ٧ مئات تصبح ٦، و٠ عشرات تصبح ١٠.', 'نستعير ١ عشرة: تصبح الآحاد ١٣، والعشرات ٩.', '١٣ − ٨ = ٥.', '٩ − ٦ = ٣ عشرات.', '٦ − ٢ = ٤ مئات.', 'الناتج: ٤٣٥.']),
    _Lesson('٨. اقتراض في الآحاد والعشرات', 845, 376, 469, '١ ثم ١',
        'خمسة لا تكفي لطرح ستة، فنقترض عشرة واحدة فتصبح الآحاد خمسة عشر والعشرات ثلاثًا. خمسة عشر ناقص ستة يساوي تسعة. ثلاث عشرات لا تكفي لطرح سبع، فنقترض مئة واحدة فتصبح العشرات ثلاث عشرة والمئات سبعًا. ثلاث عشرة ناقص سبع تساوي ست عشرات، وسبع مئات ناقص ثلاث مئات تساوي أربع مئات. الناتج أربعمئة وتسعة وستون.',
        ['٥ − ٦ لا يمكن: تصبح الآحاد ١٥ والعشرات ٣.', '١٥ − ٦ = ٩.', '٣ عشرات − ٧ عشرات لا يمكن: تصبح العشرات ١٣ والمئات ٧.', '١٣ − ٧ = ٦ عشرات.', '٧ − ٣ = ٤ مئات.', 'الناتج: ٤٦٩.']),
    _Lesson('٩. الاقتراض عبر الصفر', 900, 245, 655, '١ ثم ١',
        'لا يمكن طرح خمسة من صفر في الآحاد، ولا يمكن الاقتراض مباشرة من العشرات لأنها صفر. نستعير أولًا مئة من المئات، فتصبح المئات ثمانيًا والعشرات عشرًا. ثم نستعير عشرة من العشرات، فتصبح العشرات تسعًا والآحاد عشرة. عشرة ناقص خمسة يساوي خمسة، وتسع عشرات ناقص أربع عشرات تساوي خمس عشرات، وثماني مئات ناقص مئتين تساوي ست مئات. الناتج ستمئة وخمسة وخمسون.',
        ['نستعير ١ مئة: ٩ مئات تصبح ٨، و٠ عشرات تصبح ١٠.', 'نستعير ١ عشرة: ١٠ عشرات تصبح ٩، و٠ آحاد تصبح ١٠.', '١٠ − ٥ = ٥.', '٩ − ٤ = ٥ عشرات.', '٨ − ٢ = ٦ مئات.', 'الناتج: ٦٥٥.']),
    _Lesson('١٠. مراجعة الطرح', 731, 286, 445, '١ ثم ١',
        'واحد لا يكفي لطرح ستة، فنستعير عشرة فتصبح الآحاد أحد عشر والعشرات اثنتين. أحد عشر ناقص ستة يساوي خمسة. اثنتان لا تكفيان لطرح ثماني عشرات، فنستعير مئة فتصبح العشرات اثنتي عشرة والمئات ستًا. اثنتا عشرة ناقص ثماني تساوي أربع عشرات، وست مئات ناقص مئتين تساوي أربع مئات. الناتج أربعمئة وخمسة وأربعون.',
        ['١ − ٦ لا يمكن: تصبح الآحاد ١١ والعشرات ٢.', '١١ − ٦ = ٥.', '٢ عشرات − ٨ عشرات لا يمكن: تصبح العشرات ١٢ والمئات ٦.', '١٢ − ٨ = ٤ عشرات.', '٦ − ٢ = ٤ مئات.', 'الناتج: ٤٤٥.']),
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
          Text('رقم الاقتراض ١: ننقل عشرة واحدة من العشرات إلى الآحاد عند الحاجة.', textAlign: TextAlign.center, softWrap: true, style: TextStyle(fontSize: 15, height: 1.4, fontWeight: FontWeight.w700, color: accent)),
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
