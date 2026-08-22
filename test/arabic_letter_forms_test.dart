import 'package:flutter_test/flutter_test.dart';

import 'package:daleel_child/core/localization/letter_forms.dart';

void main() {
  group('Arabic letter positional forms', () {
    const letters = <String>[
      'أ',
      'ب',
      'ت',
      'ث',
      'ج',
      'ح',
      'خ',
      'د',
      'ذ',
      'ر',
      'ز',
      'س',
      'ش',
      'ص',
      'ض',
      'ط',
      'ظ',
      'ع',
      'غ',
      'ف',
      'ق',
      'ك',
      'ل',
      'م',
      'ن',
      'ه',
      'و',
      'ي',
    ];

    test('contains all 28 Arabic letters', () {
      expect(letters, hasLength(28));
      for (final letter in letters) {
        final forms = LetterForms.of(letter);
        expect(forms.isolated, isNotEmpty, reason: letter);
        expect(forms.initial, isNotEmpty, reason: letter);
        expect(forms.medial, isNotEmpty, reason: letter);
        expect(forms.finalForm, isNotEmpty, reason: letter);
      }
    });

    test('returns three selectable positional forms', () {
      final forms = LetterForms.of('ب');

      expect(forms.all, hasLength(3));
      expect(forms.all[0].$1, 'أول الكلمة');
      expect(forms.all[1].$1, 'وسط الكلمة');
      expect(forms.all[2].$1, 'آخر الكلمة');
      expect(forms.all.map((entry) => entry.$2), everyElement(isNotEmpty));
    });

    test('does not invent joining shapes for non-joining letters', () {
      for (final letter in <String>['ا', 'د', 'ذ', 'ر', 'ز', 'و']) {
        final forms = LetterForms.of(letter);
        expect(forms.initial, forms.isolated, reason: letter);
        expect(forms.medial, forms.isolated, reason: letter);
      }
    });

    test('joining letters have distinct positional glyphs', () {
      for (final letter in <String>[
        'ب',
        'ت',
        'ج',
        'س',
        'ع',
        'ف',
        'ك',
        'م',
        'ي',
      ]) {
        final forms = LetterForms.of(letter);
        expect(forms.initial, isNot(equals(forms.isolated)), reason: letter);
        expect(forms.medial, isNot(equals(forms.isolated)), reason: letter);
        expect(forms.finalForm, isNot(equals(forms.isolated)), reason: letter);
      }
    });
  });
}
