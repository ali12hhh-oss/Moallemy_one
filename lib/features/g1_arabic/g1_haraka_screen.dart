import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../data/content.dart';
import '../../data/harakat.dart';
import '../../widgets/bold_drawing_canvas.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

/// شاشة حركة واحدة: كل الحروف بهذه الحركة (تُنطق حرفًا حرفًا)، ثم كلمات
/// ممدودة تقليدية (فتحة+ا، ضمة+و، كسرة+ي) يمكن سماعها وكتابتها.
class G1HarakaScreen extends StatefulWidget {
  final Haraka haraka;
  const G1HarakaScreen({super.key, required this.haraka});

  @override
  State<G1HarakaScreen> createState() => _G1HarakaScreenState();
}

class _G1HarakaScreenState extends State<G1HarakaScreen> {
  bool writingMode = false;
  int wordIndex = 0;
  final canvasKey = GlobalKey<BoldDrawingCanvasState>();
  String? cheer;

  void _celebrate() {
    setState(() => cheer = kCheers[wordIndex % kCheers.length]);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => cheer = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = widget.haraka;
    final word = longVowelWord(harakaSampleLetters[wordIndex], h);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(h.name)),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Button3D(
                          onTap: () => setState(() => writingMode = false),
                          color:
                              !writingMode
                                  ? const Color(0xFF7C4DFF)
                                  : const Color(0xFFB39DDB),
                          depth: !writingMode ? 2 : 7,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: const Center(
                            child: Text(
                              'الحروف والكلمات',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Button3D(
                          onTap: () => setState(() => writingMode = true),
                          color:
                              writingMode
                                  ? const Color(0xFF00BFA6)
                                  : const Color(0xFFB2DFDB),
                          depth: writingMode ? 2 : 7,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: const Center(
                            child: Text(
                              'الكتابة',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (!writingMode)
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Text(
                          'كل الحروف مع ${h.name}',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                          itemCount: arabicLetters.length,
                          itemBuilder: (_, i) {
                            final marked = letterWithHaraka(
                              arabicLetters[i].letter,
                              h,
                            );
                            return Card(
                              child: InkWell(
                                onTap: () => VoiceService.arabic(marked),
                                child: Center(
                                  child: Text(
                                    marked,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 22),
                        Text(
                          'كلمات ممدودة بـ${h.name}',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children:
                              harakaSampleLetters.map((l) {
                                final w = longVowelWord(l, h);
                                return Button3D(
                                  onTap: () {
                                    VoiceService.arabic(w);
                                    _celebrate();
                                  },
                                  color: const Color(0xFFFF6B35),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 16,
                                  ),
                                  child: Text(
                                    w,
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                  )
                else ...[
                  const SizedBox(height: 4),
                  const Text(
                    'اكتب الكلمة',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    word,
                    style: const TextStyle(
                      fontSize: 54,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Expanded(child: BoldDrawingCanvas(key: canvasKey)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => VoiceService.arabic(word),
                            icon: const Icon(Icons.volume_up_rounded),
                            label: const Text('استمع'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              canvasKey.currentState?.clear();
                              setState(
                                () =>
                                    wordIndex =
                                        (wordIndex + 1) %
                                        harakaSampleLetters.length,
                              );
                              _celebrate();
                            },
                            child: const Text('التالي'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            CelebrationOverlay(message: cheer),
          ],
        ),
      ),
    );
  }
}
