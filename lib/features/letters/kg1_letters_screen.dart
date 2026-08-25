import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../data/content.dart';
import '../../widgets/speakable_text.dart';

/// حروف الروضة الأولى.
///
/// هذه الشاشة مستقلة عن شاشة حروف الصف الأول والروضة الثانية.
/// تعرض الحرف بشكله الأساسي فقط: أ، ب، ت... دون أولي/وسطي/أخري.
class Kg1LettersScreen extends StatefulWidget {
  const Kg1LettersScreen({super.key});

  @override
  State<Kg1LettersScreen> createState() => _Kg1LettersScreenState();
}

class _Kg1LettersScreenState extends State<Kg1LettersScreen> {
  int index = 0;

  static ButtonStyle _navigationButtonStyle(BuildContext context) =>
      FilledButton.styleFrom(
        minimumSize: const Size(0, 50),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
      );

  void _previous() {
    if (index <= 0) return;
    VoiceService.stop();
    setState(() => index -= 1);
  }

  void _next() {
    if (index >= arabicLetters.length - 1) return;
    VoiceService.stop();
    setState(() => index += 1);
  }

  @override
  void dispose() {
    VoiceService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final letter = arabicLetters[index];
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width < 360 ? 10.0 : 14.0;
    final letterSize = (width * 0.24).clamp(64.0, 104.0);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const SpeakableText('الحروف العربية')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              10,
              horizontalPadding,
              16,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: (index + 1) / arabicLetters.length,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'الحرف ${index + 1} من ${arabicLetters.length}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      margin: EdgeInsets.zero,
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width < 360 ? 10 : 14,
                          vertical: 12,
                        ),
                        child: Column(
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 180),
                              child: Text(
                                letter.letter,
                                key: ValueKey(letter.letter),
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: letterSize,
                                  height: 1.0,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'صوت الحرف: ${letter.sound}',
                              style: const TextStyle(fontSize: 19),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'اسم الحرف: ${_letterName(letter.letter)}',
                              style: const TextStyle(fontSize: 17),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 3),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${letter.emoji}  ${letter.word}',
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                onPressed: () => VoiceService.arabicLetterSound(
                                  letter.letter,
                                  fallbackText: letter.sound,
                                ),
                                icon: const Icon(Icons.volume_up),
                                label: const Text('استمع إلى صوت الحرف'),
                              ),
                            ),
                            const SizedBox(height: 7),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () =>
                                        VoiceService.arabic(letter.word),
                                    icon: const Icon(
                                      Icons.record_voice_over,
                                    ),
                                    label: const Text('الكلمة'),
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size(0, 48),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => VoiceService
                                        .arabicLetterName(letter.letter),
                                    icon: const Icon(Icons.badge),
                                    label: const Text('اسم الحرف'),
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size(0, 48),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            style: _navigationButtonStyle(context),
                            onPressed: index == 0 ? null : _previous,
                            icon: const Icon(Icons.arrow_back_rounded),
                            label: const Text('السابق'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton.icon(
                            style: _navigationButtonStyle(context),
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _letterName(String x) =>
      const {
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
      }[x] ?? x;
}
