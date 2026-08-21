enum Haraka { fatha, damma, kasra }

extension HarakaInfo on Haraka {
  String get mark => switch (this) { Haraka.fatha => 'َ', Haraka.damma => 'ُ', Haraka.kasra => 'ِ' };
  String get name => switch (this) { Haraka.fatha => 'الفتحة', Haraka.damma => 'الضمة', Haraka.kasra => 'الكسرة' };
  String get soundHint => switch (this) { Haraka.fatha => 'a', Haraka.damma => 'u', Haraka.kasra => 'i' };
  // الحرف الممدود المرافق تقليديًا: الفتحة مع الألف، الضمة مع الواو، الكسرة مع الياء.
  String get longVowelLetter => switch (this) { Haraka.fatha => 'ا', Haraka.damma => 'و', Haraka.kasra => 'ي' };
}

/// يبني شكل الحرف مع الحركة (مثال: ب + فتحة = بَ).
String letterWithHaraka(String letter, Haraka h) => '$letter${h.mark}';

/// كلمة ممدودة تقليدية لتعليم الحركة (مثال: بَ + ا = با).
String longVowelWord(String letter, Haraka h) => '$letter${h.longVowelLetter}';

/// حروف مختارة لأمثلة الكلمات الممدودة لكل حركة (ست حروف شائعة وسهلة).
const harakaSampleLetters = ['ب', 'ت', 'د', 'ن', 'م', 'ل'];
