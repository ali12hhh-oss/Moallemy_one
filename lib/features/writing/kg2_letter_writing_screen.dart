import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/localization/letter_forms.dart';
import '../../data/content.dart';
import '../../widgets/bold_drawing_canvas.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

const _pairs = <(String, String)>[
  ('د', 'ا'), ('ن', 'ا'), ('د', 'و'), ('د', 'ي'), ('ب', 'ا'),
  ('ب', 'و'), ('ت', 'ا'), ('س', 'ا'), ('م', 'ا'), ('ر', 'ا'),
  ('ل', 'ا'), ('ك', 'ا'), ('ف', 'ي'), ('ه', 'ي'), ('ن', 'ي'),
  ('م', 'ن'), ('ل', 'ك'), ('ب', 'ه'), ('ي', 'د'), ('و', 'ل'),
];

class Kg2LetterWritingScreen extends StatefulWidget {
  const Kg2LetterWritingScreen({super.key});
  @override
  State<Kg2LetterWritingScreen> createState() => _Kg2LetterWritingScreenState();
}

class _Kg2LetterWritingScreenState extends State<Kg2LetterWritingScreen> {
  bool singleMode = true;
  final rnd = Random();
  final canvasKey = GlobalKey<BoldDrawingCanvasState>();
  String? cheer;

  int letterIndex = 0;
  int formIndex = 0;
  int pairIndex = 0;

  void _switch(bool single) {
    setState(() {
      singleMode = single;
      canvasKey.currentState?.clear();
    });
  }

  void _speak() {
    if (singleMode) {
      final l = arabicLetters[letterIndex];
      VoiceService.arabicLetterSound(l.letter, fallbackText: l.sound);
    } else {
      final p = _pairs[pairIndex];
      VoiceService.arabic('${p.$1} مع ${p.$2} تصبح ${p.$1}${p.$2}');
    }
  }

  void _celebrate() {
    setState(() => cheer = kCheers[rnd.nextInt(kCheers.length)]);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => cheer = null);
    });
  }

  void _next() {
    canvasKey.currentState?.clear();
    setState(() {
      if (singleMode) {
        formIndex = (formIndex + 1) % 3;
        if (formIndex == 0) {
          letterIndex = (letterIndex + 1) % arabicLetters.length;
        }
      } else {
        pairIndex = (pairIndex + 1) % _pairs.length;
      }
    });
    _celebrate();
  }

  void _previous() {
    canvasKey.currentState?.clear();
    setState(() {
      if (singleMode) {
        if (formIndex == 0) {
          letterIndex = (letterIndex - 1 + arabicLetters.length) % arabicLetters.length;
          formIndex = 2;
        } else {
          formIndex--;
        }
      } else {
        pairIndex = (pairIndex - 1 + _pairs.length) % _pairs.length;
      }
    });
  }

  ButtonStyle _controlStyle({required Color background}) => FilledButton.styleFrom(
        minimumSize: const Size(0, 54),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
        backgroundColor: background,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
      );

  @override
  Widget build(BuildContext context) {
    final letter = arabicLetters[letterIndex];
    final forms = LetterForms.of(letter.letter);
    final formLabel = forms.all[formIndex];
    final pair = _pairs[pairIndex];
    final combined = '${pair.$1}${pair.$2}';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('كتابة الحروف'),
          actions: [
            IconButton(onPressed: _speak, tooltip: 'استمع', icon: const Icon(Icons.volume_up_rounded)),
            IconButton(onPressed: () => canvasKey.currentState?.clear(), tooltip: 'مسح', icon: const Icon(Icons.delete_outline_rounded)),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
                  child: Row(
                    children: [
                      Expanded(child: Button3D(
                        onTap: () => _switch(true),
                        color: singleMode ? const Color(0xFF7C4DFF) : const Color(0xFFB39DDB),
                        depth: singleMode ? 2 : 7,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: const Center(child: Text('حروف منفردة', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white))),
                      )),
                      const SizedBox(width: 10),
                      Expanded(child: Button3D(
                        onTap: () => _switch(false),
                        color: !singleMode ? const Color(0xFFFF1E7E) : const Color(0xFFF48FB1),
                        depth: !singleMode ? 2 : 7,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: const Center(child: Text('دمج حرفين', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white))),
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                if (singleMode) ...[
                  Text('اكتب الحرف (${formLabel.$1})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(formLabel.$2, style: const TextStyle(fontSize: 66, fontWeight: FontWeight.w900)),
                ] else ...[
                  const Text('ادمج الحرفين معًا', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(pair.$1, style: const TextStyle(fontSize: 46, fontWeight: FontWeight.w900)),
                      const Text(' + ', style: TextStyle(fontSize: 30)),
                      Text(pair.$2, style: const TextStyle(fontSize: 46, fontWeight: FontWeight.w900)),
                      const Text(' = ', style: TextStyle(fontSize: 30)),
                      Text(combined, style: const TextStyle(fontSize: 46, fontWeight: FontWeight.w900, color: Color(0xFFFF1E7E))),
                    ],
                  ),
                ],
                const SizedBox(height: 6),
                Expanded(child: BoldDrawingCanvas(key: canvasKey)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
                  child: Row(
                    children: [
                      Expanded(child: FilledButton.icon(
                        style: _controlStyle(background: const Color(0xFF00897B)),
                        onPressed: _previous,
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: const Text('السابق'),
                      )),
                      const SizedBox(width: 7),
                      Expanded(child: FilledButton.icon(
                        style: _controlStyle(background: const Color(0xFFE53935)),
                        onPressed: () => canvasKey.currentState?.clear(),
                        icon: const Icon(Icons.delete_sweep_rounded),
                        label: const Text('مسح السبورة'),
                      )),
                      const SizedBox(width: 7),
                      Expanded(child: FilledButton.icon(
                        style: _controlStyle(background: const Color(0xFF00897B)),
                        onPressed: _next,
                        icon: const Icon(Icons.arrow_back_rounded),
                        label: const Text('التالي'),
                      )),
                    ],
                  ),
                ),
              ],
            ),
            CelebrationOverlay(message: cheer),
          ],
        ),
      ),
    );
  }
}
