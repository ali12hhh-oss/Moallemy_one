import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../storage/progress_v8.dart';
import '../adaptive/adaptive_learning_engine_v24.dart';

class EnglishQuestionV17 {
  final String skillId;
  final String prompt;
  final String answer;
  final List<String> options;
  const EnglishQuestionV17({
    required this.skillId,
    required this.prompt,
    required this.answer,
    required this.options,
  });
}

class EnglishPracticeEngineV17 {
  static final Random _r = Random();
  static const _prefix = 'english_skill_v17';
  static String arabicNumber(int n) =>
      n.toString().split('').map((d) => '٠١٢٣٤٥٦٧٨٩'[int.parse(d)]).join();

  static List<String> _mix(List<String> x) => [...x]..shuffle(_r);

  static EnglishQuestionV17 generate(String id) {
    if (id == 'alphabet_sounds') {
      const xs = {
        'b': 'بْ',
        'm': 'مْ',
        's': 'سْ',
        't': 'تْ',
        'f': 'فْ',
        'n': 'نْ',
      };
      final k = xs.keys.elementAt(_r.nextInt(xs.length));
      final a = xs[k]!;
      return EnglishQuestionV17(
        skillId: id,
        prompt: 'What sound does "$k" make?',
        answer: a,
        options: _mix([a, 'بَ', 'مَ', 'سَ']),
      );
    }
    if (id == 'cvc') {
      const xs = {
        'cat': 'كَتْ',
        'sun': 'سَنْ',
        'pen': 'پِنْ',
        'dog': 'دُگْ',
        'map': 'مَپْ',
      };
      final k = xs.keys.elementAt(_r.nextInt(xs.length));
      final a = xs[k]!;
      return EnglishQuestionV17(
        skillId: id,
        prompt: 'اقرأ الكلمة: $k',
        answer: a,
        options: _mix([a, 'كِتْ', 'مُوْ', 'بَ']),
      );
    }
    if (id == 'sh_ch_th_ph') {
      const xs = {'ship': 'sh', 'chip': 'ch', 'thin': 'th', 'phone': 'ph'};
      final k = xs.keys.elementAt(_r.nextInt(xs.length));
      final a = xs[k]!;
      return EnglishQuestionV17(
        skillId: id,
        prompt: 'Which sound starts "$k"?',
        answer: a,
        options: _mix([a, 'sh', 'ch', 'th', 'ph']),
      );
    }
    if (id == 'short_vowels') {
      const xs = {'cat': 'a', 'bed': 'e', 'sit': 'i', 'hot': 'o', 'sun': 'u'};
      final k = xs.keys.elementAt(_r.nextInt(xs.length));
      final a = xs[k]!;
      return EnglishQuestionV17(
        skillId: id,
        prompt: 'Choose the short vowel in "$k"',
        answer: a,
        options: _mix(['a', 'e', 'i', 'o', 'u']),
      );
    }
    if (id == 'long_vowels') {
      const xs = {
        'cake': 'a',
        'these': 'e',
        'time': 'i',
        'home': 'o',
        'cube': 'u',
      };
      final k = xs.keys.elementAt(_r.nextInt(xs.length));
      final a = xs[k]!;
      return EnglishQuestionV17(
        skillId: id,
        prompt: 'Choose the long vowel in "$k"',
        answer: a,
        options: _mix(['a', 'e', 'i', 'o', 'u']),
      );
    }
    if (id == 'word_families') {
      const xs = {
        'cat': ['bat', 'hat', 'mat'],
        'sun': ['run', 'fun', 'bun'],
        'pen': ['hen', 'ten', 'men'],
      };
      final k = xs.keys.elementAt(_r.nextInt(xs.length));
      final a = xs[k]![0];
      return EnglishQuestionV17(
        skillId: id,
        prompt: 'Which word is in the same family as "$k"?',
        answer: a,
        options: _mix([a, ...xs[k]!.skip(1), 'dog']),
      );
    }
    if (id == 'sight_words') {
      const xs = ['the', 'is', 'and', 'you', 'we', 'to', 'in', 'my'];
      final a = xs[_r.nextInt(xs.length)];
      return EnglishQuestionV17(
        skillId: id,
        prompt: 'اختر الكلمة الإنجليزية الصحيحة',
        answer: a,
        options: _mix([a, 'cat', 'sun', 'red']),
      );
    }
    if (id == 'ee_oo_ai_oa') {
      const xs = {'tree': 'ee', 'moon': 'oo', 'rain': 'ai', 'boat': 'oa'};
      final k = xs.keys.elementAt(_r.nextInt(xs.length));
      final a = xs[k]!;
      return EnglishQuestionV17(
        skillId: id,
        prompt: 'Which vowel team is in "$k"?',
        answer: a,
        options: _mix([a, 'ee', 'oo', 'ai', 'oa']),
      );
    }
    if (id == 'silent_e') {
      const xs = {'cap': 'cape', 'kit': 'kite', 'hop': 'hope', 'cub': 'cube'};
      final k = xs.keys.elementAt(_r.nextInt(xs.length));
      final a = xs[k]!;
      return EnglishQuestionV17(
        skillId: id,
        prompt: 'Add silent e to "$k"',
        answer: a,
        options: _mix([a, ...xs.values, 'cat']),
      );
    }
    const pairs = {
      'I am happy.': 'أنا سعيد.',
      'This is a cat.': 'هذه قطة.',
      'I like red.': 'أحب الأحمر.',
    };
    final k = pairs.keys.elementAt(_r.nextInt(pairs.length));
    return EnglishQuestionV17(
      skillId: id,
      prompt: 'ما معنى: $k',
      answer: pairs[k]!,
      options: _mix([pairs[k]!, 'أنا أحب اللعب.', 'هذا كتاب.', 'الولد يقرأ.']),
    );
  }

  static Future<void> record(String id, bool correct) async {
    final p = await SharedPreferences.getInstance();
    final key = '$_prefix.$id';
    final old = p.getInt(key) ?? 0;
    await p.setInt(key, (old + (correct ? 10 : -5)).clamp(0, 100));
    await AdaptiveLearningEngineV24.record(id, correct);
    if (correct) {
      await p.setInt('child_stars_v15', (p.getInt('child_stars_v15') ?? 0) + 1);
      await p.setInt('child_xp_v15', (p.getInt('child_xp_v15') ?? 0) + 5);
      // Also feed the shared reward pool (shop / parent dashboard).
      await ProgressV8.addRewards(stars: 1, xp: 5);
    }
  }

  static Future<int> mastery(String id) async {
    final p = await SharedPreferences.getInstance();
    return p.getInt('$_prefix.$id') ?? 0;
  }
}
