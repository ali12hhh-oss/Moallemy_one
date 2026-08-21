
class MultiplicationTableV13 {
  final int table;
  final int grade;
  final bool optional;
  const MultiplicationTableV13({
    required this.table,
    required this.grade,
    required this.optional,
  });
}

const multiplicationCurriculumV13 = <MultiplicationTableV13>[
  MultiplicationTableV13(table: 1, grade: 1, optional: true),
  MultiplicationTableV13(table: 2, grade: 1, optional: true),
  MultiplicationTableV13(table: 1, grade: 2, optional: false),
  MultiplicationTableV13(table: 2, grade: 2, optional: false),
  MultiplicationTableV13(table: 3, grade: 2, optional: false),
  MultiplicationTableV13(table: 4, grade: 2, optional: false),
  MultiplicationTableV13(table: 5, grade: 2, optional: false),
  MultiplicationTableV13(table: 1, grade: 3, optional: false),
  MultiplicationTableV13(table: 2, grade: 3, optional: false),
  MultiplicationTableV13(table: 3, grade: 3, optional: false),
  MultiplicationTableV13(table: 4, grade: 3, optional: false),
  MultiplicationTableV13(table: 5, grade: 3, optional: false),
  MultiplicationTableV13(table: 6, grade: 3, optional: false),
  MultiplicationTableV13(table: 7, grade: 3, optional: false),
  MultiplicationTableV13(table: 8, grade: 3, optional: false),
  MultiplicationTableV13(table: 9, grade: 3, optional: false),
  MultiplicationTableV13(table: 10, grade: 3, optional: false),
];

List<MultiplicationTableV13> tablesForGradeV13(int grade) =>
    multiplicationCurriculumV13.where((x) => x.grade == grade).toList();
