class LessonUnit {
  final String id, title, description, icon;
  final int minutes, stars;
  final List<String> skills;
  const LessonUnit(
    this.id,
    this.title,
    this.description,
    this.icon,
    this.minutes,
    this.stars,
    this.skills,
  );
}

class CurriculumStage {
  final String id, title, age;
  final List<LessonUnit> units;
  const CurriculumStage(this.id, this.title, this.age, this.units);
}

const curriculum = [
  CurriculumStage('kg1', 'الروضة الأولى', '٣–٤ سنوات', [
    LessonUnit(
      'kg1_colors',
      'الألوان',
      'تعرف الألوان الأساسية من خلال الصور',
      '🎨',
      8,
      5,
      ['تمييز الألوان'],
    ),
    LessonUnit(
      'kg1_shapes',
      'الأشكال',
      'دائرة ومربع ومثلث ومستطيل',
      '🔺',
      8,
      5,
      ['تمييز الأشكال'],
    ),
    LessonUnit('kg1_listen', 'استمع وميّز', 'أصوات وصور ومطابقة', '👂', 7, 5, [
      'الاستماع',
    ]),
    LessonUnit('kg1_numbers', 'الأعداد', 'الأعداد من ١ إلى ٥', '🔢', 8, 5, [
      'الأعداد',
    ]),
  ]),
  CurriculumStage('kg2', 'الروضة الثانية', '٤–٥ سنوات', [
    LessonUnit(
      'kg2_letters',
      'حروفنا الأولى',
      'تمييز الحروف العربية بالصوت والصورة',
      '🔤',
      10,
      7,
      ['تمييز الحروف'],
    ),
    LessonUnit('kg2_words', 'كلمة وصورة', 'ربط الكلمة بالصورة', '🖼️', 10, 7, [
      'المفردات',
    ]),
    LessonUnit(
      'kg2_write',
      'ارسم الحرف',
      'تدريب مبسط على مسار الحرف',
      '✏️',
      10,
      8,
      ['الكتابة'],
    ),
    LessonUnit('kg2_count', 'عدّ الأشياء', 'عدّ من ١ إلى ١٠', '🔢', 8, 6, [
      'العد',
    ]),
  ]),
  CurriculumStage('prep', 'التمهيدي', '٥–٦ سنوات', [
    LessonUnit(
      'prep_vowels',
      'الحركات',
      'الفتحة والكسرة والضمة والسكون',
      'َ',
      12,
      9,
      ['الحركات'],
    ),
    LessonUnit(
      'prep_spelling',
      'التهجي',
      'بناء كلمات قصيرة بالمقاطع',
      '🧩',
      12,
      10,
      ['التهجي'],
    ),
    LessonUnit('prep_read', 'قراءة أولى', 'كلمات وجمل قصيرة', '📖', 12, 10, [
      'القراءة',
    ]),
    LessonUnit('prep_dict', 'إملاء بسيط', 'استمع واكتب الكلمة', '📝', 10, 9, [
      'الإملاء',
    ]),
  ]),
  CurriculumStage('g1', 'الصف الأول', '٦–٧ سنوات', [
    LessonUnit(
      'g1_arabic',
      'العربية الأساسية',
      'الحروف والحركات والكلمات',
      '🇦🇪',
      15,
      12,
      ['العربية'],
    ),
    LessonUnit('g1_read', 'القراءة', 'قراءة كلمات ثم جمل قصيرة', '📚', 15, 12, [
      'القراءة',
    ]),
    LessonUnit('g1_write', 'الكتابة', 'كتابة الحروف والكلمات', '✍️', 15, 12, [
      'الكتابة',
    ]),
    LessonUnit(
      'g1_eng_phonics',
      'English Phonics',
      'حروف وأصوات English',
      '🔤',
      12,
      10,
      ['phonics'],
    ),
    LessonUnit(
      'g1_eng_words',
      'English Words',
      'كلمات وألوان وأرقام بسيطة',
      '🇬🇧',
      12,
      10,
      ['words'],
    ),
  ]),
  CurriculumStage('g2', 'الصف الثاني', '٧–٨ سنوات', [
    LessonUnit(
      'g2_read',
      'فهم المقروء',
      'نصوص قصيرة وأسئلة فهم',
      '📖',
      18,
      15,
      ['الفهم'],
    ),
    LessonUnit('g2_spelling', 'الإملاء', 'كلمات وجمل متدرجة', '📝', 15, 14, [
      'الإملاء',
    ]),
    LessonUnit(
      'g2_grammar',
      'لغة عربية',
      'مفرد وجمع وتذكير وتأنيث بشكل مبسط',
      '🧠',
      15,
      14,
      ['اللغة'],
    ),
    LessonUnit(
      'g2_eng_sentences',
      'English Sentences',
      'جمل إنكليزية قصيرة',
      '🇬🇧',
      15,
      12,
      ['sentences'],
    ),
  ]),
  CurriculumStage('g3', 'الصف الثالث', '٨–٩ سنوات', [
    LessonUnit(
      'g3_read',
      'قراءة متقدمة',
      'فقرات قصيرة واستخراج الفكرة',
      '📘',
      20,
      18,
      ['القراءة'],
    ),
    LessonUnit('g3_expression', 'التعبير', 'كوّن جملة وفق صورة', '💡', 18, 18, [
      'التعبير',
    ]),
    LessonUnit(
      'g3_dict',
      'إملاء متقدم',
      'استماع وكتابة ومراجعة',
      '📝',
      18,
      17,
      ['الإملاء'],
    ),
    LessonUnit(
      'g3_eng_read',
      'English Reading',
      'قراءة نصوص بسيطة',
      '🇬🇧',
      18,
      15,
      ['reading'],
    ),
  ]),
];
