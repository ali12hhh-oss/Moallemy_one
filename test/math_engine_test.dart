import 'package:flutter_test/flutter_test.dart';

import '../lib/core/math/math_practice_engine_v15.dart';

void main() {
  test('math generators always provide four distinct options', () {
    for (var i = 0; i < 100; i++) {
      final addition = MathPracticeEngineV15.addition(skillId: 'test', max: 10);
      final subtraction =
          MathPracticeEngineV15.subtraction(skillId: 'test', max: 10);
      final multiplication =
          MathPracticeEngineV15.multiplication(skillId: 'test', table: 1);
      expect(addition.options.length, 4);
      expect(addition.options.toSet().length, 4);
      expect(subtraction.options.length, 4);
      expect(subtraction.options.toSet().length, 4);
      expect(multiplication.options.length, 4);
      expect(multiplication.options.toSet().length, 4);
    }
  });

  test('comparison exposes real symbols instead of numeric codes', () {
    final q = MathPracticeEngineV15.comparison(skillId: 'test', max: 10);
    expect(q.optionLabels, ['>', '=', '<']);
  });

  test('pattern answer stays within the configured maximum', () {
    for (var i = 0; i < 100; i++) {
      final q = MathPracticeEngineV15.pattern(skillId: 'test', max: 20);
      expect(q.answer, lessThanOrEqualTo(20));
    }
  });
}
