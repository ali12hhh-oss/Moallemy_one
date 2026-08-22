import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../core/storage/progress_v8.dart';
import '../../data/content.dart';
import '../../widgets/button_3d.dart';

/// صفحة اختيار اللعبة: لعبة الحروف ولعبة الأرقام، بأزرار 3D وتأثيرات تشجيع.
class Kg1GamesScreen extends StatelessWidget {
  const Kg1GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الألعاب 🎮')),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Button3D(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const _LetterGame()),
                  ),
              color: const Color(0xFF7C4DFF),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              child: const Row(
                children: [
                  Text('🔤', style: TextStyle(fontSize: 40)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'لعبة الحروف',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'استمع للحرف واختر الشكل الصحيح',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Button3D(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const _NumberGame()),
                  ),
              color: const Color(0xFF2979FF),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              child: const Row(
                children: [
                  Text('🔢', style: TextStyle(fontSize: 40)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'لعبة الأرقام',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'عدّ الصور واختر الرقم الصحيح',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _cheers = ['أحسنت! 🎉', 'رائع! 🌟', 'ممتاز يا بطل! 🏆', 'صح! 👏'];

/// لعبة الحروف: يُسمع الحرف، والطفل يختار الحرف الصحيح من 4 خيارات.
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
  String? feedback;
  bool locked = false;

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
    feedback = null;
    locked = false;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => VoiceService.arabicLetterSound(
        target.letter,
        fallbackText: target.sound,
      ),
    );
  }

  void _answer(ArabicLetter chosen) {
    if (locked) return;
    if (chosen.letter == target.letter) {
      setState(() {
        locked = true;
        score++;
        feedback = _cheers[rnd.nextInt(_cheers.length)];
      });
      ProgressV8.addRewards(stars: 1, xp: 5);
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) setState(_next);
      });
    } else {
      // إجابة خاطئة: لا ننتقل للسؤال التالي، نعيد المحاولة.
      setState(() => feedback = 'حاول مرة أخرى 💪');
      VoiceService.arabicLetterSound(target.letter, fallbackText: target.sound);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('لعبة الحروف • النجوم: ${arNum(score)} ⭐')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              IconButton(
                iconSize: 42,
                icon: const Icon(Icons.volume_up_rounded),
                onPressed:
                    () => VoiceService.arabicLetterSound(
                      target.letter,
                      fallbackText: target.sound,
                    ),
              ),
              const Text(
                'أي حرف سمعت؟',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child:
                    feedback == null
                        ? const SizedBox(height: 30)
                        : Text(
                          feedback!,
                          key: ValueKey(feedback),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  children:
                      options.map((o) {
                        return Button3D(
                          onTap: () => _answer(o),
                          color: const Color(0xFF00BFA6),
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
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// لعبة الأرقام: عدّ مجموعة من الرموز واختر الرقم الصحيح (١-١٠).
class _NumberGame extends StatefulWidget {
  const _NumberGame();
  @override
  State<_NumberGame> createState() => _NumberGameState();
}

class _NumberGameState extends State<_NumberGame> {
  final rnd = Random();
  static const icons = ['🍎', '⭐', '🎈', '🐝', '🌸', '🍓'];
  late int target;
  late String icon;
  late List<int> options;
  int score = 0;
  String? feedback;
  bool locked = false;

  @override
  void initState() {
    super.initState();
    _next();
  }

  void _next() {
    target = 1 + rnd.nextInt(10);
    icon = icons[rnd.nextInt(icons.length)];
    final others = {for (var i = 1; i <= 10; i++) i}..remove(target);
    final list = others.toList()..shuffle(rnd);
    options = [target, ...list.take(3)]..shuffle(rnd);
    feedback = null;
    locked = false;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => VoiceService.arabic('كم العدد؟'),
    );
  }

  void _answer(int chosen) {
    if (locked) return;
    if (chosen == target) {
      setState(() {
        locked = true;
        score++;
        feedback = _cheers[rnd.nextInt(_cheers.length)];
      });
      ProgressV8.addRewards(stars: 1, xp: 5);
      VoiceService.arabic(_numberWord(target));
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) setState(_next);
      });
    } else {
      setState(() => feedback = 'حاول مرة أخرى 💪');
    }
  }

  static String _numberWord(int n) =>
      const {
        1: 'واحد',
        2: 'اثنان',
        3: 'ثلاثة',
        4: 'أربعة',
        5: 'خمسة',
        6: 'ستة',
        7: 'سبعة',
        8: 'ثمانية',
        9: 'تسعة',
        10: 'عشرة',
      }[n] ??
      '$n';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('لعبة الأرقام • النجوم: ${arNum(score)} ⭐')),
        body: Padding(
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
              const SizedBox(height: 14),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child:
                    feedback == null
                        ? const SizedBox(height: 30)
                        : Text(
                          feedback!,
                          key: ValueKey(feedback),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  children:
                      options.map((o) {
                        return Button3D(
                          onTap: () => _answer(o),
                          color: const Color(0xFFFF6B35),
                          child: Center(
                            child: Text(
                              arNum(o),
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
