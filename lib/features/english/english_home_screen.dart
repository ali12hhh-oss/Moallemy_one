import 'package:flutter/material.dart';

import '../../data/content.dart';
import '../../data/content_v11.dart';
import '../../core/audio/voice_service.dart';
import 'english_phonics_rules_screen_v12.dart';

class EnglishHomeScreen extends StatelessWidget {
  final String? stageId;
  const EnglishHomeScreen({super.key, this.stageId});

  void open(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final early = stageId == 'prep' || stageId == 'g1';
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('اللغة الإنجليزية')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      early ? 'بداية الإنجليزية 🌟' : 'الإنجليزية 📚',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      early
                          ? 'الحروف الصغيرة والأرقام والأصوات مع شرح عربي.'
                          : 'قراءة كلمات وجمل بسيطة مع دعم عربي.',
                    ),
                  ],
                ),
              ),
            ),
            if (early)
              ListTile(
                leading: const Text('🔤', style: TextStyle(fontSize: 35)),
                title: const Text('الحروف الإنجليزية الصغيرة'),
                subtitle: const Text(
                  'الحروف a–z بصورتها الصغيرة مع الصوت والقراءة والترجمة العربية',
                ),
                onTap: () => open(
                  context,
                  const EnglishLettersScreen(lowercaseOnly: true),
                ),
              ),
            ListTile(
              leading: const Text('🧩', style: TextStyle(fontSize: 35)),
              title: Text(
                early ? 'كلمات قصيرة مع صور' : 'قراءة الكلمات والجمل',
              ),
              subtitle: const Text('كلمات قصيرة مع ترجمة عربية'),
              onTap: () => open(context, const EnglishWordsScreen()),
            ),
            ListTile(
              leading: const Text('🔤', style: TextStyle(fontSize: 35)),
              title: const Text('قواعد وأصوات القراءة'),
              subtitle: const Text('sh و ch و th و ph وغيرها'),
              onTap: () => open(context, const EnglishPhonicsRulesScreenV12()),
            ),
            ListTile(
              leading: const Text('🎨', style: TextStyle(fontSize: 35)),
              title: const Text('الألوان'),
              onTap: () => open(context, const EnglishColorsScreen()),
            ),
            ListTile(
              leading: const Text('🔢', style: TextStyle(fontSize: 35)),
              title: const Text('الأرقام'),
              onTap: () => open(context, const EnglishNumbersScreen()),
            ),
          ],
        ),
      ),
    );
  }
}

class EnglishLettersScreen extends StatefulWidget {
  final bool lowercaseOnly;
  const EnglishLettersScreen({super.key, this.lowercaseOnly = false});

  @override
  State<EnglishLettersScreen> createState() => _ELS();
}

class _ELS extends State<EnglishLettersScreen> {
  int i = 0;

  @override
  Widget build(BuildContext context) {
    final x = englishLetters[i];
    final displayLetter =
        widget.lowercaseOnly ? x.letter.toLowerCase() : x.letter;
    return Scaffold(
      appBar: AppBar(title: const Text('الحروف الإنجليزية')),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            LinearProgressIndicator(value: (i + 1) / englishLetters.length),
            const SizedBox(height: 18),
            Text(
              displayLetter,
              style: const TextStyle(
                fontSize: 110,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('صوت الحرف: ${x.sound}', style: const TextStyle(fontSize: 25)),
            Text('${x.emoji}  ${x.word}', style: const TextStyle(fontSize: 30)),
            const Text(
              'الصوت والقراءة أهم من حفظ اسم الحرف',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: () => VoiceService.englishLetterSound(
                x.letter,
                fallbackText: x.sound,
              ),
              icon: const Icon(Icons.volume_up),
              label: const Text('استمع إلى صوت الحرف'),
            ),
            OutlinedButton.icon(
              onPressed: () => VoiceService.english(x.word),
              icon: const Icon(Icons.record_voice_over),
              label: const Text('استمع إلى الكلمة'),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: i == 0 ? null : () => setState(() => i--),
                    child: const Text('السابق'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: i == englishLetters.length - 1
                        ? null
                        : () => setState(() => i++),
                    child: const Text('التالي'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EnglishWordsScreen extends StatelessWidget {
  const EnglishWordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('كلمات إنجليزية مع ترجمة')),
        body: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.05,
          ),
          itemCount: englishWordsV11.length,
          itemBuilder: (_, i) {
            final w = englishWordsV11[i];
            return Card(
              child: InkWell(
                onTap: () => VoiceService.english(w.word),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(w.emoji, style: const TextStyle(fontSize: 36)),
                      Text(
                        w.word.toLowerCase(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(w.arabic, style: const TextStyle(fontSize: 17)),
                      const SizedBox(height: 5),
                      const Icon(Icons.volume_up_rounded),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class EnglishColorsScreen extends StatelessWidget {
  const EnglishColorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الألوان بالإنجليزية')),
      body: ListView(
        children: [
          for (final x in englishColors)
            ListTile(
              leading: Text(x['emoji']!, style: const TextStyle(fontSize: 30)),
              title: Text(
                x['name']!.toLowerCase(),
                style: const TextStyle(fontSize: 22),
              ),
              subtitle: Text(x['ar']!),
              trailing: IconButton(
                onPressed: () => VoiceService.english(x['name']!),
                icon: const Icon(Icons.volume_up),
              ),
            ),
        ],
      ),
    );
  }
}

class EnglishNumbersScreen extends StatelessWidget {
  const EnglishNumbersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الأرقام بالإنجليزية')),
      body: GridView.count(
        crossAxisCount: 4,
        padding: const EdgeInsets.all(12),
        children: [
          for (final n in englishNumbers)
            Card(
              child: InkWell(
                onTap: () => VoiceService.english(n),
                child: Center(
                  child: Text(
                    n,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
