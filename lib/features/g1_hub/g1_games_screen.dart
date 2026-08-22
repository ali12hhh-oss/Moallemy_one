import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../core/storage/progress_v8.dart';
import '../../data/content.dart';
import '../../data/short_words.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

class G1GamesScreen extends StatelessWidget {
  const G1GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final games = <(String, String, String, Color, Widget)>[
      (
        '🔤',
        'لعبة الكلمات العربية',
        'شاهد الصورة واختر الكلمة الصحيحة',
        const Color(0xFF7C4DFF),
        const _ArabicWordGame(),
      ),
      (
        '🇬🇧',
        'English Letters Game',
        'استمع للحرف واختر شكله',
        const Color(0xFF2979FF),
        const _EnglishLetterGame(),
      ),
      (
        '🧮',
        'لعبة الرياضيات',
        'جمع وطرح سريع، والناتج لا يتجاوز ١٠',
        const Color(0xFF00C853),
        const _MathGame(),
      ),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الألعاب 🎮')),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children:
              games.map((g) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Button3D(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => g.$5),
                        ),
                    color: g.$4,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 20,
                    ),
                    child: Row(
                      children: [
                        Text(g.$1, style: const TextStyle(fontSize: 34)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                g.$2,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                g.$3,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}

/// لعبة الكلمات العربية: شاهد الرمز (إيموجي) واختر الكلمة الصحيحة.
class _ArabicWordGame extends StatefulWidget {
  const _ArabicWordGame();
  @override
  State<_ArabicWordGame> createState() => _ArabicWordGameState();
}

class _ArabicWordGameState extends State<_ArabicWordGame> {
  final rnd = Random();
  late final all = [...twoLetterWords, ...threeLetterWords];
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
        appBar: AppBar(title: Text('لعبة الكلمات • ${arNum(score)} ⭐')),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(target.emoji, style: const TextStyle(fontSize: 70)),
                  const SizedBox(height: 10),
                  const Text(
                    'ما هذه الكلمة؟',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      children:
                          options
                              .map(
                                (o) => Button3D(
                                  onTap: () => _answer(o),
                                  color: const Color(0xFF7C4DFF),
                                  child: Center(
                                    child: Text(
                                      o.word,
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ],
              ),
            ),
            CelebrationOverlay(message: cheer),
          ],
        ),
      ),
    );
  }
}

/// English Letters Game: hear the letter sound, pick the matching letter.
class _EnglishLetterGame extends StatefulWidget {
  const _EnglishLetterGame();
  @override
  State<_EnglishLetterGame> createState() => _EnglishLetterGameState();
}

class _EnglishLetterGameState extends State<_EnglishLetterGame> {
  final rnd = Random();
  late EnglishLetter target;
  late List<EnglishLetter> options;
  int score = 0;
  String? cheer;

  @override
  void initState() {
    super.initState();
    _next();
  }

  void _next() {
    target = englishLetters[rnd.nextInt(englishLetters.length)];
    final others = [...englishLetters]..shuffle(rnd);
    others.removeWhere((l) => l.letter == target.letter);
    options = [target, ...others.take(3)]..shuffle(rnd);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => VoiceService.englishLetterSound(
        target.letter.toLowerCase(),
        fallbackText: target.sound,
      ),
    );
  }

  void _answer(EnglishLetter chosen) {
    if (chosen.letter == target.letter) {
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
      VoiceService.englishLetterSound(
        target.letter.toLowerCase(),
        fallbackText: target.sound,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('English Letters • ${arNum(score)} ⭐')),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  IconButton(
                    iconSize: 44,
                    icon: const Icon(Icons.volume_up_rounded),
                    onPressed:
                        () => VoiceService.englishLetterSound(
                          target.letter.toLowerCase(),
                          fallbackText: target.sound,
                        ),
                  ),
                  const Text(
                    'Which letter did you hear?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      children:
                          options
                              .map(
                                (o) => Button3D(
                                  onTap: () => _answer(o),
                                  color: const Color(0xFF2979FF),
                                  child: Center(
                                    child: Text(
                                      o.letter.toLowerCase(),
                                      style: const TextStyle(
                                        fontSize: 38,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ],
              ),
            ),
            CelebrationOverlay(message: cheer),
          ],
        ),
      ),
    );
  }
}

/// لعبة الرياضيات: جمع وطرح سريع، الناتج لا يتجاوز ١٠.
class _MathGame extends StatefulWidget {
  const _MathGame();
  @override
  State<_MathGame> createState() => _MathGameState();
}

class _MathGameState extends State<_MathGame> {
  final rnd = Random();
  late bool isAddition;
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
    isAddition = rnd.nextBool();
    if (isAddition) {
      a = 1 + rnd.nextInt(8);
      b = 1 + rnd.nextInt(10 - a);
      answer = a + b;
    } else {
      a = 2 + rnd.nextInt(9);
      b = 1 + rnd.nextInt(a);
      answer = a - b;
    }
    final others = {for (var i = 0; i <= 10; i++) i}..remove(answer);
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
  }

  @override
  Widget build(BuildContext context) {
    final op = isAddition ? '+' : '−';
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('لعبة الرياضيات • ${arNum(score)} ⭐')),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    '${arNum(a)} $op ${arNum(b)} = ؟',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      children:
                          options
                              .map(
                                (o) => Button3D(
                                  onTap: () => _answer(o),
                                  color: const Color(0xFF00C853),
                                  child: Center(
                                    child: Text(
                                      arNum(o),
                                      style: const TextStyle(
                                        fontSize: 34,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ],
              ),
            ),
            CelebrationOverlay(message: cheer),
          ],
        ),
      ),
    );
  }
}
