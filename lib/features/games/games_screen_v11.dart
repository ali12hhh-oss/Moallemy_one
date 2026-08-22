import 'dart:math';

import 'package:flutter/material.dart';

import '../../data/content.dart';
import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';

class GamesScreenV11 extends StatefulWidget {
  const GamesScreenV11({super.key});
  @override
  State<GamesScreenV11> createState() => _GamesScreenV11State();
}

class _GamesScreenV11State extends State<GamesScreenV11> {
  final Random random = Random();
  int score = 0;
  int round = 1;
  String mode = 'hunt';
  late ArabicLetter target;
  late List<ArabicLetter> options;

  @override
  void initState() {
    super.initState();
    _next();
  }

  void _next() {
    target = arabicLetters[random.nextInt(arabicLetters.length)];
    final set = <ArabicLetter>{target};
    while (set.length < 4) {
      set.add(arabicLetters[random.nextInt(arabicLetters.length)]);
    }
    options = set.toList()..shuffle();
  }

  void _answer(String letter) {
    final correct = letter == target.letter;
    if (correct) {
      score += 2;
      VoiceService.arabic(target.letter);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          correct
              ? 'أحسنت! +٢ نجمة ⭐'
              : 'حاول مرة أخرى، ابحث عن الصوت الصحيح 💪',
        ),
      ),
    );
    setState(() {
      round++;
      _next();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الألعاب التعليمية')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Text('⭐', style: TextStyle(fontSize: 30)),
                    const SizedBox(width: 8),
                    Text(
                      'النقاط: ${arNum(score)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'الجولة ${arNum(round)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'hunt',
                  label: Text('صائد الحروف'),
                  icon: Icon(Icons.search),
                ),
                ButtonSegment(
                  value: 'sound',
                  label: Text('اسمع واختر'),
                  icon: Icon(Icons.volume_up),
                ),
                ButtonSegment(
                  value: 'match',
                  label: Text('طابق'),
                  icon: Icon(Icons.extension),
                ),
              ],
              selected: {mode},
              onSelectionChanged: (v) => setState(() => mode = v.first),
            ),
            const SizedBox(height: 18),
            if (mode == 'hunt') _hunt(),
            if (mode == 'sound') _sound(),
            if (mode == 'match') _match(),
          ],
        ),
      ),
    );
  }

  Widget _hunt() => Column(
    children: [
      const Text(
        'صائد الحروف',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 8),
      Text(
        'التقط الحرف الذي تبدأ به كلمة ${target.word}',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 19),
      ),
      Text(target.emoji, style: const TextStyle(fontSize: 82)),
      const SizedBox(height: 12),
      ...options.map(
        (x) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.tonal(
              onPressed: () => _answer(x.letter),
              child: Text(x.letter, style: const TextStyle(fontSize: 30)),
            ),
          ),
        ),
      ),
    ],
  );

  Widget _sound() => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'اسمع ثم اختر',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          IconButton.filled(
            onPressed: () => VoiceService.arabic(target.letter),
            icon: const Icon(Icons.volume_up),
            iconSize: 40,
          ),
          const SizedBox(height: 16),
          ...options.map(
            (x) => ListTile(
              title: Center(
                child: Text(x.letter, style: const TextStyle(fontSize: 32)),
              ),
              onTap: () => _answer(x.letter),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _match() => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'طابق الحرف مع الصورة',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(target.emoji, style: const TextStyle(fontSize: 80)),
          Text(target.word, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: options
                .map(
                  (x) => ChoiceChip(
                    label: Text(x.letter, style: const TextStyle(fontSize: 25)),
                    selected: false,
                    onSelected: (_) => _answer(x.letter),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    ),
  );
}
