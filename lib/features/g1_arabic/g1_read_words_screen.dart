import 'package:flutter/material.dart';
import '../../core/audio/voice_service.dart';
import '../../data/short_words.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

/// شاشة تعليم القراءة: تعرض الكلمة مجتمعة، ثم مقسّمة حرفًا حرفًا، ليتدرّب
/// الطفل على الهجاء ودمج الحروف لتكوين الكلمة.
class G1ReadWordsScreen extends StatefulWidget {
  final List<ShortWord> words;
  final String title;
  const G1ReadWordsScreen({super.key, required this.words, required this.title});

  @override
  State<G1ReadWordsScreen> createState() => _G1ReadWordsScreenState();
}

class _G1ReadWordsScreenState extends State<G1ReadWordsScreen> {
  int index = 0;
  bool split = false;
  String? cheer;

  static const colors = [Color(0xFF7C4DFF), Color(0xFF00BFA6), Color(0xFFFF6B35), Color(0xFF2979FF), Color(0xFFFF1E7E)];

  void _next(int delta) {
    setState(() {
      index = (index + delta + widget.words.length) % widget.words.length;
      split = false;
    });
  }

  void _finishedReading() {
    setState(() => cheer = kCheers[index % kCheers.length]);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => cheer = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.words[index];
    final color = colors[index % colors.length];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('${widget.title} • ${index + 1} من ${widget.words.length}')),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              LinearProgressIndicator(value: (index + 1) / widget.words.length),
              const SizedBox(height: 20),
              Text(w.emoji, style: const TextStyle(fontSize: 64)),
              const SizedBox(height: 14),
              if (!split)
                Button3D(
                  onTap: () {
                    VoiceService.arabic(w.word);
                    _finishedReading();
                  },
                  color: color,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 22),
                  child: Text(w.word, style: const TextStyle(fontSize: 54, fontWeight: FontWeight.w900, color: Colors.white)),
                )
              else
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  children: w.letters.map((l) {
                    return Button3D(
                      onTap: () => VoiceService.arabic(l),
                      color: color,
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                      child: Text(l, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white)),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 22),
              OutlinedButton.icon(
                onPressed: () => setState(() => split = !split),
                icon: Icon(split ? Icons.merge_rounded : Icons.call_split_rounded),
                label: Text(split ? 'اجمع الحروف كلمة واحدة' : 'قسّم الكلمة إلى حروف'),
              ),
              const SizedBox(height: 8),
              Text('اضغط الكلمة أو الحروف لتسمعها', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const Spacer(),
              Row(children: [
                Expanded(child: OutlinedButton(onPressed: () => _next(-1), child: const Text('السابقة'))),
                const SizedBox(width: 10),
                Expanded(child: FilledButton(onPressed: () => _next(1), child: const Text('التالية'))),
              ]),
            ]),
          ),
          CelebrationOverlay(message: cheer),
        ]),
      ),
    );
  }
}
