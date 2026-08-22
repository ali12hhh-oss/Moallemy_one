import 'package:flutter_test/flutter_test.dart';
import 'package:daleel_child/data/math_curriculum_v14.dart';

void main() {
  test('المسار الرياضي حسب الصف', () {
    expect(mathSkillsForGradeV14(1).isNotEmpty, true);
    expect(mathSkillsForGradeV14(2).any((s) => s.id == 'addition_100'), true);
    expect(mathSkillsForGradeV14(3).any((s) => s.id == 'word_problems'), true);
    expect(mathCurriculumV14.first.maxNumber, 10);
    expect(
      mathCurriculumV14
          .where((s) => s.grade == 3)
          .any((s) => s.maxNumber == 1000000),
      true,
    );
  });
}
