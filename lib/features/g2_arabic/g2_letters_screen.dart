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
    'ي': ['يـ', 'ـيـ', 'ـي'],
  };

  ArabicLetter get current => arabicLetters[index];
  String get displayedForm => forms[current.letter]![form];

  Future<void> _playLetter() async {
    if (playing) return;
    setState(() => playing = true);
    try {
      await VoiceService.arabic(current.sound);
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
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;
              final compact = height < 620;
              final veryCompact = height < 540;
              final horizontalPadding = width < 360 ? 8.0 : 12.0;
              final letterSize = veryCompact ? 62.0 : compact ? 72.0 : 92.0;
              final cardPadding = veryCompact ? 7.0 : compact ? 9.0 : 12.0;

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: compact ? 6 : 10,
                ),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: (index + 1) / arabicLetters.length,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    SizedBox(height: compact ? 4 : 7),
                    Text(
                      'الحرف ${index + 1} من ${arabicLetters.length}',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: compact ? 13 : 15,
                      ),
                    ),
                    SizedBox(height: compact ? 5 : 8),
                    Expanded(
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: EdgeInsets.all(cardPadding),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                flex: 5,
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
                              Text(
                                'صوت الحرف: ${letter.sound}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: compact ? 15 : 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                'اسم الحرف: ${_name(letter.letter)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: compact ? 12 : 14),
                              ),
                              SizedBox(height: compact ? 2 : 4),
                              Text(
                                '${letter.emoji}  ${letter.word}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: compact ? 17 : 21,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(height: compact ? 5 : 8),
                              Row(
                                children: List.generate(formNames.length, (i) {
                                  final selected = form == i;
                                  return Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: i == 0 ? 0 : 4),
                                      child: FilledButton(
                                        style: FilledButton.styleFrom(
                                          minimumSize: Size(0, compact ? 36 : 40),
                                          padding: const EdgeInsets.symmetric(horizontal: 2),
                                          backgroundColor: selected
                                              ? StageColors.of('kg2')
                                              : Colors.grey.shade600,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () => setState(() => form = i),
                                        child: Text(
                                          formNames[i],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              SizedBox(height: compact ? 4 : 7),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  style: FilledButton.styleFrom(
                                    minimumSize: Size(0, compact ? 42 : 46),
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    backgroundColor: const Color(0xFFFFA000),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: playing ? null : _playLetter,
                                  icon: Icon(
                                    playing
                                        ? Icons.volume_up_rounded
                                        : Icons.play_circle_fill_rounded,
                                    size: compact ? 20 : 23,
                                  ),
                                  label: Text(
                                    playing
                                        ? 'جارٍ تشغيل صوت الحرف...'
                                        : 'استمع إلى صوت الحرف',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: compact ? 13 : 15,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: compact ? 0 : 2),
                              TextButton.icon(
                                style: TextButton.styleFrom(
                                  minimumSize: Size(0, compact ? 30 : 34),
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                ),
                                onPressed: () =>
                                    VoiceService.arabicLetterName(letter.letter),
                                icon: const Icon(Icons.badge_outlined, size: 18),
                                label: const Text('اسم الحرف'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: compact ? 5 : 9),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              minimumSize: Size(0, compact ? 40 : 46),
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                            ),
                            onPressed: index == 0 ? null : _previous,
                            icon: const Icon(Icons.arrow_back_rounded),
                            label: const Text('السابق'),
                          ),
                        ),
                        SizedBox(width: width < 360 ? 6 : 10),
                        Expanded(
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              minimumSize: Size(0, compact ? 40 : 46),
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                            ),
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
