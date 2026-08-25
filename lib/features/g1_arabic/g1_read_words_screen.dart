import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../data/short_words.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';
import '../../widgets/speakable_text.dart';

/// شاشة تعليم القراءة للصف الأول: تعرض الحروف أولاً بشكل أفقي،
/// ثم يجمع الطفل الحروف لتكوين الكلمة.
class G1ReadWordsScreen extends StatefulWidget {
  final List<ShortWord> words;
  final String title;

  const G1ReadWordsScreen({super.key, required this.words, required this.title});

  @override
  State<G1ReadWordsScreen> createState() => _G1ReadWordsScreenState();
}

class _G1ReadWordsScreenState extends State<G1ReadWordsScreen> {
  int index = 0;
  bool split = true;
  String? cheer;

  static const _wordColors = <Color>[
    Color(0xFF7C4DFF),
    Color(0xFF00A896),
    Color(0xFFFF6B35),
    Color(0xFF2979FF),
    Color(0xFFE91E63),
    Color(0xFF00897B),
  ];

  static const _previousColor = Color(0xFF2979FF);
  static const _nextColor = Color(0xFFFF6B35);
  static const _assembleColor = Color(0xFF00A896);

  void _next(int delta) {
    if (widget.words.isEmpty) return;
    VoiceService.stop();
    setState(() {
      index = (index + delta + widget.words.length) % widget.words.length;
      split = true;
      cheer = null;
    });
  }

  void _toggleAssemble() {
    VoiceService.stop();
    final assembling = split;
    setState(() => split = !split);
    if (assembling) {
      VoiceService.arabic(widget.words[index].word);
      _finishedReading();
    }
  }

  void _finishedReading() {
    if (!mounted) return;
    setState(() => cheer = kCheers[index % kCheers.length]);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => cheer = null);
    });
  }

  @override
  void dispose() {
    VoiceService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.words.isEmpty) {
      return const Scaffold(body: Center(child: Text('لا توجد كلمات حاليًا')));
    }

    final w = widget.words[index];
    final color = _wordColors[index % _wordColors.length];
    final width = MediaQuery.sizeOf(context).width;
    final letterSize = (width * 0.14).clamp(38.0, 58.0);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: SpeakableText('${widget.title} • ${index + 1} من ${widget.words.length}'),
        ),
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 620),
                    child: Column(
                      children: [
                        LinearProgressIndicator(value: (index + 1) / widget.words.length),
                        const SizedBox(height: 10),
                        Text(
                          'الكلمة ${index + 1} من ${widget.words.length}',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 12),
                        Text(w.emoji, style: const TextStyle(fontSize: 58)),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: color.withValues(alpha: 0.55), width: 2),
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 180),
                            child: split
                                ? Row(
                                    key: ValueKey('letters-${w.word}'),
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    textDirection: TextDirection.rtl,
                                    children: [
                                      for (int j = 0; j < w.letters.length; j++) ...[
                                        if (j > 0) const SizedBox(width: 8),
                                        Flexible(
                                          child: Button3D(
                                            onTap: () => VoiceService.arabicLetterSound(w.letters[j]),
                                            color: color,
                                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                            child: Text(
                                              w.letters[j],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: letterSize,
                                                height: 1,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  )
                                : FittedBox(
                                    key: ValueKey('word-${w.word}'),
                                    fit: BoxFit.scaleDown,
                                    child: Button3D(
                                      onTap: () => VoiceService.arabic(w.word),
                                      color: color,
                                      padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 16),
                                      child: Text(
                                        w.word,
                                        style: const TextStyle(
                                          fontSize: 54,
                                          height: 1,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: _toggleAssemble,
                            style: FilledButton.styleFrom(
                              backgroundColor: _assembleColor,
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(54),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                            ),
                            icon: Icon(split ? Icons.merge_rounded : Icons.call_split_rounded),
                            label: Text(split ? 'اجمع الكلمة' : 'قسّم الكلمة إلى حروف'),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          split ? 'اضغط كل حرف لسماع صوته، ثم اضغط «اجمع الكلمة».' : 'اضغط الكلمة لسماع نطقها.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 22),
                        Row(
                          children: [
                            Expanded(
                              child: Button3D(
                                onTap: () => _next(-1),
                                color: _previousColor,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.arrow_back_rounded, color: Colors.white),
                                    SizedBox(width: 6),
                                    Text('السابق', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Colors.white)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Button3D(
                                onTap: () => _next(1),
                                color: _nextColor,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('التالي', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Colors.white)),
                                    SizedBox(width: 6),
                                    Icon(Icons.arrow_forward_rounded, color: Colors.white),
                                  ],
                                ),
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
            CelebrationOverlay(message: cheer),
          ],
        ),
      ),
    );
  }
}
