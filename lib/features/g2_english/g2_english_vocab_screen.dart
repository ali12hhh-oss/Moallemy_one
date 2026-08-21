import 'package:flutter/material.dart';
import '../../core/audio/voice_service.dart';
import '../../data/content_v11.dart';
import '../../widgets/button_3d.dart';

/// مفردات إنجليزية أوسع (٦٠ كلمة) مع ترجمة عربية مرافقة، مقسّمة حسب الفئة.
class G2EnglishVocabScreen extends StatefulWidget {
  const G2EnglishVocabScreen({super.key});
  @override
  State<G2EnglishVocabScreen> createState() => _G2EnglishVocabScreenState();
}

class _G2EnglishVocabScreenState extends State<G2EnglishVocabScreen> {
  String? category;

  @override
  Widget build(BuildContext context) {
    final categories = englishWordsV11.map((w) => w.category).toSet().toList();
    final words = category == null ? englishWordsV11 : englishWordsV11.where((w) => w.category == category).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('Vocabulary 📚')),
        body: Column(children: [
          SizedBox(
            height: 46,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(label: const Text('الكل'), selected: category == null, onSelected: (_) => setState(() => category = null)),
                ),
                ...categories.map((c) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(label: Text(c), selected: category == c, onSelected: (_) => setState(() => category = c)),
                    )),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(14),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.1),
              itemCount: words.length,
              itemBuilder: (_, i) {
                final w = words[i];
                return Button3D(
                  onTap: () => VoiceService.english(w.word),
                  color: const Color(0xFF2979FF),
                  padding: const EdgeInsets.all(10),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(w.emoji, style: const TextStyle(fontSize: 34)),
                    const SizedBox(height: 6),
                    Text(w.word, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Colors.white)),
                    Text(w.arabic, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                  ]),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
