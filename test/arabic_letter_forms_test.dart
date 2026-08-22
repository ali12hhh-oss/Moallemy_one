import 'package:flutter_test/flutter_test.dart';

import '../lib/core/localization/letter_forms.dart';
import '../lib/data/content.dart';

void main() {
  test('all 28 Arabic letters have three visible positional forms', () {
    expect(arabicLetters.length, 28);
    for (final letter in arabicLetters) {
      final forms = LetterForms.of(letter.letter).all;
      expect(forms.length, 3);
      for (final form in forms) {
        expect(form.$2.trim(), isNotEmpty);
      }
    }
  });

  test('joining letters use distinct real Unicode positional glyphs', () {
    final forms = LetterForms.of('ب');
    expect(forms.initial, isNot(forms.isolated));
    expect(forms.medial, isNot(forms.initial));
    expect(forms.finalForm, isNot(forms.medial));
  });

  test('non-joining letters do not invent a connected shape', () {
    final forms = LetterForms.of('د');
    expect(forms.initial, forms.isolated);
    expect(forms.medial, forms.isolated);
    expect(forms.finalForm, isNot(forms.isolated));
  });
}
