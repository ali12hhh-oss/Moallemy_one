/// حروف اللغة العربية تتغيّر شكلها حسب موقعها في الكلمة: أول الكلمة، وسطها،
/// وآخرها. بدل تخزين رموز يونيكود خاصة لكل شكل، نبني الشكل الصحيح تلقائيًا
/// عبر إضافة حرف "التطويل" (ـ) الشفّاف الذي يجبر محرك الخط على رسم الشكل
/// الصحيح المتصل — وهذه هي نفس الطريقة التي تُستخدم في برامج تعليم الخط
/// العربي الاحترافية.
const _tatweel = 'ـ';

class LetterForms {
  final String isolated;
  final String initial;
  final String medial;
  final String finalForm;
  const LetterForms({required this.isolated, required this.initial, required this.medial, required this.finalForm});

  factory LetterForms.of(String letter) => LetterForms(
        isolated: letter,
        initial: '$letter$_tatweel',
        medial: '$_tatweel$letter$_tatweel',
        finalForm: '$_tatweel$letter',
      );

  List<(String label, String form)> get all => [
        ('البداية', initial),
        ('الوسط', medial),
        ('النهاية', finalForm),
      ];
}
