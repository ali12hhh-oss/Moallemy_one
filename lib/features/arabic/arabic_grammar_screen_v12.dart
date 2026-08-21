import 'package:flutter/material.dart';
import '../../core/audio/voice_service.dart';
import '../../data/language_rules_v12.dart';

class ArabicGrammarScreenV12 extends StatefulWidget {
  const ArabicGrammarScreenV12({super.key});
  @override State<ArabicGrammarScreenV12> createState() => _ArabicGrammarScreenV12State();
}

class _ArabicGrammarScreenV12State extends State<ArabicGrammarScreenV12> {
  int tab = 0;
  int score = 0;
  int answered = 0;

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      appBar: AppBar(title: const Text('اللغة العربية: قواعد القراءة')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 28),
        children: [
          Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('تعلّم ثم طبّق', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('نتعلم القاعدة مع مثال مسموع، ثم نستخدمها في سؤال قصير.'),
            const SizedBox(height: 12),
            Text('نتيجتك في هذه الجلسة: ${score.toArabic()} من ${answered.toArabic()}', style: const TextStyle(fontWeight: FontWeight.bold)),
          ]))),
          const SizedBox(height: 8),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('حروف الجر')),
              ButtonSegment(value: 1, label: Text('الـ التعريف')),
            ],
            selected: {tab},
            onSelectionChanged: (v) => setState(() => tab = v.first),
          ),
          const SizedBox(height: 12),
          ...(tab == 0 ? arabicPrepositionsV12 : arabicDefiniteArticleV12).map(_lesson),
        ],
      ),
    ),
  );

  Widget _lesson(ArabicGrammarLessonV12 x) => Card(
    child: ExpansionTile(
      leading: Text(x.emoji, style: const TextStyle(fontSize: 32)),
      title: Text(x.title, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
      subtitle: Text(x.explanation),
      children: [
        ListTile(
          title: Text(x.example, style: const TextStyle(fontSize: 22)),
          trailing: IconButton(tooltip: 'استمع', icon: const Icon(Icons.volume_up), onPressed: () => VoiceService.arabic(x.example)),
        ),
        ..._practiceFor(x),
      ],
    ),
  );

  List<Widget> _practiceFor(ArabicGrammarLessonV12 x) {
    final data = _arabicQuestion(x.id);
    if (data == null) return x.exercises.map((e) => ListTile(leading: const Icon(Icons.edit_note), title: Text(e))).toList();
    return [
      Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 6), child: Text(data.question, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
      Padding(padding: const EdgeInsets.fromLTRB(12, 0, 12, 12), child: Wrap(spacing: 8, runSpacing: 8, children: data.options.map((o) => OutlinedButton(onPressed: () => _answer(data, o), child: Text(o))).toList())),
    ];
  }

  void _answer(_Question q, String answer) {
    final correct = answer == q.answer;
    setState(() { answered++; if (correct) score++; });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(correct ? 'أحسنت! إجابة صحيحة ⭐' : 'حاول مرة أخرى 🌱')));
    if (correct) VoiceService.arabic('أحسنت، إجابة صحيحة');
  }

  _Question? _arabicQuestion(String id) {
    switch (id) {
      case 'min': return const _Question('خرجتُ ___ المدرسةِ.', ['مِنْ','إِلَى','فِي'], 'مِنْ');
      case 'ila': return const _Question('أذهبُ ___ الحديقةِ.', ['إِلَى','عَنْ','عَلَى'], 'إِلَى');
      case 'fi': return const _Question('القلمُ ___ الحقيبةِ.', ['فِي','إِلَى','مِنْ'], 'فِي');
      case 'ala': return const _Question('الكتابُ ___ الطاولةِ.', ['عَلَى','فِي','عَنْ'], 'عَلَى');
      case 'an': return const _Question('تحدثتُ ___ القراءةِ.', ['عَنْ','إِلَى','لِـ'], 'عَنْ');
      case 'bi': return const _Question('أكتبُ ___ القلمِ.', ['بِـ','كَـ','عَلَى'], 'بِـ');
      case 'ka': return const _Question('الطفلُ ___ النجمِ.', ['كَـ','فِي','مِنْ'], 'كَـ');
      case 'li': return const _Question('هذا الكتابُ ___ الطالبِ.', ['لِـ','بِـ','عَنْ'], 'لِـ');
      case 'al_basic': return const _Question('كتابٌ ← ؟', ['الكتاب','كتاباً','كتب'], 'الكتاب');
      case 'al_sun': return const _Question('أي كلمة فيها لام شمسية؟', ['الشَّمْس','الْقَمَر','الْبَاب'], 'الشَّمْس');
      case 'al_moon': return const _Question('أي كلمة فيها لام قمرية؟', ['الْقَمَر','الشَّجَرَة','النَّجْم'], 'الْقَمَر');
      default: return null;
    }
  }
}

class _Question {
  final String question, answer;
  final List<String> options;
  const _Question(this.question, this.options, this.answer);
}

extension _ArabicDigits on int {
  String toArabic() => toString().replaceAllMapped(RegExp(r'[0-9]'), (m) => '٠١٢٣٤٥٦٧٨٩'[int.parse(m.group(0)!)]);
}
