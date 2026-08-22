class ArabicSkillV16 {
  final String id;
  final int grade;
  final String title;
  final String category;
  final String description;
  const ArabicSkillV16({
    required this.id,
    required this.grade,
    required this.title,
    required this.category,
    required this.description,
  });
}

const arabicCurriculumV16 = <ArabicSkillV16>[
  ArabicSkillV16(
    id: 'harakat',
    grade: 1,
    title: 'الحركات القصيرة',
    category: 'الصوتيات',
    description: 'تمييز الفتحة والكسرة والضمة مع نطق الصوت.',
  ),
  ArabicSkillV16(
    id: 'sukun',
    grade: 1,
    title: 'السكون',
    category: 'الصوتيات',
    description: 'قراءة المقاطع التي تحتوي على السكون.',
  ),
  ArabicSkillV16(
    id: 'shadda',
    grade: 1,
    title: 'الشدة',
    category: 'الصوتيات',
    description: 'تمييز الحرف المشدد وقراءة المقطع.',
  ),
  ArabicSkillV16(
    id: 'tanween',
    grade: 1,
    title: 'التنوين',
    category: 'الصوتيات',
    description: 'تمييز تنوين الفتح والضم والكسر.',
  ),
  ArabicSkillV16(
    id: 'long_vowels',
    grade: 1,
    title: 'حروف المد',
    category: 'الصوتيات',
    description: 'المد بالألف والواو والياء.',
  ),
  ArabicSkillV16(
    id: 'syllables',
    grade: 1,
    title: 'المقاطع الصوتية',
    category: 'القراءة',
    description: 'دمج المقاطع لتكوين كلمات بسيطة.',
  ),
  ArabicSkillV16(
    id: 'word_building',
    grade: 1,
    title: 'تركيب الكلمات',
    category: 'القراءة',
    description: 'تركيب كلمة من حروف ومقاطع.',
  ),
  ArabicSkillV16(
    id: 'two_letter_words',
    grade: 1,
    title: 'كلمات من حرفين',
    category: 'التهجي',
    description: 'قراءة وتهجي كلمات بسيطة من حرفين مع التشكيل.',
  ),
  ArabicSkillV16(
    id: 'three_letter_words',
    grade: 1,
    title: 'كلمات من ثلاثة أحرف',
    category: 'التهجي',
    description: 'دمج ثلاثة أحرف لتكوين كلمات قصيرة وقراءتها.',
  ),
  ArabicSkillV16(
    id: 'sun_moon_lam',
    grade: 2,
    title: 'اللام الشمسية والقمرية',
    category: 'القراءة',
    description: 'تمييز نوع اللام في الكلمات وقراءتها.',
  ),
  ArabicSkillV16(
    id: 'prepositions',
    grade: 2,
    title: 'حروف الجر',
    category: 'القواعد',
    description:
        'استخدام من وإلى وعن وعلى وفي والباء واللام والكاف في جمل بسيطة.',
  ),
  ArabicSkillV16(
    id: 'al_definition',
    grade: 2,
    title: 'الـ التعريف',
    category: 'القواعد',
    description: 'تمييز الاسم المعرف بـال واستخدامه في جملة.',
  ),
  ArabicSkillV16(
    id: 'singular_plural',
    grade: 2,
    title: 'المفرد والجمع',
    category: 'القواعد',
    description: 'تمييز المفرد والجمع وتكوين أزواج بسيطة.',
  ),
  ArabicSkillV16(
    id: 'masculine_feminine',
    grade: 2,
    title: 'المذكر والمؤنث',
    category: 'القواعد',
    description: 'تمييز المذكر والمؤنث في كلمات مألوفة.',
  ),
  ArabicSkillV16(
    id: 'sentence_building',
    grade: 2,
    title: 'تكوين الجملة',
    category: 'الكتابة',
    description: 'ترتيب كلمات لتكوين جملة مفيدة.',
  ),
  ArabicSkillV16(
    id: 'spelling',
    grade: 2,
    title: 'الإملاء',
    category: 'الكتابة',
    description: 'اختيار الحرف أو الكلمة الصحيحة في تدريبات إملائية.',
  ),
  ArabicSkillV16(
    id: 'dual',
    grade: 2,
    title: 'المثنى',
    category: 'القواعد',
    description: 'تمييز المفرد والمثنى والجمع في كلمات مألوفة.',
  ),
  ArabicSkillV16(
    id: 'verb_noun',
    grade: 3,
    title: 'الاسم والفعل',
    category: 'القواعد',
    description: 'تمييز الاسم والفعل في جمل قصيرة.',
  ),
  ArabicSkillV16(
    id: 'subject_predicate',
    grade: 3,
    title: 'المبتدأ والخبر',
    category: 'القواعد',
    description: 'تكوين جمل اسمية بسيطة وتمييز المبتدأ والخبر.',
  ),
  ArabicSkillV16(
    id: 'word_analysis',
    grade: 3,
    title: 'تحليل الكلمة',
    category: 'القراءة',
    description: 'تحديد الحروف والمقاطع والحركات داخل الكلمة.',
  ),
  ArabicSkillV16(
    id: 'paragraph_reading',
    grade: 3,
    title: 'قراءة الفقرات',
    category: 'القراءة',
    description: 'قراءة فقرات قصيرة ثم الإجابة عن أسئلة الفهم.',
  ),
  ArabicSkillV16(
    id: 'grammar_sentence',
    grade: 3,
    title: 'الجملة الاسمية والفعلية',
    category: 'القواعد',
    description: 'تمييز نوع الجملة وترتيب عناصرها الأساسية.',
  ),
  ArabicSkillV16(
    id: 'reading_comprehension',
    grade: 3,
    title: 'الفهم القرائي',
    category: 'الفهم',
    description: 'قراءة نص قصير والإجابة عن أسئلة مباشرة واستنتاجية.',
  ),
];

List<ArabicSkillV16> arabicSkillsForGradeV16(int grade) =>
    arabicCurriculumV16.where((s) => s.grade == grade).toList();
