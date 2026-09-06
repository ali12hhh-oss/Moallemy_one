import 'package:flutter/material.dart';
import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../widgets/button_3d.dart';

class G2CompareOrderLearningScreen extends StatefulWidget {
  final bool comparisonMode;
  const G2CompareOrderLearningScreen({super.key, required this.comparisonMode});
  @override
  State<G2CompareOrderLearningScreen> createState() => _G2CompareOrderLearningScreenState();
}

class _G2CompareOrderLearningScreenState extends State<G2CompareOrderLearningScreen> {
  int page = 0;
  static const comparison = <_Example>[
    _Example('أكبر من','١٢ > ٧','نقارن العشرات أولًا. في ١٢ توجد عشرة واحدة، وفي ٧ لا توجد عشرات؛ لذلك ١٢ أكبر من ٧. الجهة المفتوحة من الرمز تتجه إلى العدد الأكبر.'),
    _Example('أصغر من','٢٣ < ٣١','نقارن العشرات أولًا. في ٢٣ توجد عشرتان، وفي ٣١ توجد ثلاث عشرات. بما أن ٢ أقل من ٣، فإن ٢٣ أصغر من ٣١.'),
    _Example('يساوي','٤٥ = ٤٥','العددان متطابقان: لهما أربع عشرات وخمس آحاد. عندما يكون العددان متساويين نستخدم رمز المساواة =.'),
    _Example('أصغر من','٦٨ < ٨٦','في ٦٨ توجد ست عشرات، وفي ٨٦ توجد ثماني عشرات. ست أقل من ثمان، لذلك ٦٨ أصغر من ٨٦.'),
    _Example('أكبر من','٩٤ > ٤٩','في ٩٤ توجد تسع عشرات، وفي ٤٩ توجد أربع عشرات. تسع أكبر من أربع، لذلك ٩٤ أكبر من ٤٩.'),
  ];
  static const ordering = <_Example>[
    _Example('تصاعدي','٣ ← ٦ ← ٨','الترتيب التصاعدي يعني من الأصغر إلى الأكبر. أصغر عدد هو ٣، ثم ٦، ثم ٨.'),
    _Example('تنازلي','٩١ ← ٧٢ ← ٤٥','الترتيب التنازلي يعني من الأكبر إلى الأصغر. الأكبر هو ٩١، ثم ٧٢، ثم ٤٥.'),
    _Example('تصاعدي','١٤ ← ٢٤ ← ٤١','نقارن العشرات أولًا: ١٤ فيه عشرة واحدة، و٢٤ فيه عشرتان، و٤١ فيه أربع عشرات. لذلك الترتيب ١٤، ثم ٢٤، ثم ٤١.'),
    _Example('تنازلي','٨٣ ← ٦٣ ← ٣٦','نرتب من الأكبر إلى الأصغر. نقارن العشرات: ٨ أكبر من ٦، و٦ أكبر من ٣. لذلك ٨٣، ثم ٦٣، ثم ٣٦.'),
    _Example('تصاعدي','٢٩ ← ٣٩ ← ٩٢','نقارن العشرات: ٢٩ فيه عشرتان، و٣٩ فيه ثلاث عشرات، و٩٢ فيه تسع عشرات. لذلك من الأصغر إلى الأكبر: ٢٩، ثم ٣٩، ثم ٩٢.'),
  ];
  List<_Example> get examples => widget.comparisonMode ? comparison : ordering;
  void speak() { final e = examples[page]; VoiceService.arabic('${e.title}. ${e.explanation}. الإجابة: ${e.answer}.'); }
  @override
  Widget build(BuildContext context) {
    final e = examples[page];
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(
      appBar: AppBar(title: Text(widget.comparisonMode ? 'تدرب على المقارنة' : 'تدرب على الترتيب')),
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(18), child: Column(children: [
        Text('مثال ${arNum(page + 1)} من ${arNum(examples.length)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        Expanded(child: Card(elevation: 6, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), child: Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(e.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 18), Text(e.answer, textAlign: TextAlign.center, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
          const SizedBox(height: 22), Text(e.explanation, textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, height: 1.6, fontWeight: FontWeight.w600)),
          const SizedBox(height: 18), Button3D(onTap: speak, color: const Color(0xFF2979FF), padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14), child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.volume_up_rounded, color: Colors.white), SizedBox(width: 8), Text('استمع للشرح', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900))])),
        ])))),
        const SizedBox(height: 14), Row(children: [
          Expanded(child: Button3D(onTap: page == 0 ? null : () => setState(() => page--), color: const Color(0xFF7C4DFF), padding: const EdgeInsets.symmetric(vertical: 14), child: const Center(child: Text('السابق', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900))))),
          const SizedBox(width: 12), Expanded(child: Button3D(onTap: page == examples.length - 1 ? null : () => setState(() => page++), color: const Color(0xFF00C853), padding: const EdgeInsets.symmetric(vertical: 14), child: Center(child: Text(page == examples.length - 1 ? 'انتهت الأمثلة' : 'المثال التالي', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900))))),
        ]),
      ]))),
    ));
  }
}
class _Example { final String title, answer, explanation; const _Example(this.title, this.answer, this.explanation); }
