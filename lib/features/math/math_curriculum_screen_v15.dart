import 'package:flutter/material.dart';

import '../../data/math_curriculum_v15.dart';
import '../../core/math/math_practice_engine_v15.dart';
import 'math_practice_v15.dart';
import 'math_story_game_v15.dart';

class MathCurriculumScreenV15 extends StatelessWidget {
  final int grade;
  const MathCurriculumScreenV15({super.key, required this.grade});

  String ar(int n) => MathPracticeEngineV15.ar(n);

  @override
  Widget build(BuildContext context) {
    final skills = mathSkillsForGradeV15(grade);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('رياضيات الصف ${ar(grade)}')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'كل مهارة هنا تدريب حقيقي يحفظ نتيجته على الجهاز.',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.extension_rounded),
                title: const Text('لعبة المسألة المصورة'),
                subtitle: const Text('تطبيق الجمع والطرح في موقف قصصي حقيقي'),
                trailing: const Icon(Icons.arrow_back_ios_new),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MathStoryGameV15(grade: grade),
                  ),
                ),
              ),
            ),
            ...skills.map(
              (skill) => FutureBuilder<int>(
                future: MathPracticeEngineV15.mastery(skill.id),
                builder: (context, snapshot) {
                  final mastery = snapshot.data ?? 0;
                  final playable = {
                    'الجمع',
                    'الطرح',
                    'المقارنة',
                    'العدد الناقص',
                    'القيمة المكانية',
                    'الأنماط',
                    'الترتيب',
                  }.contains(skill.category);
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.calculate_outlined),
                      title: Text(skill.title),
                      subtitle: Text('الإتقان ${ar(mastery)}٪'),
                      trailing: const Icon(Icons.arrow_back_ios_new),
                      onTap: playable
                          ? () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MathPracticeV15(
                                  skillId: skill.id,
                                  title: skill.title,
                                  category: skill.category,
                                  maxNumber: skill.maxNumber,
                                ),
                              ),
                            )
                          : null,
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
