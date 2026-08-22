import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../data/language_rules_v12.dart';

class EnglishPhonicsRulesScreenV12 extends StatefulWidget {
  const EnglishPhonicsRulesScreenV12({super.key});
  @override
  State<EnglishPhonicsRulesScreenV12> createState() =>
      _EnglishPhonicsRulesScreenV12State();
}

class _EnglishPhonicsRulesScreenV12State
    extends State<EnglishPhonicsRulesScreenV12> {
  int grade = 1;
  int score = 0;
  int answered = 0;

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.ltr,
    child: Scaffold(
      appBar: AppBar(title: const Text('English Phonics & Reading')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Letter combinations',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Learn the sound made by two or more letters together, then practise it in a word.',
          ),
          const SizedBox(height: 12),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 1, label: Text('Grade 1')),
              ButtonSegment(value: 2, label: Text('Grade 2')),
              ButtonSegment(value: 3, label: Text('Grade 3')),
            ],
            selected: {grade},
            onSelectionChanged: (v) => setState(() => grade = v.first),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              title: const Text('Session score'),
              trailing: Text(
                '$score / $answered',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ...englishPhonicsRulesV12
              .where((r) => r.fromGrade <= grade)
              .map(_ruleCard),
        ],
      ),
    ),
  );

  Widget _ruleCard(EnglishPhonicsRuleV12 r) => Card(
    child: ExpansionTile(
      leading: Text(r.emoji, style: const TextStyle(fontSize: 32)),
      title: Text(
        '${r.pattern}  →  ${r.sound}',
        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
      subtitle: Text('${r.name}\nExamples: ${r.examples}'),
      children: [
        ListTile(
          leading: const Icon(Icons.volume_up),
          title: Text('Hear: ${r.pattern}'),
          onTap:
              () => VoiceService.englishLetterSound(
                r.pattern,
                fallbackText: r.pattern,
              ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Text(
            'Listen, then choose a word containing “${r.pattern}”.',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
          spacing: 8,
          children:
              _words(r)
                  .map(
                    (w) => OutlinedButton(
                      onPressed: () => _check(r, w),
                      child: Text(w),
                    ),
                  )
                  .toList(),
        ),
        const SizedBox(height: 12),
      ],
    ),
  );

  List<String> _words(EnglishPhonicsRuleV12 r) =>
      r.pattern == 'sh'
          ? ['ship', 'cat', 'fish']
          : r.pattern == 'ch'
          ? ['chair', 'dog', 'chicken']
          : r.pattern == 'th'
          ? ['three', 'sun', 'this']
          : r.examples.split(', ').take(2).toList() + ['cat'];

  void _check(EnglishPhonicsRuleV12 r, String word) {
    final correct = word.toLowerCase().contains(r.pattern);
    setState(() {
      answered++;
      if (correct) score++;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(correct ? 'Correct! ⭐' : 'Try again 🌱')),
    );
    if (correct) VoiceService.english('Correct. ${r.pattern}');
  }
}
