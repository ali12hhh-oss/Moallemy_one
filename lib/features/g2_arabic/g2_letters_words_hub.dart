import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../data/short_words.dart';
import '../../widgets/button_3d.dart';
import 'g2_read_hub.dart';
import 'g2_write_recognize_screen.dart';

class G2LettersWordsHub extends StatelessWidget {
  const G2LettersWordsHub({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <(String, String, String, Color, Widget)>[
      ('📖', 'القراءة', 'كلمات من حرفين وثلاثة وأربعة أحرف، وجمل قصيرة', const Color(0xFFFF6B35), const G2ReadHub()),
      ('الـ', 'ال التعريف', 'فصل ال التعريف عن الكلمة ثم دمجهما لتكوين الكلمة بشكل صحيح', const Color(0xFF7C4DFF), const G2AlDefinitionContent()),
      ('✏️', 'الكتابة', 'سبورة ذكية تقرأ ما تكتبه بصوتها، بألوان مختلفة', const Color(0xFF00BFA6), const G2WriteRecognizeScreen()),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('القراءة والكتابة')),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: items.map((g) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Button3D(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => g.$5)),
              color: g.$4,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              child: Row(children: [
                Text(g.$1, style: const TextStyle(fontSize: 36)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(g.$2, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: Colors.white)),
                  const SizedBox(height: 3),
                  Text(g.$3, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ])),
              ]),
            ),
          )).toList(),
        ),
      ),
    );
  }
}

class G2AlDefinitionContent extends StatefulWidget {
  const G2AlDefinitionContent({super.key});

  @override
  State<G2AlDefinitionContent> createState() => _G2AlDefinitionContentState();
}

class _G2AlDefinitionContentState extends State<G2AlDefinitionContent> {
  int index = 0;
  bool merged = false;

  // ال التعريف تأتي مع الأسماء فقط. نُبقي «يد» كاستثناء من كلمتيْن،
  // ثم نعرض الأسماء المعروفة من ثلاثة أحرف فأكثر. لا نستخدم هنا
  // حروف الجر أو الضمائر أو أسماء الإشارة أو الأفعال.
  late final List<ShortWord> words = [
    ...twoLetterWords.where((w) => w.word == 'يد'),
    ...threeLetterWords.where((w) => const {
      'قمر', 'شمس', 'بيت', 'قلم', 'باب', 'ولد', 'بنت', 'سمك', 'عين',
      'جمل', 'كرة', 'ورد', 'نور', 'فيل', 'نمر', 'بحر', 'ذهب', 'حوت',
      'أسد', 'أنف', 'أذن', 'رجل', 'قدم', 'علم', 'قطة', 'كلب', 'بقر',
    }.contains(w.word)),
    ...fourLetterWords,
    ...fiveLetterWords,
  ];

  ShortWord get current => words[index];
  String get fullWord => 'ال${current.word}';

  void _speak(String text) {
    VoiceService.stop();
    VoiceService.arabic(text);
  }

  void _move(int delta) {
    VoiceService.stop();
    setState(() {
      index = (index + delta + words.length) % words.length;
      merged = false;
    });
  }

  @override
  void dispose() {
    VoiceService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final wordSize = (width * .16).clamp(52.0, 88.0);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('ال التعريف')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 650),
                child: Column(children: [
                  const Text('افصل (ال) عن الكلمة ثم اجمعهما', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 6),
                  Text('${index + 1} من ${words.length}', style: const TextStyle(fontSize: 15)),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 22),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: .10),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: .28), width: 2),
                    ),
                    child: Column(children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        child: merged
                            ? Text(fullWord, key: const ValueKey('merged'), textAlign: TextAlign.center, style: TextStyle(fontSize: wordSize, height: 1.05, fontWeight: FontWeight.w900))
                            : Row(
                                key: const ValueKey('separated'),
                                mainAxisAlignment: MainAxisAlignment.center,
                                textDirection: TextDirection.rtl,
                                children: [
                                  _wordPart('ال', const Color(0xFF7C4DFF), 'ال'),
                                  const SizedBox(width: 18),
                                  _wordPart(current.word, const Color(0xFFFF6B35), current.word),
                                ],
                              ),
                      ),
                      const SizedBox(height: 10),
                      Text(merged ? fullWord : 'ال  +  ${current.word}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 14),
                      Wrap(alignment: WrapAlignment.center, spacing: 10, runSpacing: 10, children: [
                        SizedBox(
                          width: 210,
                          child: Button3D(
                            onTap: () {
                              setState(() => merged = !merged);
                              _speak(merged ? fullWord : 'ال');
                            },
                            color: merged ? const Color(0xFF00A896) : const Color(0xFFE08A00),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Icon(merged ? Icons.call_split_rounded : Icons.merge_rounded, color: Colors.white),
                              const SizedBox(width: 7),
                              Text(merged ? 'فصل ال التعريف' : 'دمج ال التعريف', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15)),
                            ]),
                          ),
                        ),
                        SizedBox(
                          width: 160,
                          child: Button3D(
                            onTap: () => _speak(merged ? fullWord : current.word),
                            color: const Color(0xFF2979FF),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Icon(Icons.volume_up_rounded, color: Colors.white),
                              SizedBox(width: 6),
                              Text('استمع', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                            ]),
                          ),
                        ),
                      ]),
                    ]),
                  ),
                  const SizedBox(height: 14),
                  Text('الكلمة: ${current.word}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(child: Button3D(onTap: () => _move(-1), color: const Color(0xFF2979FF), padding: const EdgeInsets.symmetric(vertical: 14), child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.arrow_back_rounded, color: Colors.white), SizedBox(width: 6), Text('السابق', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900)]))),
                    const SizedBox(width: 10),
                    Expanded(child: Button3D(onTap: () => _move(1), color: const Color(0xFFFF6B35), padding: const EdgeInsets.symmetric(vertical: 14), child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('التالي', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900)), SizedBox(width: 6), Icon(Icons.arrow_forward_rounded, color: Colors.white)]))),
                  ]),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _wordPart(String text, Color color, String spoken) => Button3D(
        onTap: () => _speak(spoken),
        color: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 38, height: 1, fontWeight: FontWeight.w900)),
      );
}
