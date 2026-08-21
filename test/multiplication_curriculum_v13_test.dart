
import 'package:flutter_test/flutter_test.dart';
import 'package:daleel_child/data/multiplication_curriculum_v13.dart';

void main() {
  test('جدول الضرب حسب الصف', () {
    expect(tablesForGradeV13(1).map((e) => e.table).toList(), [1, 2]);
    expect(tablesForGradeV13(2).map((e) => e.table).toList(), [1, 2, 3, 4, 5]);
    expect(tablesForGradeV13(3).map((e) => e.table).toList(), [1,2,3,4,5,6,7,8,9,10]);
    expect(tablesForGradeV13(1).every((e) => e.optional), true);
    expect(tablesForGradeV13(2).every((e) => !e.optional), true);
    expect(tablesForGradeV13(3).every((e) => !e.optional), true);
  });
}
