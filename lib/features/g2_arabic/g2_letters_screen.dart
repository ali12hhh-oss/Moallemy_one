import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

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
  final AudioPlayer _g2LetterPlayer = AudioPlayer();

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
    // Yaa: initial يـ, medial ـيـ, final ـي.
    'ي': ['يـ', 'ـيـ', 'ـي'],
  };

  ArabicLetter get current => arabicLetters[index];
  String get displayedForm => forms[current.letter]![form];

  Future<void> _playLetter() async {
    if (playing) return;
    setState(() => playing = true);

    try {
      // G2 uses the real local phoneme files shipped with the app:
      // assets/audio/ar/<audio-name>.wav. This is intentionally local to G2
      // so the working G1 audio service is not changed.
      await VoiceService.stop();
      await _g2LetterPlayer.stop();
      await _g2LetterPlayer.setReleaseMode(ReleaseMode.stop);

      final audioName = current.audio.trim();
      if (audioName.isNotEmpty) {
        try {
          await _g2LetterPlayer.play(
            AssetSource('audio/ar/$audioName.wav', mimeType: 'audio/wav'),
            volume: 1.0,
          );
          return;
        } catch (_) {
          // Use the existing G2 phonetic fallback below if the local file
          // cannot be opened on this device/build.
        }
      }

      // Fallback is the phonetic sound (e.g. بَ), never the letter name.
      await VoiceService.arabic(current.sound);
    } finally {
      if (mounted) setState(() => playing = false);
    }
  }

  void _previous() {
    if (index == 0) return;
    VoiceService.stop();
    _g2LetterPlayer.stop();
    setState(() {
      index--;
      form = 0;
    });
  }

  void _next() {
    if (index >= arabicLetters.length - 1) return;
    VoiceService.stop();
    _g2LetterPlayer.stop();
    setState(() {
      index++;
      form = 0;
    });
  }

  @override
  void dispose() {
    VoiceService.stop();
    _g2LetterPlayer.dispose();
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
              final compact = height < 650;
              final tiny = height < 570;
              final horizontal = width < 360 ? 8.0 : 12.0;
              final titleSize = tiny ? 12.0 : compact ? 13.0 : 15.0;
              final letterSize = tiny ? 64.0 : compact ? 78.0 : 100.0;

              return Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontal,
                  tiny ? 4 : 8,
                  horizontal,
                  tiny ? 4 : 8,
                ),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: (index + 1) / arabicLetters.length,
                      minHeight: 5,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    SizedBox(height: tiny ? 2 : 5),
                    Text(
                      'الحرف ${index + 1} من ${arabicLetters.length}',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: titleSize,
                      ),
                    ),
                    SizedBox(height: tiny ? 3 : 6),
                    Expanded(
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: EdgeInsets.all(tiny ? 6 : compact ? 8 : 10),
                          child: Column(
                            children: [
                              Expanded(
                                child: Center(
                                  child: FittedBox(
                                    fit: BoxFit.contain,
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
                                  fontSize: tiny ? 13 : compact ? 15 : 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                'اسم الحرف: ${_name(letter.letter)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: tiny ? 11 : 13),
                              ),
                              SizedBox(height: tiny ? 1 : 3),
                              Text(
                                '${letter.emoji}  ${letter.word}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: tiny ? 15 : compact ? 17 : 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(height: tiny ? 3 : 6),
                              Row(
                                children: List.generate(formNames.length, (i) {
                                  final selected = form == i;
                                  return Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: i == 0 ? 0 : 3),
                                      child: FilledButton(
                                        style: FilledButton.styleFrom(
                                          minimumSize: Size(0, tiny ? 32 : compact ? 36 : 40),
                                          padding: const EdgeInsets.symmetric(horizontal: 1),
                                          backgroundColor: selected
                                              ? StageColors.of('kg2')
                                              : Colors.grey.shade600,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(9),
                                          ),
                                        ),
                                        onPressed: () => setState(() => form = i),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(formNames[i]),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              SizedBox(height: tiny ? 3 : 5),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  style: FilledButton.styleFrom(
                                    minimumSize: Size(0, tiny ? 38 : compact ? 42 : 46),
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    backgroundColor: const Color(0xFFFFA000),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                  ),
                                  onPressed: playing ? null : _playLetter,
                                  icon: Icon(
                                    playing
                                        ? Icons.volume_up_rounded
                                        : Icons.play_circle_fill_rounded,
                                    size: tiny ? 18 : 22,
                                  ),
                                  label: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      playing
                                          ? 'جارٍ تشغيل صوت الحرف...'
                                          : 'استمع إلى صوت الحرف',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: tiny ? 12 : 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: tiny ? 0 : 1),
                              SizedBox(
                                height: tiny ? 28 : 32,
                                child: TextButton.icon(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                  ),
                                  onPressed: () =>
                                      VoiceService.arabicLetterName(letter.letter),
                                  icon: const Icon(Icons.badge_outlined, size: 17),
                                  label: const Text('اسم الحرف'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: tiny ? 4 : 7),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              minimumSize: Size(0, tiny ? 38 : compact ? 42 : 46),
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                            ),
                            onPressed: index == 0 ? null : _previous,
                            icon: const Icon(Icons.arrow_back_rounded),
                            label: const Text('السابق'),
                          ),
                        ),
                        SizedBox(width: width < 360 ? 6 : 9),
                        Expanded(
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              minimumSize: Size(0, tiny ? 38 : compact ? 42 : 46),
                              padding: const EdgeInsets.symmetric(horizontal: 4),
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
