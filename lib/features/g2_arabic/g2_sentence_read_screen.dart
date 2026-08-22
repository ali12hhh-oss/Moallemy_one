import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../data/short_words.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

class G2SentenceReadScreen extends StatefulWidget {
  final List<ShortSentence> sentences;
  final String title;
  const G2SentenceReadScreen({
    super.key,
    this.sentences = twoPartSentences,
    this.title = 'جمل قصيرة',
  });
  @override
  State<G2SentenceReadScreen> createState() => _G2SentenceReadScreenState();
}

class _G2SentenceReadScreenState extends State<G2SentenceReadScreen> {
  int index = 0;
  bool split = false;
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
      index =
          (index + delta + widget.sentences.length) % widget.sentences.length;
      split = false;
    });
  }

  void _celebrate() {
    setState(() => cheer = kCheers[index % kCheers.length]);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => cheer = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.sentences[index];
    final color = colors[index % colors.length];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${widget.title} • ${index + 1} من ${widget.sentences.length}',
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: (index + 1) / widget.sentences.length,
                  ),
                  const SizedBox(height: 20),
                  Text(s.emoji, style: const TextStyle(fontSize: 60)),
                  const SizedBox(height: 14),
                  if (!split)
                    Button3D(
                      onTap: () {
                        VoiceService.arabic(s.sentence);
                        _celebrate();
                      },
                      color: color,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 22,
                      ),
                      child: Text(
                        s.sentence,
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    )
                  else
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      children: s.parts.map((p) {
                        return Button3D(
                          onTap: () => VoiceService.arabic(p),
                          color: color,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 18,
                          ),
                          child: Text(
                            p,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 22),
                  OutlinedButton.icon(
                    onPressed: () => setState(() => split = !split),
                    icon: Icon(
                      split ? Icons.merge_rounded : Icons.call_split_rounded,
                    ),
                    label: Text(
                      split ? 'اجمع الجملة كاملة' : 'قسّم الجملة إلى كلمات',
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _next(-1),
                          child: const Text('السابقة'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => _next(1),
                          child: const Text('التالية'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CelebrationOverlay(message: cheer),
          ],
        ),
      ),
    );
  }
}
