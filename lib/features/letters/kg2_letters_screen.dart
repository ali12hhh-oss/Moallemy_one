import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/localization/letter_forms.dart';
import '../../data/content.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

/// حروف الروضة الثانية.
///
/// الهدف هنا بصري وصوتي: يرى الطفل الحرف بشكله الحقيقي في أول الكلمة
/// ووسطها وآخرها، ويمكنه الضغط على أي شكل لعرضه بحجم كبير. زر الصوت يشغل
/// التسجيل الحقيقي للحرف نفسه، وليس اسم الحرف.
class Kg2LettersScreen extends StatefulWidget {
  const Kg2LettersScreen({super.key});

  @override
  State<Kg2LettersScreen> createState() => _Kg2LettersScreenState();
}

class _Kg2LettersScreenState extends State<Kg2LettersScreen> {
  int index = 0;
  int selectedForm = 0;
  String? cheer;

  static const colors = [
    Color(0xFF7C4DFF),
    Color(0xFF00BFA6),
    Color(0xFFFF6B35),
    Color(0xFF2979FF),
    Color(0xFFFF1E7E),
  ];

  void _next(int delta) {
    setState(() {
      index = (index + delta + arabicLetters.length) % arabicLetters.length;
      selectedForm = 0;
    });
  }

  Future<void> _onFormTap(int formIndex) async {
    setState(() {
      selectedForm = formIndex;
      cheer = kCheers[index % kCheers.length];
    });

    // IMPORTANT: pass the base letter, never the positional glyph. The
    // audio asset is a real recorded phoneme for the letter, not its name.
    await VoiceService.arabicLetterSound(arabicLetters[index].letter);

    if (!mounted) return;
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => cheer = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final letter = arabicLetters[index];
    final forms = LetterForms.of(letter.letter);
    final allForms = forms.all;
    final color = colors[index % colors.length];
    final selected = allForms[selectedForm];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('الحروف • ${index + 1} من ${arabicLetters.length}'),
        ),
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: (index + 1) / arabicLetters.length,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'حرف ${letter.letter}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                vertical: 18,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: .12),
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                  color: color.withValues(alpha: .35),
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    selected.$2,
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontSize: 104,
                                      height: 1,
                                      fontWeight: FontWeight.w900,
                                      color: color,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    selected.$1,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'اضغط على 🔊 لسماع صوت الحرف',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  FilledButton.icon(
                                    onPressed: () =>
                                        VoiceService.arabicLetterSound(
                                          letter.letter,
                                        ),
                                    icon: const Icon(Icons.volume_up_rounded),
                                    label: const Text('صوت الحرف'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: List.generate(allForms.length, (i) {
                                final form = allForms[i];
                                final isSelected = selectedForm == i;
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    child: Button3D(
                                      onTap: () => _onFormTap(i),
                                      color: isSelected
                                          ? color
                                          : color.withValues(alpha: .65),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            form.$2,
                                            style: const TextStyle(
                                              fontSize: 42,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            form.$1,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              '${letter.emoji} ${letter.word}',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => VoiceService.arabic(letter.word),
                              icon: const Icon(Icons.record_voice_over),
                              label: const Text('استمع إلى الكلمة'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _next(-1),
                            child: const Text('السابق'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            onPressed: () => _next(1),
                            child: const Text('التالي'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            CelebrationOverlay(message: cheer),
          ],
        ),
      ),
    );
  }
}
