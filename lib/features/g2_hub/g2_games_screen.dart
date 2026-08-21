import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../core/storage/progress_v8.dart';
import '../../data/content_v11.dart';
import '../../data/grammar_data.dart';
import '../../data/short_words.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

class G2GamesScreen extends StatelessWidget {
  const G2GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final games = <(String, String, String, Color, Widget)>[
      ('📖', 'لعبة القراءة', 'شاهد الصورة واختر الكلمة الصحيحة', const Color(0xFF7C4DFF), const _ReadingGame()),
      ('🇬🇧', 'English Game', 'استمع للكلمة واختر معناها', const Color(0xFF2979FF), const _EnglishGame()),
      ('🧮', 'لعبة الرياضيات', 'جمع وطرح ومقارنة سريعة', const Color(0xFF00C853), const _MathGame()),
      ('📝', 'لعبة القواعد', 'اسم أم فعل؟ مذكر أم مؤنث؟', const Color(0xFFFF1E7E), const _GrammarGame()),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الألعاب 🎮')),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: games.map((g) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Button3D(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => g.$5)),
                color: g.$4,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                child: Row(children: [
                  Text(g.$1, style: const TextStyle(fontSize: 34)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(g.$2, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                      const SizedBox(height: 3),
                      Text(g.$3, style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
                    ]),
                  ),
                ]),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// لعبة القراءة: شاهد الرمز واختر الكلمة الصحيحة (حرفين إلى أربعة أحرف).
class _ReadingGame extends StatefulWidget {
  const _ReadingGame();
  @override
  State<_ReadingGame> createState() => _ReadingGameState();
}

class _ReadingGameState extends State<_ReadingGame> {
  final rnd = Random();
  late final all = [...twoLetterWords, ...threeLetterWords, ...fourLetterWords];
  late ShortWord target;
  late List<ShortWord> options;
  int score = 0;
  String? cheer;

  @override
  void initState() {
    super.initState();
    _next();
  }

  void _next() {
    target = all[rnd.nextInt(all.length)];
    final others = [...all]..shuffle(rnd);
    others.removeWhere((w) => w.word == target.word);
    options = [target, ...others.take(3)]..shuffle(rnd);
  }

  void _answer(ShortWord chosen) {
    if (chosen.word == target.word) {
      score++;
      setState(() => cheer = kCheers[rnd.nextInt(kCheers.length)]);
      ProgressV8.addRewards(stars: 1, xp: 5);
      VoiceService.arabic(target.word);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => cheer = null);
          _next();
        }
      });
    } else {
      VoiceService.arabic(target.word);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('لعبة القراءة • ${arNum(score)} ⭐')),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Text(target.emoji, style: const TextStyle(fontSize: 70)),
              const SizedBox(height: 10),
              const Text('ما هذه الكلمة؟', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 18),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  children: options.map((o) => Button3D(onTap: () => _answer(o), color: const Color(0xFF7C4DFF), child: Center(child: Text(o.word, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white))))).toList(),
                ),
              ),
            ]),
          ),
          CelebrationOverlay(message: cheer),
        ]),
      ),
    );
  }
}

/// English Game: hear the word, pick its Arabic meaning.
class _EnglishGame extends StatefulWidget {
  const _EnglishGame();
  @override
  State<_EnglishGame> createState() => _EnglishGameState();
}

class _EnglishGameState extends State<_EnglishGame> {
  final rnd = Random();
  late EnglishWordV11 target;
  late List<EnglishWordV11> options;
  int score = 0;
  String? cheer;

  @override
  void initState() {
    super.initState();
    _next();
  }

  void _next() {
    target = englishWordsV11[rnd.nextInt(englishWordsV11.length)];
    final others = [...englishWordsV11]..shuffle(rnd);
    others.removeWhere((w) => w.word == target.word);
    options = [target, ...others.take(3)]..shuffle(rnd);
    WidgetsBinding.instance.addPostFrameCallback((_) => VoiceService.english(target.word));
  }

  void _answer(EnglishWordV11 chosen) {
    if (chosen.word == target.word) {
      score++;
      setState(() => cheer = kCheers[rnd.nextInt(kCheers.length)]);
      ProgressV8.addRewards(stars: 1, xp: 5);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => cheer = null);
          _next();
        }
      });
    } else {
      VoiceService.english(target.word);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('English Game • ${arNum(score)} ⭐')),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              IconButton(iconSize: 44, icon: const Icon(Icons.volume_up_rounded), onPressed: () => VoiceService.english(target.word)),
              const Text('ما معنى هذه الكلمة؟', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 18),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  children: options.map((o) => Button3D(onTap: () => _answer(o), color: const Color(0xFF2979FF), child: Center(child: Text('${o.emoji} ${o.arabic}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white))))).toList(),
                ),
              ),
            ]),
          ),
          CelebrationOverlay(message: cheer),
        ]),
      ),
    );
  }
}

/// لعبة الرياضيات: جمع وطرح ومقارنة سريعة.
class _MathGame extends StatefulWidget {
  const _MathGame();
  @override
  State<_MathGame> createState() => _MathGameState();
}

class _MathGameState extends State<_MathGame> {
  final rnd = Random();
  late String question;
  late int answer;
  late List<int> options;
  int score = 0;
  String? cheer;

  @override
  void initState() {
    super.initState();
    _next();
  }

  void _next() {
    final kind = rnd.nextInt(3);
    if (kind == 0) {
      final a = 1 + rnd.nextInt(40), b = 1 + rnd.nextInt(40);
      question = '${arNum(a)} + ${arNum(b)} = ؟';
      answer = a + b;
    } else if (kind == 1) {
      final a = 20 + rnd.nextInt(60), b = 1 + rnd.nextInt(a - 1);
      question = '${arNum(a)} − ${arNum(b)} = ؟';
      answer = a - b;
    } else {
      final a = 1 + rnd.nextInt(99), b = 1 + rnd.nextInt(99);
      question = 'أي عدد أكبر؟ ${arNum(a)} أم ${arNum(b)}';
      answer = a > b ? a : b;
    }
    final others = {for (var i = max(0, answer - 5); i <= answer + 5; i++) i}..remove(answer);
    final list = others.toList()..shuffle(rnd);
    options = [answer, ...list.take(3)]..shuffle(rnd);
  }

  void _answer(int chosen) {
    if (chosen == answer) {
      score++;
      setState(() => cheer = kCheers[rnd.nextInt(kCheers.length)]);
      ProgressV8.addRewards(stars: 1, xp: 5);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => cheer = null);
          _next();
        }
      });
    } else {
      setState(() => cheer = 'حاول مرة أخرى 💪');
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) setState(() => cheer = null);
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('لعبة الرياضيات • ${arNum(score)} ⭐')),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Text(question, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  children: options.map((o) => Button3D(onTap: () => _answer(o), color: const Color(0xFF00C853), child: Center(child: Text(arNum(o), style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white))))).toList(),
                ),
              ),
            ]),
          ),
          CelebrationOverlay(message: cheer),
        ]),
      ),
    );
  }
}

/// لعبة القواعد: اسم أم فعل، أو مذكر أم مؤنث — مختلطة عشوائيًا.
class _GrammarGame extends StatefulWidget {
  const _GrammarGame();
  @override
  State<_GrammarGame> createState() => _GrammarGameState();
}

class _GrammarGameState extends State<_GrammarGame> {
  final rnd = Random();
  bool nounVerbRound = true;
  late NounVerbWord nvTarget;
  late GenderPair genderPair;
  late bool genderShowFeminine;
  int score = 0;
  String? cheer;

  @override
  void initState() {
    super.initState();
    _next();
  }

  void _next() {
    nounVerbRound = rnd.nextBool();
    nvTarget = nounVerbWords[rnd.nextInt(nounVerbWords.length)];
    genderPair = genderPairs[rnd.nextInt(genderPairs.length)];
    genderShowFeminine = rnd.nextBool();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VoiceService.arabic(nounVerbRound ? nvTarget.word : (genderShowFeminine ? genderPair.feminine : genderPair.masculine));
    });
  }

  void _answer(bool chosenSecondOption) {
    final isCorrect = nounVerbRound ? (chosenSecondOption == nvTarget.isVerb) : (chosenSecondOption == genderShowFeminine);
    if (isCorrect) {
      score++;
      setState(() => cheer = kCheers[rnd.nextInt(kCheers.length)]);
      ProgressV8.addRewards(stars: 1, xp: 5);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => cheer = null);
          _next();
        }
      });
    } else {
      setState(() => cheer = 'حاول مرة أخرى 💪');
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) setState(() => cheer = null);
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final word = nounVerbRound ? nvTarget.word : (genderShowFeminine ? genderPair.feminine : genderPair.masculine);
    final emoji = nounVerbRound ? nvTarget.emoji : (genderShowFeminine ? genderPair.emojiF : genderPair.emojiM);
    final leftLabel = nounVerbRound ? 'اسم' : 'مذكر';
    final rightLabel = nounVerbRound ? 'فعل' : 'مؤنث';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('لعبة القواعد • ${arNum(score)} ⭐')),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Text(emoji, style: const TextStyle(fontSize: 60)),
              Text(word, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
              const SizedBox(height: 30),
              Row(children: [
                Expanded(
                  child: Button3D(
                    onTap: () => _answer(false),
                    color: const Color(0xFF2979FF),
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    child: Center(child: Text(leftLabel, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: Colors.white))),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Button3D(
                    onTap: () => _answer(true),
                    color: const Color(0xFFFF1E7E),
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    child: Center(child: Text(rightLabel, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: Colors.white))),
                  ),
                ),
              ]),
            ]),
          ),
          CelebrationOverlay(message: cheer),
        ]),
      ),
    );
  }
}
