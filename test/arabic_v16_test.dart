
import 'package:flutter_test/flutter_test.dart';
import 'package:daleel_child/core/arabic/arabic_practice_engine_v16.dart';
import 'package:daleel_child/data/arabic_curriculum_v16.dart';

void main() {
  test('الحركات تولد سؤالاً وإجابة صحيحة ضمن الخيارات', () {
    final q = ArabicPracticeEngineV16.harakat('harakat');
    expect(q.options, contains(q.answer));
    expect(q.answer.isNotEmpty, true);
  });

  test('حروف الجر تولد إجابة ضمن الخيارات', () {
    final q = ArabicPracticeEngineV16.preposition('prepositions');
    expect(q.options, contains(q.answer));
  });

  test('تركيب الجملة يولد إجابة ضمن الخيارات', () {
    final q = ArabicPracticeEngineV16.sentenceBuilding('sentence_building');
    expect(q.options, contains(q.answer));
  });

  test('المنهج يحتوي مراحل الصفوف الثلاثة', () {
    expect(arabicSkillsForGradeV16(1).isNotEmpty, true);
    expect(arabicSkillsForGradeV16(2).isNotEmpty, true);
    expect(arabicSkillsForGradeV16(3).isNotEmpty, true);
  });
}
