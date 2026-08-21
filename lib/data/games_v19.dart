
class GameDefinitionV19 {
  final String id, title, skill;
  final int grade;
  const GameDefinitionV19(this.id,this.title,this.skill,this.grade);
}

const gamesV19 = <GameDefinitionV19>[
  GameDefinitionV19('letter_hunter','صائد الحروف','الحروف',1),
  GameDefinitionV19('word_builder','بَنّاء الكلمات','القراءة',1),
  GameDefinitionV19('picture_match','طابق الصورة والكلمة','المفردات',1),
  GameDefinitionV19('memory_match','لعبة الذاكرة','المفردات',1),
  GameDefinitionV19('reading_race','سباق القراءة','القراءة',2),
  GameDefinitionV19('number_hunter','صائد الأرقام','الأعداد',1),
  GameDefinitionV19('math_challenge','تحدي الحساب','الجمع والطرح',1),
  GameDefinitionV19('multiplication','مغامرة الضرب','جداول الضرب',2),
  GameDefinitionV19('phonics_hunter','صائد الأصوات','English Phonics',1),
];

class GameRoundV19 {
  final String prompt, answer;
  final List<String> options;
  const GameRoundV19(this.prompt,this.answer,this.options);
}
