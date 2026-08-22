/// True Arabic positional glyphs for the 28 letters.
///
/// We deliberately use the Unicode Arabic Presentation Forms for the
/// educational display instead of adding tatweel characters. This means the
/// child sees the actual glyph for the requested position, not an artificial
/// placeholder. Non-joining letters (ا د ذ ر ز و) have no distinct initial
/// or medial joining glyph; their valid Unicode form is reused for those
/// positions rather than showing a fake connected shape.
class LetterForms {
  final String isolated;
  final String initial;
  final String medial;
  final String finalForm;

  const LetterForms({
    required this.isolated,
    required this.initial,
    required this.medial,
    required this.finalForm,
  });

  factory LetterForms.of(String letter) {
    const forms = <String, List<int>>{
      'أ': [0xFE83, 0xFE83, 0xFE83, 0xFE84],
      'ب': [0xFE8F, 0xFE91, 0xFE92, 0xFE90],
      'ت': [0xFE95, 0xFE97, 0xFE98, 0xFE96],
      'ث': [0xFE99, 0xFE9B, 0xFE9C, 0xFE9A],
      'ج': [0xFE9D, 0xFE9F, 0xFEA0, 0xFE9E],
      'ح': [0xFEA1, 0xFEA3, 0xFEA4, 0xFEA2],
      'خ': [0xFEA5, 0xFEA7, 0xFEA8, 0xFEA6],
      'د': [0xFEA9, 0xFEA9, 0xFEA9, 0xFEAA],
      'ذ': [0xFEAB, 0xFEAB, 0xFEAB, 0xFEAC],
      'ر': [0xFEAD, 0xFEAD, 0xFEAD, 0xFEAE],
      'ز': [0xFEAF, 0xFEAF, 0xFEAF, 0xFEB0],
      'س': [0xFEB1, 0xFEB3, 0xFEB4, 0xFEB2],
      'ش': [0xFEB5, 0xFEB7, 0xFEB8, 0xFEB6],
      'ص': [0xFEB9, 0xFEBB, 0xFEBC, 0xFEBA],
      'ض': [0xFEBD, 0xFEBF, 0xFEC0, 0xFEBE],
      'ط': [0xFEC1, 0xFEC3, 0xFEC4, 0xFEC2],
      'ظ': [0xFEC5, 0xFEC7, 0xFEC8, 0xFEC6],
      'ع': [0xFEC9, 0xFECB, 0xFECC, 0xFECA],
      'غ': [0xFECD, 0xFECF, 0xFED0, 0xFECE],
      'ف': [0xFED1, 0xFED3, 0xFED4, 0xFED2],
      'ق': [0xFED5, 0xFED7, 0xFED8, 0xFED6],
      'ك': [0xFED9, 0xFEDB, 0xFEDC, 0xFEDA],
      'ل': [0xFEDD, 0xFEDF, 0xFEE0, 0xFEDE],
      'م': [0xFEE1, 0xFEE3, 0xFEE4, 0xFEE2],
      'ن': [0xFEE5, 0xFEE7, 0xFEE8, 0xFEE6],
      'ه': [0xFEE9, 0xFEEB, 0xFEEC, 0xFEEA],
      'و': [0xFEED, 0xFEED, 0xFEED, 0xFEEE],
      'ي': [0xFEEF, 0xFEF1, 0xFEF2, 0xFEF0],
    };

    final codePoints = forms[letter];
    if (codePoints == null) {
      return LetterForms(
        isolated: letter,
        initial: letter,
        medial: letter,
        finalForm: letter,
      );
    }

    String glyph(int codePoint) => String.fromCharCode(codePoint);
    return LetterForms(
      isolated: glyph(codePoints[0]),
      initial: glyph(codePoints[1]),
      medial: glyph(codePoints[2]),
      finalForm: glyph(codePoints[3]),
    );
  }

  List<(String label, String form)> get all => [
        ('أول الكلمة', initial),
        ('وسط الكلمة', medial),
        ('آخر الكلمة', finalForm),
      ];
}
