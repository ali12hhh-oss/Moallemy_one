class MathSkillV14 {
  final String id;
  final int grade;
  final String title;
  final String category;
  final int maxNumber;
  const MathSkillV14({
    required this.id,
    required this.grade,
    required this.title,
    required this.category,
    required this.maxNumber,
  });
}

const mathCurriculumV14 = <MathSkillV14>[
  MathSkillV14(
    id: 'count_10',
    grade: 1,
    title: 'العد حتى ١٠',
    category: 'العد',
    maxNumber: 10,
  ),
  MathSkillV14(
    id: 'addition_10',
    grade: 1,
    title: 'الجمع حتى ١٠',
    category: 'الجمع',
    maxNumber: 10,
  ),
  MathSkillV14(
    id: 'subtraction_10',
    grade: 1,
    title: 'الطرح حتى ١٠',
    category: 'الطرح',
    maxNumber: 10,
  ),
  MathSkillV14(
    id: 'place_100',
    grade: 1,
    title: 'القيمة المكانية حتى ١٠٠',
    category: 'القيمة المكانية',
    maxNumber: 100,
  ),
  MathSkillV14(
    id: 'ascending_100',
    grade: 1,
    title: 'الترتيب التصاعدي',
    category: 'الترتيب',
    maxNumber: 100,
  ),
  MathSkillV14(
    id: 'descending_100',
    grade: 1,
    title: 'الترتيب التنازلي',
    category: 'الترتيب',
    maxNumber: 100,
  ),
  MathSkillV14(
    id: 'compare_100',
    grade: 1,
    title: 'أكبر وأصغر ويساوي',
    category: 'المقارنة',
    maxNumber: 100,
  ),
  MathSkillV14(
    id: 'addition_100',
    grade: 2,
    title: 'الجمع حتى ١٠٠',
    category: 'الجمع',
    maxNumber: 100,
  ),
  MathSkillV14(
    id: 'subtraction_100',
    grade: 2,
    title: 'الطرح حتى ١٠٠',
    category: 'الطرح',
    maxNumber: 100,
  ),
  MathSkillV14(
    id: 'place_1000',
    grade: 2,
    title: 'القيمة المكانية حتى ١٬٠٠٠',
    category: 'القيمة المكانية',
    maxNumber: 1000,
  ),
  MathSkillV14(
    id: 'patterns_100',
    grade: 2,
    title: 'الأنماط العددية',
    category: 'الأنماط',
    maxNumber: 100,
  ),
  MathSkillV14(
    id: 'ascending_1000',
    grade: 2,
    title: 'الترتيب التصاعدي والتنازلي',
    category: 'الترتيب',
    maxNumber: 1000,
  ),
  MathSkillV14(
    id: 'compare_1000',
    grade: 2,
    title: 'مقارنة الأعداد',
    category: 'المقارنة',
    maxNumber: 1000,
  ),
  MathSkillV14(
    id: 'addition_1000',
    grade: 3,
    title: 'الجمع حتى ١٬٠٠٠',
    category: 'الجمع',
    maxNumber: 1000,
  ),
  MathSkillV14(
    id: 'subtraction_1000',
    grade: 3,
    title: 'الطرح حتى ١٬٠٠٠',
    category: 'الطرح',
    maxNumber: 1000,
  ),
  MathSkillV14(
    id: 'place_1000000',
    grade: 3,
    title: 'القيمة المكانية حتى ١٬٠٠٠٬٠٠٠',
    category: 'القيمة المكانية',
    maxNumber: 1000000,
  ),
  MathSkillV14(
    id: 'patterns_1000',
    grade: 3,
    title: 'الأنماط العددية المتقدمة',
    category: 'الأنماط',
    maxNumber: 1000,
  ),
  MathSkillV14(
    id: 'word_problems',
    grade: 3,
    title: 'المسائل اللفظية',
    category: 'المسائل',
    maxNumber: 1000,
  ),
  MathSkillV14(
    id: 'ascending_1000000',
    grade: 3,
    title: 'ترتيب الأعداد الكبيرة',
    category: 'الترتيب',
    maxNumber: 1000000,
  ),
  MathSkillV14(
    id: 'rounding',
    grade: 3,
    title: 'التقريب والتقدير',
    category: 'الأعداد',
    maxNumber: 1000000,
  ),
];

List<MathSkillV14> mathSkillsForGradeV14(int grade) =>
    mathCurriculumV14.where((s) => s.grade == grade).toList();
