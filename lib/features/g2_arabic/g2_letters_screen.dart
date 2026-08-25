import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/theme/stage_colors.dart';
import '../../data/content.dart';

class G2LettersScreen extends StatefulWidget {
  const G2LettersScreen({super.key});

  @override
  State<G2LettersScreen> createState() => _G2LettersScreenState();
}

class _G2LettersScreenState extends State<G2LettersScreen> {
  int index = 0;
  int form = 0;
  bool playing = false;

  static const formNames = ['أولي', 'وسطي', 'أخري'];

  static const forms = <String, List<String>>{
    'أ': ['ا', 'ا', 'ـا'],
    'ب': ['بـ', 'ـبـ', 'ـب'],
    'ت': ['تـ', 'ـتـ', 'ـت'],
    'ث': ['ثـ', 'ـثـ', 'ـث'],
    'ج': ['جـ', 'ـجـ', 'ـج'],
    'ح': ['حـ', 'ـحـ', 'ـح'],
    'خ': ['خـ', 'ـخـ', 'ـخ'],
    'د': ['د', 'د', 'ـد'],
    'ذ': ['ذ', 'ذ', 'ـذ'],
    'ر': ['ر', 'ر', 'ـر'],
    'ز': ['ز', 'ز', 'ـز'],
    'س': ['سـ', 'ـسـ', 'ـس'],
    'ش': ['شـ', 'ـشـ', 'ـش'],
    'ص': ['صـ', 'ـصـ', 'ـص'],
    'ض': ['ضـ', 'ـضـ', 'ـض'],
    'ط': ['طـ', 'ـطـ', 'ـط'],
    'ظ': ['ظـ', 'ـظـ', 'ـظ'],
    'ع': ['عـ', 'ـعـ', 'ـع'],
    'غ': ['غـ', 'ـغـ', 'ـغ'],
    'ف': ['فـ', 'ـفـ', 'ـف'],
    'ق': ['قـ', 'ـقـ', 'ـق'],
    'ك': ['كـ', 'ـكـ', 'ـك'],
    'ل': ['لـ', 'ـلـ', 'ـل'],
    'م': ['مـ', 'ـمـ', 'ـم'],
    'ن': ['نـ', 'ـنـ', 'ـن'],
    'ه': ['هـ', 'ـهـ', 'ـه'],
    'و': ['و', 'و', 'ـو'],
    // Arabic yaa: initial يـ, medial ـيـ, final ـي (with two dots).
    'ي': ['يـ', 'ـيـ', '\u0640\u064A'],
  };

  ArabicLetter get current => arabicLetters[index];
  String get displayedForm => forms[current.letter]![form];

  Future<void> _playLetter() async {
    if (playing) return;
    setState(() => playing = true);
    try {
      await VoiceService.stop();
      await VoiceService.arabicLetterSound(
        current.letter,
        fallbackText: current.sound,
      );
    } finally {
      if (mounted) setState(() => playing = false);
    }
  }

  void _previous() {
    if (index == 0) return;
    VoiceService.stop();
    setState(() {
      index--;
      form = 0;
    });
  }

  void _next() {
    if (index >= arabicLetters.length - 1) return;
    VoiceService.stop();
    setState(() {
      index++;
      form = 0;
    });
  }

  @override
  void dispose() {
    VoiceService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final letter = current;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('حروف الروضة الثانية'),
          backgroundColor: StageColors.of('kg2'),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxHeight < 650;
              final letterSize = compact ? 78.0 : 104.0;

              return SingleChildScrollView(
                padding: EdgeInsets.all(compact ? 10 : 16),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: (index + 1) / arabicLetters.length,
                      minHeight: 7,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'الحرف ${index + 1} من ${arabicLetters.length}',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: compact ? 8 : 12),
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: EdgeInsets.all(compact ? 10 : 16),
                        child: Column(
                          children: [
                            SizedBox(
                              height: compact ? 105 : 135,
                              child: Center(
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 180),
                                  child: Text(
                                    displayedForm,
                                    key: ValueKey('$index-$form'),
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: letterSize,
                                      height: 1.0,
                                      fontWeight: FontWeight.w900,
                                      color: StageColors.of('kg2'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'صوت الحرف: ${letter.sound}',
                              style: TextStyle(
                                fontSize: compact ? 17 : 21,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'اسم الحرف: ${_name(letter.letter)}',
                              style: TextStyle(fontSize: compact ? 14 : 17),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${letter.emoji}  ${letter.word}',
                              style: TextStyle(
                                fontSize: compact ? 20 : 26,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: compact ? 8 : 12),
                            Row(
                              children: List.generate(formNames.length, (i) {
                                final selected = form == i;
                                return Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: i == 0 ? 0 : 5,
                                    ),
                                    child: FilledButton(
                                      style: FilledButton.styleFrom(
                                        minimumSize: const Size(0, 44),
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        backgroundColor: selected
                                            ? StageColors.of('kg2')
                                            : Colors.grey.shade600,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(11),
                                        ),
                                      ),
                                      onPressed: () => setState(() => form = i),
                                      child: Text(formNames[i]),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            SizedBox(height: compact ? 7 : 10),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size(0, 48),
                                  backgroundColor: const Color(0xFFFFA000),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                ),
                                onPressed: playing ? null : _playLetter,
                                icon: Icon(
                                  playing
                                      ? Icons.volume_up_rounded
                                      : Icons.play_circle_fill_rounded,
                                ),
                                label: Text(
                                  playing
                                      ? 'جارٍ تشغيل صوت الحرف...'
                                      : 'استمع إلى صوت الحرف',
                                  style: const TextStyle(fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextButton.icon(
                              onPressed: () =>
                                  VoiceService.arabicLetterName(letter.letter),
                              icon: const Icon(Icons.badge_outlined),
                              label: const Text('اسم الحرف'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: compact ? 8 : 14),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: index == 0 ? null : _previous,
                            icon: const Icon(Icons.arrow_back_rounded),
                            label: const Text('السابق'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: index == arabicLetters.length - 1
                                ? null
                                : _next,
                            icon: const Icon(Icons.arrow_forward_rounded),
                            label: const Text('التالي'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String _name(String letter) {
    const names = {
      'أ': 'ألف',
      'ب': 'باء',
      'ت': 'تاء',
      'ث': 'ثاء',
      'ج': 'جيم',
      'ح': 'حاء',
      'خ': 'خاء',
      'د': 'دال',
      'ذ': 'ذال',
      'ر': 'راء',
      'ز': 'زاي',
      'س': 'سين',
      'ش': 'شين',
      'ص': 'صاد',
      'ض': 'ضاد',
      'ط': 'طاء',
      'ظ': 'ظاء',
      'ع': 'عين',
      'غ': 'غين',
      'ف': 'فاء',
      'ق': 'قاف',
      'ك': 'كاف',
      'ل': 'لام',
      'م': 'ميم',
      'ن': 'نون',
      'ه': 'هاء',
      'و': 'واو',
      'ي': 'ياء',
    };
    return names[letter] ?? letter;
  }
}
