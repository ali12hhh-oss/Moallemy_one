import 'package:flutter/material.dart';

import '../../data/arabic_curriculum_v16.dart';
import '../../core/arabic/arabic_practice_engine_v16.dart';
import 'arabic_practice_v16.dart';

class ArabicCurriculumScreenV16 extends StatelessWidget {
  final int grade;
  const ArabicCurriculumScreenV16({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    final skills = arabicSkillsForGradeV16(grade);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'اللغة العربية — الصف ${ArabicPracticeEngineV16.arabicNumber(grade)}',
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'منهج عربي متدرج: صوتيات وقراءة وقواعد وكتابة وفهم. كل تدريب يصحح الإجابة ويحفظ إتقان المهارة.',
                  style: TextStyle(fontSize: 18, height: 1.5),
                ),
              ),
            ),
            ...skills.map(
              (skill) => FutureBuilder<int>(
                future: ArabicPracticeEngineV16.mastery(skill.id),
                builder: (context, snapshot) {
                  final mastery = snapshot.data ?? 0;
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.menu_book_rounded),
                      title: Text(skill.title),
                      subtitle: Text(
                        '${skill.category} — الإتقان ${ArabicPracticeEngineV16.arabicNumber(mastery)}٪',
                      ),
                      trailing: const Icon(Icons.arrow_back_ios_new),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ArabicPracticeV16(
                            skillId: skill.id,
                            title: skill.title,
                          ),
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
