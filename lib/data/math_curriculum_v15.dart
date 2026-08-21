
class MathSkillV15 {
  final String id;
  final int grade;
  final String title;
  final String category;
  final int maxNumber;
  final bool required;
  const MathSkillV15({
    required this.id,
    required this.grade,
    required this.title,
    required this.category,
    required this.maxNumber,
    required this.required,
  });
}

const mathCurriculumV15 = <MathSkillV15>[
  MathSkillV15(id:'count_10',grade:1,title:'العد حتى ١٠',category:'العد',maxNumber:10,required:true),
  MathSkillV15(id:'addition_10',grade:1,title:'الجمع حتى ١٠',category:'الجمع',maxNumber:10,required:true),
  MathSkillV15(id:'subtraction_10',grade:1,title:'الطرح حتى ١٠',category:'الطرح',maxNumber:10,required:true),
  MathSkillV15(id:'comparison_20',grade:1,title:'مقارنة الأعداد حتى ٢٠',category:'المقارنة',maxNumber:20,required:true),
  MathSkillV15(id:'missing_20',grade:1,title:'العدد الناقص حتى ٢٠',category:'العدد الناقص',maxNumber:20,required:true),
  MathSkillV15(id:'place_100',grade:1,title:'الآحاد والعشرات',category:'القيمة المكانية',maxNumber:100,required:true),
  MathSkillV15(id:'ascending_100',grade:1,title:'الترتيب التصاعدي',category:'الترتيب',maxNumber:100,required:true),
  MathSkillV15(id:'descending_100',grade:1,title:'الترتيب التنازلي',category:'الترتيب',maxNumber:100,required:true),

  MathSkillV15(id:'addition_100',grade:2,title:'الجمع حتى ١٠٠',category:'الجمع',maxNumber:100,required:true),
  MathSkillV15(id:'subtraction_100',grade:2,title:'الطرح حتى ١٠٠',category:'الطرح',maxNumber:100,required:true),
  MathSkillV15(id:'comparison_1000',grade:2,title:'مقارنة الأعداد حتى ١٬٠٠٠',category:'المقارنة',maxNumber:1000,required:true),
  MathSkillV15(id:'place_1000',grade:2,title:'القيمة المكانية حتى ١٬٠٠٠',category:'القيمة المكانية',maxNumber:1000,required:true),
  MathSkillV15(id:'patterns_100',grade:2,title:'الأنماط العددية',category:'الأنماط',maxNumber:100,required:true),
  MathSkillV15(id:'missing_100',grade:2,title:'العدد الناقص حتى ١٠٠',category:'العدد الناقص',maxNumber:100,required:true),
  MathSkillV15(id:'ascending_1000',grade:2,title:'الترتيب التصاعدي والتنازلي',category:'الترتيب',maxNumber:1000,required:true),

  MathSkillV15(id:'addition_1000',grade:3,title:'الجمع حتى ١٬٠٠٠',category:'الجمع',maxNumber:1000,required:true),
  MathSkillV15(id:'subtraction_1000',grade:3,title:'الطرح حتى ١٬٠٠٠',category:'الطرح',maxNumber:1000,required:true),
  MathSkillV15(id:'comparison_1000000',grade:3,title:'مقارنة الأعداد حتى ١٬٠٠٠٬٠٠٠',category:'المقارنة',maxNumber:1000000,required:true),
  MathSkillV15(id:'place_1000000',grade:3,title:'القيمة المكانية حتى ١٬٠٠٠٬٠٠٠',category:'القيمة المكانية',maxNumber:1000000,required:true),
  MathSkillV15(id:'patterns_1000',grade:3,title:'الأنماط العددية المتقدمة',category:'الأنماط',maxNumber:1000,required:true),
  MathSkillV15(id:'missing_1000',grade:3,title:'العدد الناقص حتى ١٬٠٠٠',category:'العدد الناقص',maxNumber:1000,required:true),
  MathSkillV15(id:'word_problems_g3',grade:3,title:'المسائل اللفظية',category:'المسائل',maxNumber:1000,required:true),
  MathSkillV15(id:'ascending_1000000',grade:3,title:'ترتيب الأعداد الكبيرة',category:'الترتيب',maxNumber:1000000,required:true),
];

List<MathSkillV15> mathSkillsForGradeV15(int grade) =>
    mathCurriculumV15.where((s) => s.grade == grade).toList();
