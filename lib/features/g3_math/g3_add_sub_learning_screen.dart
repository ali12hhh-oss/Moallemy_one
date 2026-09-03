import 'package:flutter/material.dart';
import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../widgets/button_3d.dart';

class G3AddSubLearningScreen extends StatefulWidget {
  final bool isAddition;
  const G3AddSubLearningScreen({super.key, required this.isAddition});
  @override
  State<G3AddSubLearningScreen> createState() => _G3AddSubLearningScreenState();
}

class _G3AddSubLearningScreenState extends State<G3AddSubLearningScreen> {
  int page = 0;

  static const add = <_Lesson>[
    _Lesson('١. نبدأ بالآحاد', 123, 245, 'نجمع الآحاد مع الآحاد، والعشرات مع العشرات، والمئات مع المئات.', '١٢٣ + ٢٤٥ = ٣٦٨', ''),
    _Lesson('٢. الجمع أفقيًا', 214, 132, 'نكتب العددين في سطر واحد ثم نجمع كل مرتبة مع نظيرتها.', '٢١٤ + ١٣٢ = ٣٤٦', ''),
    _Lesson('٣. الجمع عموديًا', 321, 246, 'نرتب الآحاد تحت الآحاد، والعشرات تحت العشرات، والمئات تحت المئات.', '٣٢١ + ٢٤٦ = ٥٦٧', ''),
    _Lesson('٤. نجمع الآحاد أولًا', 135, 242, '٥ + ٢ = ٧، ثم العشرات والمئات.', '١٣٥ + ٢٤٢ = ٣٧٧', ''),
    _Lesson('٥. مع الحمل في الآحاد', 128, 157, '٨ + ٧ = ١٥. نكتب ٥ في الآحاد ونحمل عشرة إلى العشرات.', '١٢٨ + ١٥٧ = ٢٨٥', '١٠ آحاد تصبح عشرة واحدة، فنضيفها إلى العشرات.'),
    _Lesson('٦. الحمل في العشرات', 264, 178, 'نجمع الآحاد أولًا، ثم العشرات. إذا أصبح مجموع العشرات ١٠ أو أكثر نحمل إلى المئات.', '٢٦٤ + ١٧٨ = ٤٤٢', '٤ عشرات + ٧ عشرات + عشرة الحمل = ١٢ عشرة؛ نكتب ٢ ونحمل ١ مئة.'),
    _Lesson('٧. حمل متتابع', 386, 257, 'قد يحدث الحمل في الآحاد ثم في العشرات. ننتقل مرتبةً مرتبة.', '٣٨٦ + ٢٥٧ = ٦٤٣', '٦ + ٧ = ١٣، ثم ٨ + ٥ + ١ = ١٤، ثم ٣ + ٢ + ١ = ٦.'),
    _Lesson('٨. مثال أكبر', 475, 286, 'نطبق القاعدة نفسها على ثلاثة أرقام.', '٤٧٥ + ٢٨٦ = ٧٦١', 'رتّب المراتب ولا تنسَ رقم الحمل.'),
    _Lesson('٩. مثال آخر', 532, 198, 'اجمع من اليمين إلى اليسار مع تسجيل الحمل فوق المرتبة التالية.', '٥٣٢ + ١٩٨ = ٧٣٠', '٢ + ٨ = ١٠: نكتب ٠ ونحمل ١.'),
    _Lesson('١٠. تذكّر القاعدة', 648, 275, 'الآحاد مع الآحاد، والعشرات مع العشرات، والمئات مع المئات، ثم الحمل عند الحاجة.', '٦٤٨ + ٢٧٥ = ٩٢٣', 'ابدأ دائمًا من الآحاد ثم انتقل إلى العشرات ثم المئات.'),
  ];

  static const sub = <_Lesson>[
    _Lesson('١. نبدأ بالآحاد', 356, 124, 'نطرح الآحاد من الآحاد، والعشرات من العشرات، والمئات من المئات.', '٣٥٦ − ١٢٤ = ٢٣٢', ''),
    _Lesson('٢. الطرح أفقيًا', 487, 235, 'نكتب العددين في سطر واحد ونطرح كل مرتبة من نظيرتها.', '٤٨٧ − ٢٣٥ = ٢٥٢', ''),
    _Lesson('٣. الطرح عموديًا', 621, 310, 'نرتب المئات والعشرات والآحاد تحت بعضها ثم نطرح من اليمين.', '٦٢١ − ٣١٠ = ٣١١', ''),
    _Lesson('٤. بدون استلاف', 754, 321, 'إذا كان رقم الآحاد في الأعلى أكبر من رقم الآحاد في الأسفل، نطرح مباشرة.', '٧٥٤ − ٣٢١ = ٤٣٣', ''),
    _Lesson('٥. الاستلاف من العشرات', 432, 158, '٢ أصغر من ٨، فنستلف عشرة من العشرات ونحوّلها إلى ١٠ آحاد.', '٤٣٢ − ١٥٨ = ٢٧٤', 'نستلف عشرة: تصبح ٢ آحاد = ١٢ آحاد، والعشرات تنقص واحدًا.'),
    _Lesson('٦. الاستلاف في العشرات', 562, 287, 'بعد الآحاد نطرح العشرات. إذا لم تكفِ نستلف مئة من المئات.', '٥٦٢ − ٢٨٧ = ٢٧٥', '٦ عشرات لا تكفي لطرح ٨ عشرات، فنستلف مئة ونحوّلها إلى ١٠ عشرات.'),
    _Lesson('٧. استلاف متتابع', 703, 268, 'إذا احتجنا للاستلاف، ننقل قيمة من المرتبة الأكبر إلى المرتبة الأصغر.', '٧٠٣ − ٢٦٨ = ٤٣٥', 'الصفر في العشرات يحتاج إلى الاستلاف من المئات أولًا.'),
    _Lesson('٨. مثال أكبر', 845, 376, 'طبّق الاستلاف من الآحاد ثم أكمل العشرات والمئات.', '٨٤٥ − ٣٧٦ = ٤٦٩', 'نطرح من اليمين إلى اليسار بعد ترتيب المراتب.'),
    _Lesson('٩. مثال آخر', 900, 245, 'نستلف عبر المراتب عندما يكون الرقم الأوسط صفرًا.', '٩٠٠ − ٢٤٥ = ٦٥٥', 'نحوّل مئة إلى عشرات ثم عشرة إلى آحاد عند الحاجة.'),
    _Lesson('١٠. تذكّر القاعدة', 731, 286, 'الآحاد مع الآحاد، والعشرات مع العشرات، والمئات مع المئات، والاستلاف عند الحاجة.', '٧٣١ − ٢٨٦ = ٤٤٥', 'ابدأ من الآحاد، وإذا لم تكفِ القيمة فاستلف من المرتبة التالية.'),
  ];

  List<_Lesson> get lessons => widget.isAddition ? add : sub;
  _Lesson get lesson => lessons[page];

  void speak() => VoiceService.arabic('${lesson.title}. ${lesson.explanation} ${lesson.operation}. ${lesson.note}');
  void move(int d) { final n = page + d; if (n < 0 || n >= lessons.length) return; setState(() => page = n); speak(); }

  @override
  void initState() { super.initState(); WidgetsBinding.instance.addPostFrameCallback((_) => speak()); }

  @override
  Widget build(BuildContext context) {
    final accent = widget.isAddition ? const Color(0xFF00C853) : const Color(0xFFFF6B35);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.isAddition ? 'تعلم الجمع' : 'تعلم الطرح')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(children: [
              Text('${arNum(page + 1)} / ${arNum(lessons.length)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: accent)),
              const SizedBox(height: 8),
              Expanded(child: SingleChildScrollView(child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Padding(padding: const EdgeInsets.all(18), child: Column(children: [
                  Text(lesson.title, textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: accent)),
                  const SizedBox(height: 12),
                  Text(lesson.explanation, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, height: 1.5)),
                  const SizedBox(height: 16),
                  Text('${arNum(lesson.a)} ${widget.isAddition ? '+' : '−'} ${arNum(lesson.b)}', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  const Divider(thickness: 2),
                  Text(lesson.operation, textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: accent)),
                  const SizedBox(height: 14),
                  Container(width: double.infinity, padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: accent.withValues(alpha: .10), borderRadius: BorderRadius.circular(16)), child: Text(lesson.note.isEmpty ? 'نرتب الآحاد والعشرات والمئات، ثم ننجز العملية خطوة بخطوة.' : lesson.note, textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, height: 1.45))),
                  const SizedBox(height: 14),
                  Button3D(onTap: speak, color: accent, child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.volume_up_rounded, color: Colors.white), SizedBox(width: 8), Text('استمع للشرح', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white))])),
                ])),
              ))),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: Button3D(onTap: page == 0 ? null : () => move(-1), color: const Color(0xFF2979FF), child: const Center(child: Text('السابق', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white))))),
                const SizedBox(width: 10),
                Expanded(child: Button3D(onTap: page == lessons.length - 1 ? null : () => move(1), color: accent, child: const Center(child: Text('التالي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white))))),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}

class _Lesson {
  final String title, explanation, operation, note;
  final int a, b;
  const _Lesson(this.title, this.a, this.b, this.explanation, this.operation, this.note);
}
