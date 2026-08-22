import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../core/storage/progress_v8.dart';
import '../../data/content.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

const _kg2Pairs = <(String, String)>[
  ('د', 'ا'),
  ('ن', 'ا'),
  ('د', 'و'),
  ('د', 'ي'),
  ('ب', 'ا'),
  ('ب', 'و'),
  ('ت', 'ا'),
  ('س', 'ا'),
  ('م', 'ا'),
  ('ر', 'ا'),
  ('ل', 'ا'),
  ('ك', 'ا'),
  ('ف', 'ي'),
  ('ه', 'ي'),
  ('ن', 'ي'),
  ('م', 'ن'),
  ('ل', 'ك'),
  ('ب', 'ه'),
  ('ي', 'د'),
  ('و', 'ل'),
];

class Kg2GamesScreen extends StatelessWidget {
  const Kg2GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final games = <(String, String, String, Color, Widget)>[
      (
        '🔤',
        'لعبة الحروف',
        'استمع للحرف واختر شكله الصحيح',
        const Color(0xFF7C4DFF),
        const _LetterGame(),
      ),
      (
        '🧩',
        'لعبة دمج الحروف',
        'اختر الدمج الصحيح لحرفين معًا',
        const Color(0xFFFF1E7E),
        const _CombineGame(),
      ),
      (
        '1️⃣',
        'لعبة الآحاد',
        'عدّ الصور من ١ إلى ٩',
        const Color(0xFF2979FF),
        const _OnesGame(),
      ),
      (
        '🔟',
        'لعبة العشرات',
        'ميّز العشرات من ١٠ إلى ٥٠',
        const Color(0xFF00C853),
        const _TensGame(),
      ),
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
                onTap: () => Navigator.push(
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
                    Text(g.$1, style: const TextStyle(fontSize: 36)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            g.$2,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            g.$3,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
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

/// لعبة الحروف: استمع للحرف واختر شكله الصحيح من 4 خيارات.
class _LetterGame extends StatefulWidget {
  const _LetterGame();
  @override
  State<_LetterGame> createState() => _LetterGameState();
}

class _LetterGameState extends State<_LetterGame> {
  final rnd = Random();
  late ArabicLetter target;
  late List<ArabicLetter> options;
  int score = 0;
  String? cheer;

  @override
  void initState() {
    super.initState();
    _next();
  }

  void _next() {
    target = arabicLetters[rnd.nextInt(arabicLetters.length)];
    final others = [...arabicLetters]..shuffle(rnd);
    others.removeWhere((l) => l.letter == target.letter);
    options = [target, ...others.take(3)]..shuffle(rnd);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => VoiceService.arabicLetterSound(
        target.letter,
        fallbackText: target.sound,
      ),
    );
  }

  void _answer(ArabicLetter chosen) {
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
      VoiceService.arabicLetterSound(target.letter, fallbackText: target.sound);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('لعبة الحروف • ${arNum(score)} ⭐')),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  IconButton(
                    iconSize: 42,
                    icon: const Icon(Icons.volume_up_rounded),
                    onPressed: () => VoiceService.arabicLetterSound(
                      target.letter,
                      fallbackText: target.sound,
                    ),
                  ),
                  const Text(
                    'أي حرف سمعت؟',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      children: options
                          .map(
                            (o) => Button3D(
                              onTap: () => _answer(o),
                              color: const Color(0xFF7C4DFF),
                              child: Center(
                                child: Text(
                                  o.letter,
                                  style: const TextStyle(
                                    fontSize: 40,
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

/// لعبة دمج الحروف: يُعرض حرفان، والطفل يختار الدمج الصحيح من 4 خيارات.
class _CombineGame extends StatefulWidget {
  const _CombineGame();
  @override
  State<_CombineGame> createState() => _CombineGameState();
}

class _CombineGameState extends State<_CombineGame> {
  final rnd = Random();
  late (String, String) target;
  late List<String> options;
  int score = 0;
  String? cheer;

  @override
  void initState() {
    super.initState();
    _next();
  }

  void _next() {
    target = _kg2Pairs[rnd.nextInt(_kg2Pairs.length)];
    final correct = '${target.$1}${target.$2}';
    final others = _kg2Pairs
        .map((p) => '${p.$1}${p.$2}')
        .where((c) => c != correct)
        .toList()
      ..shuffle(rnd);
    options = [correct, ...others.take(3)]..shuffle(rnd);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => VoiceService.arabic('${target.$1} مع ${target.$2}'),
    );
  }

  void _answer(String chosen) {
    final correct = '${target.$1}${target.$2}';
    if (chosen == correct) {
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
      VoiceService.arabic('${target.$1} مع ${target.$2}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('لعبة دمج الحروف • ${arNum(score)} ⭐')),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        target.$1,
                        style: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Text(' + ', style: TextStyle(fontSize: 34)),
                      Text(
                        target.$2,
                        style: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'ما ناتج الدمج؟',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      children: options
                          .map(
                            (o) => Button3D(
                              onTap: () => _answer(o),
                              color: const Color(0xFFFF1E7E),
                              child: Center(
                                child: Text(
                                  o,
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

const _icons = ['🍎', '⭐', '🎈', '🐝', '🌸', '🍓'];

/// لعبة الآحاد: عدّ الصور من ١ إلى ٩.
class _OnesGame extends StatefulWidget {
  const _OnesGame();
  @override
  State<_OnesGame> createState() => _OnesGameState();
}

class _OnesGameState extends State<_OnesGame> {
  final rnd = Random();
  late int target;
  late String icon;
  late List<int> options;
  int score = 0;
  String? cheer;

  @override
  void initState() {
    super.initState();
    _next();
  }

  void _next() {
    target = 1 + rnd.nextInt(9);
    icon = _icons[rnd.nextInt(_icons.length)];
    final others = {for (var i = 1; i <= 9; i++) i}..remove(target);
    final list = others.toList()..shuffle(rnd);
    options = [target, ...list.take(3)]..shuffle(rnd);
  }

  void _answer(int chosen) {
    if (chosen == target) {
      score++;
      setState(() => cheer = kCheers[rnd.nextInt(kCheers.length)]);
      ProgressV8.addRewards(stars: 1, xp: 5);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => cheer = null);
          _next();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('لعبة الآحاد • ${arNum(score)} ⭐')),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'كم عدد الصور؟',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      target,
                      (_) => Text(icon, style: const TextStyle(fontSize: 34)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      children: options
                          .map(
                            (o) => Button3D(
                              onTap: () => _answer(o),
                              color: const Color(0xFF2979FF),
                              child: Center(
                                child: Text(
                                  arNum(o),
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

/// لعبة العشرات: يُعرض عدد من الآحاد مجمّعة، والطفل يختار العدد العشري الصحيح (١٠-٥٠).
class _TensGame extends StatefulWidget {
  const _TensGame();
  @override
  State<_TensGame> createState() => _TensGameState();
}

class _TensGameState extends State<_TensGame> {
  final rnd = Random();
  static const tensList = [10, 20, 30, 40, 50];
  late int target;
  late List<int> options;
  int score = 0;
  String? cheer;

  @override
  void initState() {
    super.initState();
    _next();
  }

  void _next() {
    target = tensList[rnd.nextInt(tensList.length)];
    final others = tensList.where((t) => t != target).toList()..shuffle(rnd);
    options = [target, ...others.take(3)]..shuffle(rnd);
  }

  void _answer(int chosen) {
    if (chosen == target) {
      score++;
      setState(() => cheer = kCheers[rnd.nextInt(kCheers.length)]);
      ProgressV8.addRewards(stars: 1, xp: 5);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => cheer = null);
          _next();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final groups = target ~/ 10;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('لعبة العشرات • ${arNum(score)} ⭐')),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'كم عدد النقاط؟ (كل مجموعة = عشرة)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 8,
                    children: List.generate(
                      groups,
                      (_) => Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Wrap(
                          spacing: 3,
                          runSpacing: 3,
                          children: List.generate(
                            10,
                            (_) => Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF00C853),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      children: options
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
