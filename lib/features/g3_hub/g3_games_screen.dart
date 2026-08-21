import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../core/storage/progress_v8.dart';
import '../../data/content_v11.dart';
import '../../data/fractions.dart';
import '../../data/short_words.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

class G3GamesScreen extends StatelessWidget {
  const G3GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final games = <(String, String, String, Color, Widget)>[
      ('📖', 'لعبة القراءة', 'شاهد الصورة واختر الكلمة الصحيحة', const Color(0xFF7C4DFF), const _ReadingGame()),
      ('🇬🇧', 'English Game', 'استمع للكلمة واختر معناها', const Color(0xFF2979FF), const _EnglishGame()),
      ('✖️', 'لعبة الضرب', 'أكمل جدول الضرب بسرعة', const Color(0xFF00C853), const _MultiplicationGame()),
      ('➗', 'لعبة القسمة', 'اقسم بالتساوي واختر الناتج', const Color(0xFFFF6B35), const _DivisionGame()),
      ('🍕', 'لعبة الكسور', 'شاهد الرسم واختر اسم الكسر', const Color(0xFFFF1E7E), const _FractionsGame()),
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
                  Text(g.$1, style: const TextStyle(fontSize: 32)),
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

class _ReadingGame extends StatefulWidget {
  const _ReadingGame();
  @override
  State<_ReadingGame> createState() => _ReadingGameState();
}

class _ReadingGameState extends State<_ReadingGame> {
  final rnd = Random();
  late final all = [...twoLetterWords, ...threeLetterWords, ...fourLetterWords, ...fiveLetterWords];
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
                  children: options.map((o) => Button3D(onTap: () => _answer(o), color: const Color(0xFF7C4DFF), child: Center(child: Text(o.word, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white))))).toList(),
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
                  children: options.map((o) => Button3D(onTap: () => _answer(o), color: const Color(0xFF2979FF), child: Center(child: Text('${o.emoji} ${o.arabic}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white))))).toList(),
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

class _MultiplicationGame extends StatefulWidget {
  const _MultiplicationGame();
  @override
  State<_MultiplicationGame> createState() => _MultiplicationGameState();
}

class _MultiplicationGameState extends State<_MultiplicationGame> {
  final rnd = Random();
  late int a, b, answer;
  late List<int> options;
  int score = 0;
  String? cheer;

  @override
  void initState() {
    super.initState();
    _next();
  }

  void _next() {
    a = 1 + rnd.nextInt(10);
    b = 1 + rnd.nextInt(10);
    answer = a * b;
    final others = {for (var i = max(1, answer - 8); i <= answer + 8; i++) i}..remove(answer);
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
        appBar: AppBar(title: Text('لعبة الضرب • ${arNum(score)} ⭐')),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Text('${arNum(a)} × ${arNum(b)} = ؟', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900)),
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

class _DivisionGame extends StatefulWidget {
  const _DivisionGame();
  @override
  State<_DivisionGame> createState() => _DivisionGameState();
}

class _DivisionGameState extends State<_DivisionGame> {
  final rnd = Random();
  late int dividend, divisor, answer;
  late List<int> options;
  int score = 0;
  String? cheer;

  @override
  void initState() {
    super.initState();
    _next();
  }

  void _next() {
    divisor = 2 + rnd.nextInt(5);
    answer = 2 + rnd.nextInt(8);
    dividend = divisor * answer;
    final others = {for (var i = max(1, answer - 4); i <= answer + 4; i++) i}..remove(answer);
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
        appBar: AppBar(title: Text('لعبة القسمة • ${arNum(score)} ⭐')),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Text('${arNum(dividend)} ÷ ${arNum(divisor)} = ؟', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900)),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  children: options.map((o) => Button3D(onTap: () => _answer(o), color: const Color(0xFFFF6B35), child: Center(child: Text(arNum(o), style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white))))).toList(),
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

class _FractionsGame extends StatefulWidget {
  const _FractionsGame();
  @override
  State<_FractionsGame> createState() => _FractionsGameState();
}

class _FractionsGameState extends State<_FractionsGame> {
  final rnd = Random();
  late FractionItem target;
  late List<String> options;
  int score = 0;
  String? cheer;

  @override
  void initState() {
    super.initState();
    _next();
  }

  void _next() {
    target = fractions[rnd.nextInt(fractions.length)];
    final others = fractions.map((f) => f.name).where((n) => n != target.name).toList()..shuffle(rnd);
    options = [target.name, ...others]..shuffle(rnd);
  }

  void _answer(String chosen) {
    if (chosen == target.name) {
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
        appBar: AppBar(title: Text('لعبة الكسور • ${arNum(score)} ⭐')),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              const Text('ما اسم هذا الكسر؟', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text(target.symbol, style: const TextStyle(fontSize: 60, fontWeight: FontWeight.w900)),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  children: options.map((o) => Button3D(onTap: () => _answer(o), color: const Color(0xFFFF1E7E), child: Center(child: Text(o, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white))))).toList(),
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
