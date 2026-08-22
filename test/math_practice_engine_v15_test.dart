import 'package:flutter_test/flutter_test.dart';
import 'package:daleel_child/core/math/math_practice_engine_v15.dart';

void main() {
  test('توليد الجمع صحيح ضمن الحد', () {
    final q = MathPracticeEngineV15.addition(skillId: 'x', max: 10);
    expect(q.answer, greaterThanOrEqualTo(0));
    expect(q.answer, lessThanOrEqualTo(10));
    expect(q.options.contains(q.answer), true);
  });

  test('توليد الطرح لا يعطي نتيجة سالبة', () {
    final q = MathPracticeEngineV15.subtraction(skillId: 'x', max: 20);
    expect(q.answer, greaterThanOrEqualTo(0));
    expect(q.options.contains(q.answer), true);
  });

  test('المقارنة تستخدم ثلاث إجابات صحيحة', () {
    final q = MathPracticeEngineV15.comparison(skillId: 'x', max: 20);
    expect(q.options, contains(q.answer));
    expect(q.options.length, 3);
  });

  test('العدد الناقص يضم الإجابة', () {
    final q = MathPracticeEngineV15.missingNumber(skillId: 'x', max: 20);
    expect(q.options, contains(q.answer));
  });
}
