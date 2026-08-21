class ArabicGrammarLessonV12 {
  final String id, title, explanation, example, emoji;
  final List<String> exercises;
  const ArabicGrammarLessonV12(this.id, this.title, this.explanation, this.example, this.emoji, this.exercises);
}

const arabicPrepositionsV12 = <ArabicGrammarLessonV12>[
  ArabicGrammarLessonV12('min','مِنْ','تدل على بداية الشيء أو المكان.','خرجتُ مِنَ البيتِ.','🏠',['أكمل: خرجتُ ___ المدرسةِ.','اختر حرف الجر المناسب للجملة.']),
  ArabicGrammarLessonV12('ila','إِلَى','تدل على الاتجاه أو الوصول إلى مكان.','ذهبتُ إِلَى المدرسةِ.','🏫',['أكمل: أذهبُ ___ الحديقةِ.','أين يتجه الطفل؟']),
  ArabicGrammarLessonV12('fi','فِي','تدل على المكان أو الزمان.','الكتابُ فِي الحقيبةِ.','🎒',['أكمل: القلمُ ___ الحقيبةِ.','اختر الجملة التي تستخدم «في» بشكل صحيح.']),
  ArabicGrammarLessonV12('ala','عَلَى','تدل على الاستعلاء أو وجود شيء فوق شيء.','الكتابُ عَلَى الطاولةِ.','📚',['أكمل: الكوبُ ___ الطاولةِ.','أين الكتاب؟']),
  ArabicGrammarLessonV12('an','عَنْ','تدل على الحديث أو السؤال عن شيء.','تحدثتُ عَنْ القراءةِ.','💬',['أكمل: سألتُ ___ الدرسِ.','اختر الجملة الصحيحة.']),
  ArabicGrammarLessonV12('bi','بِـ','تدل على الاستعانة أو المصاحبة في تراكيب بسيطة.','أكتبُ بِالقلمِ.','✏️',['أكمل: أكتبُ ___ القلمِ.','ما الأداة التي أستعملها؟']),
  ArabicGrammarLessonV12('ka','كَـ','تدل على التشبيه في تراكيب مبسطة.','الطفلُ كَالنجمِ.','⭐',['أكمل: وجهُها ___ القمرِ.','اختر أداة التشبيه.']),
  ArabicGrammarLessonV12('li','لِـ','تدل على الملك أو الاختصاص.','هذا الكتابُ لِلطالبِ.','📖',['أكمل: القلمُ ___ مريمَ.','لمن الكتاب؟']),
];

const arabicDefiniteArticleV12 = <ArabicGrammarLessonV12>[
  ArabicGrammarLessonV12('al_basic','الـ التعريف','نضع «الـ» قبل الاسم لنجعله معرفة، مثل: كتاب ← الكتاب.','الكتابُ على الطاولةِ.','📖',['حوّل: كتاب ← ____','اختر الاسم المعرّف: بيت / البيت.']),
  ArabicGrammarLessonV12('al_sun','اللام الشمسية','مع بعض الحروف لا نُظهر صوت اللام في النطق وتُشدّد الحرف التالي، مثل: الشَّمس.','الشَّمْسُ مُشْرِقَةٌ.','☀️',['اقرأ: الشَّمْسُ.','اختر: الشَّجرة أم اللام في الشجرة؟']),
  ArabicGrammarLessonV12('al_moon','اللام القمرية','مع بعض الحروف يظهر صوت اللام بوضوح، مثل: القمر.','الْقَمَرُ جَمِيلٌ.','🌙',['اقرأ: الْقَمَرُ.','هل نسمع صوت اللام في «القمر»؟']),
];

class EnglishPhonicsRuleV12 {
  final String pattern, sound, name, examples, emoji;
  final int fromGrade;
  const EnglishPhonicsRuleV12(this.pattern, this.sound, this.name, this.examples, this.emoji, this.fromGrade);
}

const englishPhonicsRulesV12 = <EnglishPhonicsRuleV12>[
  EnglishPhonicsRuleV12('sh','/ʃ/','sh sound','ship, sheep, fish','🚢',1),
  EnglishPhonicsRuleV12('ch','/tʃ/','ch sound','chip, chair, chicken','🪑',1),
  EnglishPhonicsRuleV12('th','/θ/ or /ð/','th sounds','three, thin, this','3️⃣',2),
  EnglishPhonicsRuleV12('ph','/f/','ph sound','phone, photo','📱',2),
  EnglishPhonicsRuleV12('wh','/w/','wh sound','what, when, whale','🐋',2),
  EnglishPhonicsRuleV12('oo','/uː/ or /ʊ/','oo sounds','moon, book','🌙',2),
  EnglishPhonicsRuleV12('ee','/iː/','ee sound','tree, green','🌳',2),
  EnglishPhonicsRuleV12('ea','/iː/','ea sound','eat, leaf','🍃',2),
  EnglishPhonicsRuleV12('ai','/eɪ/','ai sound','rain, train','🚆',2),
  EnglishPhonicsRuleV12('oa','/oʊ/','oa sound','boat, coat','🚤',2),
  EnglishPhonicsRuleV12('ar','/ɑːr/','ar sound','car, star','⭐',3),
  EnglishPhonicsRuleV12('er','/ɜːr/','er sound','her, fern','🌿',3),
  EnglishPhonicsRuleV12('ir','/ɜːr/','ir sound','bird, shirt','🐦',3),
  EnglishPhonicsRuleV12('or','/ɔːr/','or sound','fork, corn','🍴',3),
  EnglishPhonicsRuleV12('ur','/ɜːr/','ur sound','turn, purple','🟣',3),
  EnglishPhonicsRuleV12('ck','/k/','ck ending','duck, sock','🦆',2),
  EnglishPhonicsRuleV12('ng','/ŋ/','ng ending','sing, king','👑',2),
];
