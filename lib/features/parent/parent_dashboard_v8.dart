import 'package:flutter/material.dart';

import '../../core/adaptive/adaptive_learning_engine_v24.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../core/storage/app_storage.dart';
import '../../core/storage/progress_v8.dart';
import '../../data/curriculum_v8.dart';

class ParentDashboardV8 extends StatefulWidget {
  const ParentDashboardV8({super.key});
  @override
  State<ParentDashboardV8> createState() => _ParentDashboardV8State();
}

class _ParentDashboardV8State extends State<ParentDashboardV8> {
  Map<String, dynamic> state = {};
  List<String> weakSkills = const [];
  String childName = 'الطفل';
  int learningMinutes = 0;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    final progress = await ProgressV8.load();
    final weak = await AdaptiveLearningEngineV24.weakSkills();
    final children = await AppStorage.getChildren();
    final activeId = await AppStorage.activeId();
    dynamic child;
    for (final item in children) {
      if (item.id == activeId) {
        child = item;
        break;
      }
    }
    if (!mounted) return;
    setState(() {
      state = progress;
      weakSkills = weak;
      childName = child?.name?.toString() ?? 'الطفل';
      learningMinutes = child?.minutes is int ? child.minutes as int : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final done = List<String>.from(state['done'] ?? const <String>[]);
    final badges = List<String>.from(state['badges'] ?? const <String>[]);
    final exams = Map<String, dynamic>.from(state['finalExams'] ?? const {});
    final owned = List<String>.from(state['ownedItems'] ?? const <String>[]);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('مركز الوالدين • $childName')),
        body: RefreshIndicator(
          onRefresh: _reload,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('📊 تقدم $childName', style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      _stat('⭐ النجوم', arNum(state['stars'] ?? 0)),
                      _stat('✨ XP', arNum(state['xp'] ?? 0)),
                      _stat('📚 الدروس المكتملة', arNum(done.length)),
                      _stat('🏆 الاختبارات', arNum(exams.length)),
                      _stat('⏱️ دقائق التعلم', arNum(learningMinutes)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text('🎓 تقدم المراحل', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...curriculumV8.map(
                (stage) => FutureBuilder<_StageProgress>(
                  future: _stageProgress(stage),
                  builder: (_, snap) {
                    final p = snap.data ?? const _StageProgress(0, 0);
                    final value = p.total == 0 ? 0.0 : p.done / p.total;
                    final exam = exams[stage.id];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: Text(stage.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                                Text('${arNum(p.done)} / ${arNum(p.total)}'),
                              ],
                            ),
                            const SizedBox(height: 7),
                            LinearProgressIndicator(value: value, minHeight: 8),
                            if (exam != null) ...[
                              const SizedBox(height: 7),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  exam['passed'] == true
                                      ? '🏅 الاختبار النهائي: ناجح (${arNum(exam['bestScore'] ?? exam['score'] ?? 0)})'
                                      : '🔄 الاختبار النهائي: يحتاج مراجعة',
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              const Text('🧠 المهارات التي تحتاج تدريباً', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (weakSkills.isEmpty)
                const Card(child: ListTile(title: Text('لا توجد مهارات ضعيفة مؤكدة حالياً'), subtitle: Text('يحتاج النظام إلى خمس محاولات على الأقل قبل تصنيف المهارة.')))
              else
                ...weakSkills.map((skill) => Card(child: ListTile(leading: const Icon(Icons.school_rounded), title: Text(skill)))),
              const SizedBox(height: 12),
              const Text('🏅 الإنجازات', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: badges.isEmpty ? [const Chip(label: Text('لا توجد إنجازات بعد'))] : badges.map((b) => Chip(label: Text(b))).toList(),
              ),
              const SizedBox(height: 12),
              const Text('🛍️ مشتريات المتجر', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (owned.isEmpty)
                const Card(child: ListTile(title: Text('لا توجد مشتريات بعد')))
              else
                ...owned.map((id) => Card(child: ListTile(leading: const Icon(Icons.check_circle_rounded), title: Text(id)))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(String title, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title), Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))]),
      );

  Future<_StageProgress> _stageProgress(CurriculumStageV8 stage) async {
    var done = 0;
    for (final unit in stage.units) {
      if (await ProgressV8.lessonDone(unit.id)) done++;
    }
    return _StageProgress(done, stage.units.length);
  }
}

class _StageProgress {
  final int done;
  final int total;
  const _StageProgress(this.done, this.total);
}
