import 'package:flutter/material.dart';

import '../../data/math_curriculum_v14.dart';
import 'math_practice_v14.dart';
import '../../core/math/math_skills_engine_v14.dart';

class MathCurriculumScreenV14 extends StatelessWidget {
  final int grade;
  const MathCurriculumScreenV14({super.key, required this.grade});
  String ar(int n) =>
      n.toString().split('').map((d) => '٠١٢٣٤٥٦٧٨٩'[int.parse(d)]).join();
  @override
  Widget build(BuildContext context) {
    final skills = mathSkillsForGradeV14(grade);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('رياضيات الصف ${ar(grade)}')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'مسار رياضيات متدرج: ${skills.length} مهارات تعليمية مع حفظ الإتقان Offline.',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            ...skills.map(
              (s) => FutureBuilder<int>(
                future: MathSkillsEngineV14.mastery(s.id),
                builder: (c, snap) {
                  final m = snap.data ?? 0;
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.calculate_outlined),
                      title: Text(s.title),
                      subtitle: Text('الإتقان ${ar(m)}٪'),
                      trailing: const Icon(Icons.arrow_back_ios_new),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MathPracticeV14(skill: s),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
