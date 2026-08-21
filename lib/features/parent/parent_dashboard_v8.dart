import 'package:flutter/material.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../core/storage/progress_v8.dart';
import '../../data/curriculum_v8.dart';

class ParentDashboardV8 extends StatefulWidget {
  const ParentDashboardV8({super.key});
  @override State<ParentDashboardV8> createState() => _ParentDashboardV8State();
}

class _ParentDashboardV8State extends State<ParentDashboardV8> {
  Map<String, dynamic> state = {};

  @override
  void initState() { super.initState(); _reload(); }

  Future<void> _reload() async {
    final s = await ProgressV8.load();
    if (mounted) setState(() => state = s);
  }

  @override
  Widget build(BuildContext context) {
    final done = List<String>.from(state['done'] ?? const <String>[]);
    final badges = List<String>.from(state['badges'] ?? const <String>[]);
    final exams = Map<String, dynamic>.from(state['finalExams'] ?? const {});
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('مركز الوالدين')),
        body: RefreshIndicator(
          onRefresh: _reload,
          child: ListView(padding: const EdgeInsets.all(16), children: [
            Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('📊 ملخص تقدم الطفل', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _stat('⭐ النجوم', arNum(state['stars'] ?? 0)),
              _stat('✨ النقاط التعليمية XP', arNum(state['xp'] ?? 0)),
              _stat('📚 الدروس المكتملة', arNum(done.length)),
              _stat('🏆 الاختبارات النهائية', arNum(exams.length)),
            ]))),
            const SizedBox(height: 12),
            const Text('🎓 تقدم المراحل', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...curriculumV8.map((stage) => FutureBuilder<_StageProgress>(
              future: _stageProgress(stage),
              builder: (_, snap) {
                final p = snap.data ?? const _StageProgress(0, 0);
                final value = p.total == 0 ? 0.0 : p.done / p.total;
                final exam = exams[stage.id];
                return Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(children: [
                  Row(children: [Expanded(child: Text(stage.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))), Text('${arNum(p.done)} / ${arNum(p.total)}')]),
                  const SizedBox(height: 7),
                  LinearProgressIndicator(value: value, minHeight: 8),
                  if (exam != null) ...[
                    const SizedBox(height: 7),
                    Align(alignment: Alignment.centerRight, child: Text(exam['passed'] == true ? '🏅 الاختبار النهائي: ناجح' : '🔄 الاختبار النهائي: يحتاج مراجعة')),
                  ],
                ])));
              },
            )),
            const SizedBox(height: 12),
            const Text('🏅 الألقاب والإنجازات', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Wrap(spacing: 8, runSpacing: 8, children: badges.isEmpty ? [const Chip(label: Text('ابدأ التعلم لتحصل على أول لقب'))] : badges.map((b) => Chip(label: Text(b))).toList()),
            const SizedBox(height: 12),
            const Text('👨‍👩‍👧 أدوات المتابعة', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const ListTile(leading: Text('🔎'), title: Text('المهارات الضعيفة'), subtitle: Text('تظهر هنا عند إضافة نتائج الأنشطة والاختبارات التفصيلية.')),
            const ListTile(leading: Text('⏱️'), title: Text('وقت التعلم'), subtitle: Text('يمكن توسيعه مع تسجيل مدة كل درس ونشاط.')),
            const ListTile(leading: Text('🛍️'), title: Text('مشتريات المتجر'), subtitle: Text('تتم قراءة العناصر المشتراة من التخزين المحلي.')),
          ]),
        ),
      ),
    );
  }

  Widget _stat(String title, String value) => Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title), Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))]));

  Future<_StageProgress> _stageProgress(CurriculumStageV8 stage) async {
    var done = 0;
    for (final unit in stage.units) { if (await ProgressV8.lessonDone(unit.id)) done++; }
    return _StageProgress(done, stage.units.length);
  }
}

class _StageProgress { final int done, total; const _StageProgress(this.done, this.total); }
