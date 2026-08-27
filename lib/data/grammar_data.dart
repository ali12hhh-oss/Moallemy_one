/// بيانات قواعد اللغة العربية للصف الثاني والثالث: كل موضوع يُشرح بخطوات
/// مبسّطة (تعريف قصير) ثم أمثلة، ثم تدريب (اختيار من متعدد) بنفس نمط باقي
/// التطبيق.
///
/// ١) ال التعريف: كلمة نكرة (بدون "ال") تصبح معرفة بإضافة "ال" في البداية.
class DefiniteArticlePair {
  final String bare;
  final String defined;
  final String emoji;
  const DefiniteArticlePair(this.bare, this.defined, this.emoji);
}

const definiteArticlePairs = <DefiniteArticlePair>[
  DefiniteArticlePair('قلم', 'القلم', '✏️'),
  DefiniteArticlePair('بيت', 'البيت', '🏠'),
  DefiniteArticlePair('كتاب', 'الكتاب', '📚'),
  DefiniteArticlePair('شمس', 'الشمس', '☀️'),
  DefiniteArticlePair('قمر', 'القمر', '🌙'),
  DefiniteArticlePair('ولد', 'الولد', '👦'),
  DefiniteArticlePair('باب', 'الباب', '🚪'),
  DefiniteArticlePair('كرة', 'الكرة', '⚽'),
];

/// ٢) مفرد / مثنى / جمع
class NumberForm {
  final String singular;
  final String dual;
  final String plural;
  final String emoji;
  const NumberForm(this.singular, this.dual, this.plural, this.emoji);
}

const numberForms = <NumberForm>[
  NumberForm('كتاب', 'كتابان', 'كتب', '📚'),
  NumberForm('ولد', 'ولدان', 'أولاد', '👦'),
  NumberForm('قلم', 'قلمان', 'أقلام', '✏️'),
  NumberForm('بنت', 'بنتان', 'بنات', '👧'),
  NumberForm('باب', 'بابان', 'أبواب', '🚪'),
  NumberForm('بيت', 'بيتان', 'بيوت', '🏠'),
  NumberForm('مهندس', 'مهندسان', 'مهندسون', '👷'),
  NumberForm('ممرضة', 'ممرضتان', 'ممرضات', '👩‍⚕️'),
  NumberForm('محمد', 'محمدان', 'محمدون', '👦'),
];

/// ٣) مؤنث / مذكر
class GenderPair {
  final String masculine;
  final String feminine;
  final String emojiM;
  final String emojiF;
  const GenderPair(this.masculine, this.feminine, this.emojiM, this.emojiF);
}

const genderPairs = <GenderPair>[
  GenderPair('ولد', 'بنت', '👦', '👧'),
  GenderPair('معلم', 'معلمة', '👨‍🏫', '👩‍🏫'),
  GenderPair('طالب', 'طالبة', '🧑‍🎓', '👩‍🎓'),
  GenderPair('قط', 'قطة', '🐱', '🐈'),
  GenderPair('أسد', 'لبؤة', '🦁', '🐆'),
  GenderPair('ملك', 'ملكة', '🤴', '👸'),
  GenderPair('طبيب', 'طبيبة', '👨‍⚕️', '👩‍⚕️'),
  GenderPair('مهندس', 'مهندسة', '👷', '👷‍♀️'),
  GenderPair('ممرض', 'ممرضة', '👨‍⚕️', '👩‍⚕️'),
  GenderPair('كاتب', 'كاتبة', '🧑‍💻', '👩‍💻'),
];

/// ٤) اسم / فعل — تصنيف كلمة إلى اسم أو فعل.
class NounVerbWord {
  final String word;
  final bool isVerb;
  final String emoji;
  const NounVerbWord(this.word, this.isVerb, this.emoji);
}

const nounVerbWords = <NounVerbWord>[
  NounVerbWord('كتاب', false, '📚'),
  NounVerbWord('يكتب', true, '✍️'),
  NounVerbWord('قلم', false, '✏️'),
  NounVerbWord('يرسم', true, '🎨'),
  NounVerbWord('شمس', false, '☀️'),
  NounVerbWord('يلعب', true, '⚽'),
  NounVerbWord('بيت', false, '🏠'),
  NounVerbWord('يأكل', true, '🍽️'),
  NounVerbWord('قمر', false, '🌙'),
  NounVerbWord('ينام', true, '😴'),
  NounVerbWord('ولد', false, '👦'),
  NounVerbWord('يقرأ', true, '📖'),
];

/// ٥) أنواع الفعل: ماضٍ، مضارع، أمر — للصف الثالث.
class VerbTense {
  final String past;
  final String present;
  final String imperative;
  final String emoji;
  const VerbTense(this.past, this.present, this.imperative, this.emoji);
}

const verbTenses = <VerbTense>[
  VerbTense('كتب', 'يكتب', 'اكتب', '✍️'),
  VerbTense('لعب', 'يلعب', 'العب', '⚽'),
  VerbTense('أكل', 'يأكل', 'كل', '🍽️'),
  VerbTense('نام', 'ينام', 'نم', '😴'),
  VerbTense('قرأ', 'يقرأ', 'اقرأ', '📖'),
  VerbTense('رسم', 'يرسم', 'ارسم', '🎨'),
  VerbTense('ركض', 'يركض', 'اركض', '🏃'),
  VerbTense('شرب', 'يشرب', 'اشرب', '🥤'),
  VerbTense('سبح', 'يسبح', 'اسبح', '🏊'),
  VerbTense('غنّى', 'يغنّي', 'غنِّ', '🎤'),
];

/// ٦) أدوات الاستفهام — للصف الثالث.
class QuestionWord {
  final String word;
  final String example;
  final String usage;
  final String emoji;
  const QuestionWord(this.word, this.example, this.usage, this.emoji);
}

const questionWords = <QuestionWord>[
  QuestionWord('من', 'من أكل التفاحة؟', 'نسأل بها عن شخص', '🙋'),
  QuestionWord('ماذا', 'ماذا تأكل؟', 'نسأل بها عن شيء', '❓'),
  QuestionWord('أين', 'أين الكتاب؟', 'نسأل بها عن مكان', '📍'),
  QuestionWord('متى', 'متى نذهب؟', 'نسأل بها عن زمن', '⏰'),
  QuestionWord('كيف', 'كيف حالك؟', 'نسأل بها عن طريقة أو حال', '🤔'),
  QuestionWord('لماذا', 'لماذا تبكي؟', 'نسأل بها عن السبب', '💭'),
  QuestionWord('كم', 'كم عمرك؟', 'نسأل بها عن عدد', '🔢'),
];

/// ٧) نوع الجملة: اسمية (تبدأ باسم) أو فعلية (تبدأ بفعل) — للصف الثالث.
class SentenceTypeItem {
  final String sentence;
  final bool isVerbal;
  const SentenceTypeItem(this.sentence, this.isVerbal);
}

const sentenceTypes = <SentenceTypeItem>[
  SentenceTypeItem('القمرُ جميلٌ', false),
  SentenceTypeItem('كتب الولدُ الدرسَ', true),
  SentenceTypeItem('الشمسُ مشرقةٌ', false),
  SentenceTypeItem('لعبت البنتُ في الحديقة', true),
  SentenceTypeItem('الطقسُ باردٌ اليوم', false),
  SentenceTypeItem('أكل الطفلُ التفاحة', true),
  SentenceTypeItem('المعلمُ نشيطٌ', false),
  SentenceTypeItem('قرأت سارة قصة', true),
  SentenceTypeItem('الحديقةُ واسعةٌ', false),
  SentenceTypeItem('ركض الولدان بسرعة', true),
];
