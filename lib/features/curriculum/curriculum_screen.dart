import 'package:flutter/material.dart';
import '../../data/curriculum_v8.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../core/storage/progress_v8.dart';
import '../quiz/final_exam_screen_v8.dart';

class CurriculumScreen extends StatefulWidget {
  const CurriculumScreen({super.key});
  @override State<CurriculumScreen> createState() => _CurriculumScreenState();
}

class _CurriculumScreenState extends State<CurriculumScreen> {
  int stageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final stage = curriculumV8[stageIndex];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('المنهج الدراسي الكامل')),
        body: Column(children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: Row(children: List.generate(curriculumV8.length, (i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: Text(curriculumV8[i].title),
                selected: i == stageIndex,
                onSelected: (_) => setState(() => stageIndex = i),
              ),
            ))),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Card(child: ListTile(
              leading: const CircleAvatar(child: Text('🎓', style: TextStyle(fontSize: 22))),
              title: Text(stage.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('العمر: ${stage.age}  •  الأعداد: ${stage.numberRange}'),
            )),
          ),
          Expanded(child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: stage.units.length,
            itemBuilder: (_, i) => _unitCard(stage, stage.units[i]),
          )),
          Padding(
            padding: const EdgeInsets.all(12),
            child: FutureBuilder<_Progress>(
              future: _progress(stage),
              builder: (_, snap) {
                final p = snap.data ?? const _Progress(0, 0);
                final ready = p.done == stage.units.length;
                return Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('تقدم المرحلة', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('${arNum(p.done)} / ${arNum(stage.units.length)}'),
                  ]),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(value: stage.units.isEmpty ? 0 : p.done / stage.units.length, minHeight: 9),
                  const SizedBox(height: 10),
                  SizedBox(width: double.infinity, child: FilledButton.icon(
                    onPressed: ready ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => FinalExamScreenV8(stage: stage))) : null,
                    icon: const Icon(Icons.school),
                    label: Text(ready ? 'اختبار نهاية المرحلة 🎓' : 'أكمل دروس المرحلة لفتح الاختبار'),
                  )),
                ]);
              },
            ),
          ),
        ]),
      ),
    );
  }

  Widget _unitCard(CurriculumStageV8 stage, CurriculumUnitV8 unit) => FutureBuilder<bool>(
    future: ProgressV8.lessonDone(unit.id),
    builder: (_, snap) {
      final done = snap.data ?? false;
      return Card(child: ListTile(
        leading: CircleAvatar(child: Text(unit.icon, style: const TextStyle(fontSize: 22))),
        title: Text(unit.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${unit.description}\n${arNum(unit.minutes)} دقيقة  •  ⭐ ${arNum(unit.stars)}\nالمهارات: ${unit.skills.join('، ')}'),
        isThreeLine: true,
        trailing: Icon(done ? Icons.check_circle : Icons.play_circle_fill),
        onTap: () => _completeUnit(unit),
      ));
    },
  );

  Future<void> _completeUnit(CurriculumUnitV8 unit) async {
    await ProgressV8.finishLesson(unit.id, unit.stars);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم تسجيل درس ${unit.title} ⭐')));
      setState(() {});
    }
  }

  Future<_Progress> _progress(CurriculumStageV8 stage) async {
    var done = 0;
    for (final unit in stage.units) {
      if (await ProgressV8.lessonDone(unit.id)) done++;
    }
    return _Progress(done, stage.units.length);
  }
}

class _Progress {
  final int done, total;
  const _Progress(this.done, this.total);
}
