import 'dart:math';

import '../storage/child_progress_repository.dart';
import '../adaptive/adaptive_learning_engine_v24.dart';

class ArabicQuestionV16 {
  final String skillId;
  final String prompt;
  final String answer;
  final List<String> options;
  final String explanation;
  const ArabicQuestionV16({
    required this.skillId,
    required this.prompt,
    required this.answer,
    required this.options,
    required this.explanation,
  });
}

class ArabicPracticeEngineV16 {
  static final Random _random = Random();

  static String arabicNumber(int n) =>
      n.toString().split('').map((d) => '٠١٢٣٤٥٦٧٨٩'[int.parse(d)]).join();

  static List<String> _shuffle(List<String> values) => [...values]..shuffle(_random);

  static ArabicQuestionV16 harakat(String id) {
    const data = <Map<String, String>>[
      {'letter': 'ب', 'mark': 'َ', 'sound': 'بَ'},
      {'letter': 'ب', 'mark': 'ِ', 'sound': 'بِ'},
      {'letter': 'ب', 'mark': 'ُ', 'sound': 'بُ'},
      {'letter': 'م', 'mark': 'َ', 'sound': 'مَ'},
      {'letter': 'م', 'mark': 'ِ', 'sound': 'مِ'},
      {'letter': 'م', 'mark': 'ُ', 'sound': 'مُ'},
    ];
    final x = data[_random.nextInt(data.length)];
    final answer = x['sound']!;
    return ArabicQuestionV16(
      skillId: id,
      prompt: 'ما قراءة هذا المقطع؟\n${x['letter']}${x['mark']}',
      answer: answer,
      options: _shuffle([answer, 'بَ', 'بِ', 'بُ']),
      explanation: 'الحركة تغيّر صوت الحرف: ${x['letter']}${x['mark']} تُقرأ $answer.',
    );
  }

  static ArabicQuestionV16 sukun(String id) {
    const pairs = [['أَكْ', 'أَكْ'], ['أَبْ', 'أَبْ'], ['مَنْ', 'مَنْ'], ['بَلْ', 'بَلْ']];
    final x = pairs[_random.nextInt(pairs.length)];
    return ArabicQuestionV16(skillId: id, prompt: 'اختر المقطع الذي يحتوي على السكون الصحيح:\n${x[0]}', answer: x[1], options: _shuffle([x[1], 'أَكُ', 'أَكَ', 'أَكِ']), explanation: 'السكون يجعل الحرف بلا حركة بعده.');
  }

  static ArabicQuestionV16 shadda(String id) {
    const words = ['مُحَمَّد', 'مُدَرِّس', 'قِطَّة', 'سَيَّارَة'];
    final word = words[_random.nextInt(words.length)];
    return ArabicQuestionV16(skillId: id, prompt: 'أي كلمة فيها حرف مشدد؟\n$word', answer: word, options: _shuffle([word, 'كِتاب', 'باب', 'قَلَم']), explanation: 'الحرف المشدد يحمل الشدة ويُنطق بقوة مضاعفة.');
  }

  static ArabicQuestionV16 tanween(String id) {
    const items = [['كِتَابٌ', 'ضم'], ['كِتَابٍ', 'كسر'], ['كِتَابًا', 'فتح']];
    final x = items[_random.nextInt(items.length)];
    return ArabicQuestionV16(skillId: id, prompt: 'ما نوع التنوين في:\n${x[0]}؟', answer: x[1], options: _shuffle([x[1], 'فتح', 'ضم', 'كسر']), explanation: 'التنوين في الكلمة هو تنوين ${x[1]}.');
  }

  static ArabicQuestionV16 longVowels(String id) {
    const items = [['بَا', 'الألف'], ['بُو', 'الواو'], ['بِي', 'الياء']];
    final x = items[_random.nextInt(items.length)];
    return ArabicQuestionV16(skillId: id, prompt: 'ما حرف المد في:\n${x[0]}؟', answer: x[1], options: _shuffle([x[1], 'الألف', 'الواو', 'الياء']), explanation: 'المقطع ${x[0]} يحتوي على مد بـ${x[1]}.');
  }

  static ArabicQuestionV16 syllables(String id) {
    const items = [['كَ + تِ + بَ', 'كَتِبَ'], ['ذَ + هَ + بَ', 'ذَهَبَ'], ['لَ + عِ + بَ', 'لَعِبَ'], ['رَ + سَ + مَ', 'رَسَمَ']];
    final x = items[_random.nextInt(items.length)];
    return ArabicQuestionV16(skillId: id, prompt: 'اجمع المقاطع لتكوين الكلمة:\n${x[0]}', answer: x[1], options: _shuffle([x[1], 'ذَهَبَ', 'لَعِبَ', 'رَسَمَ']), explanation: 'عند دمج المقاطع نحصل على: ${x[1]}.');
  }

  static ArabicQuestionV16 sunMoon(String id) {
    const items = [['الشَّمْس', 'شمسية'], ['الْقَمَر', 'قمرية'], ['السَّمَك', 'شمسية'], ['الْبَاب', 'قمرية']];
    final x = items[_random.nextInt(items.length)];
    return ArabicQuestionV16(skillId: id, prompt: 'ما نوع اللام في:\n${x[0]}؟', answer: x[1], options: _shuffle([x[1], 'شمسية', 'قمرية']), explanation: 'الكلمة ${x[0]} تحتوي على لام ${x[1]}.');
  }

  static ArabicQuestionV16 preposition(String id) {
    const items = [['ذهبتُ ___ المدرسة.', 'إلى'], ['الكتاب ___ الحقيبة.', 'في'], ['شربتُ الماء ___ الكأس.', 'من'], ['مررتُ ___ البيت.', 'بـ'], ['جلستُ ___ الكرسي.', 'على']];
    final x = items[_random.nextInt(items.length)];
    return ArabicQuestionV16(skillId: id, prompt: 'اختر حرف الجر المناسب:\n${x[0]}', answer: x[1], options: _shuffle([x[1], 'إلى', 'في', 'على', 'من']), explanation: 'الإجابة الصحيحة: ${x[1]}.');
  }

  static ArabicQuestionV16 alDefinition(String id) {
    const items = [['كتاب', 'الكتاب'], ['بيت', 'البيت'], ['قمر', 'القمر'], ['باب', 'الباب']];
    final x = items[_random.nextInt(items.length)];
    return ArabicQuestionV16(skillId: id, prompt: 'عرّف الاسم بـ(الـ):\n${x[0]}', answer: x[1], options: _shuffle([x[1], x[0], 'كتابان', 'كتب']), explanation: 'نضيف (الـ) إلى الاسم: ${x[1]}.');
  }

  static ArabicQuestionV16 singularPlural(String id) {
    const items = [['كتاب', 'كتب'], ['قلم', 'أقلام'], ['ولد', 'أولاد'], ['بنت', 'بنات']];
    final x = items[_random.nextInt(items.length)];
    return ArabicQuestionV16(skillId: id, prompt: 'ما جمع كلمة «${x[0]}»؟', answer: x[1], options: _shuffle([x[1], 'كتاب', 'قلم', 'ولد']), explanation: 'جمع «${x[0]}» هنا هو «${x[1]}».');
  }

  static ArabicQuestionV16 masculineFeminine(String id) {
    const items = [['ولد', 'مذكر'], ['بنت', 'مؤنث'], ['معلم', 'مذكر'], ['معلمة', 'مؤنث']];
    final x = items[_random.nextInt(items.length)];
    return ArabicQuestionV16(skillId: id, prompt: 'هل كلمة «${x[0]}» مذكر أم مؤنث؟', answer: x[1], options: _shuffle([x[1], 'مذكر', 'مؤنث']), explanation: 'كلمة «${x[0]}» هنا ${x[1]}.');
  }

  static ArabicQuestionV16 sentenceBuilding(String id) {
    const items = [['الولد', 'يقرأ', 'كتابًا'], ['البنت', 'ترسم', 'زهرة'], ['الأم', 'تطبخ', 'الطعام'], ['الطفل', 'يشرب', 'الماء']];
    final x = items[_random.nextInt(items.length)];
    final answer = '${x[0]} ${x[1]} ${x[2]}';
    return ArabicQuestionV16(skillId: id, prompt: 'رتّب الكلمات لتكوين جملة صحيحة:\n${x.join(' — ')}', answer: answer, options: _shuffle([answer, '${x[1]} ${x[0]} ${x[2]}', '${x[2]} ${x[0]} ${x[1]}', '${x[0]} ${x[2]} ${x[1]}']), explanation: 'الجملة الصحيحة: $answer.');
  }

  static ArabicQuestionV16 spelling(String id) {
    const items = <({String word, List<String> options})>[
      (word: 'مَدْرَسَة', options: ['مَدْرَسَة', 'مَذْرَسَة', 'مَدْرَسَه']),
      (word: 'شَجَرَة', options: ['شَجَرَة', 'شَجَرَه', 'شَجَرَت']),
      (word: 'قَلَم', options: ['قَلَم', 'قَلَن', 'كَلَم']),
      (word: 'سَمَكَة', options: ['سَمَكَة', 'سَمَكَه', 'ثَمَكَة']),
    ];
    final x = items[_random.nextInt(items.length)];
    return ArabicQuestionV16(skillId: id, prompt: 'اختر الكتابة الصحيحة:\n${x.word}', answer: x.options.first, options: _shuffle(x.options), explanation: 'الكتابة الصحيحة هي: ${x.options.first}.');
  }

  static ArabicQuestionV16 wordAnalysis(String id) {
    const items = [['كَتَبَ', '٣'], ['مَدْرَسَة', '٦'], ['قَلَم', '٤'], ['سَيَّارَة', '٧']];
    final x = items[_random.nextInt(items.length)];
    return ArabicQuestionV16(skillId: id, prompt: 'كم حرفًا في كلمة «${x[0]}»؟', answer: x[1], options: _shuffle([x[1], '٢', '٤', '٥', '٦', '٧']), explanation: 'عدد الحروف هو ${x[1]}.');
  }

  static ArabicQuestionV16 sentenceType(String id) {
    const items = [['الولدُ نشيطٌ.', 'اسمية'], ['ذهبَ محمدٌ.', 'فعلية'], ['السماءُ صافيةٌ.', 'اسمية'], ['قرأَ عليٌّ.', 'فعلية']];
    final x = items[_random.nextInt(items.length)];
    return ArabicQuestionV16(skillId: id, prompt: 'ما نوع الجملة؟\n${x[0]}', answer: x[1], options: _shuffle([x[1], 'اسمية', 'فعلية']), explanation: 'هذه الجملة ${x[1]}.');
  }

  static Future<void> record({required String skillId, required bool correct}) async {
    await ChildProgressRepository.recordSkill(skillId, correct);
    await AdaptiveLearningEngineV24.record(skillId, correct);
  }

  static Future<int> mastery(String skillId) => ChildProgressRepository.skillMastery(skillId);
}
