
class EnglishSkillV17 {
  final String id;
  final int grade;
  final String title;
  final String description;
  const EnglishSkillV17(this.id, this.grade, this.title, this.description);
}

const englishCurriculumV17 = <EnglishSkillV17>[
  EnglishSkillV17('alphabet_sounds',1,'Letter sounds','تعلم الصوت الأساسي للحرف لا اسمه'),
  EnglishSkillV17('short_vowels',1,'Short vowels','أصوات a e i o u القصيرة'),
  EnglishSkillV17('cvc',1,'CVC words','دمج الأصوات لقراءة كلمات بسيطة'),
  EnglishSkillV17('numbers_colors',1,'Numbers and colors','الأرقام والألوان والكلمات اليومية'),
  EnglishSkillV17('blending',1,'Blending','دمج الأصوات لقراءة الكلمة'),
  EnglishSkillV17('sh_ch_th_ph',2,'Digraphs','sh و ch و th و ph'),
  EnglishSkillV17('long_vowels',2,'Long vowels','الأصوات الطويلة'),
  EnglishSkillV17('word_families',2,'Word families','مجموعات الكلمات'),
  EnglishSkillV17('sight_words',2,'Sight words','الكلمات الشائعة'),
  EnglishSkillV17('ee_oo_ai_oa',3,'Vowel teams','ee و oo و ai و oa'),
  EnglishSkillV17('silent_e',3,'Silent E','الحرف الصامت e'),
  EnglishSkillV17('simple_sentences',3,'Simple sentences','قراءة جمل إنجليزية قصيرة'),
];

const englishPhonicsV17 = <String, String>{
  'a':'أَ','b':'بْ','c':'كْ','d':'دْ','e':'إِ','f':'فْ','g':'گْ','h':'هْ',
  'i':'إِ','j':'جْ','k':'كْ','l':'لْ','m':'مْ','n':'نْ','o':'أُ','p':'پْ',
  'q':'كْوْ','r':'رْ','s':'سْ','t':'تْ','u':'أَ','v':'ڤْ','w':'وْ','x':'كْسْ',
  'y':'يْ','z':'زْ',
  'sh':'شْ','ch':'تشْ','th':'ثْ/ذْ','ph':'فْ',
};
