import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../widgets/bold_drawing_canvas.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

class Kg2NumberWritingScreen extends StatefulWidget {
  const Kg2NumberWritingScreen({super.key});
  @override
  State<Kg2NumberWritingScreen> createState() => _Kg2NumberWritingScreenState();
}

class _Kg2NumberWritingScreenState extends State<Kg2NumberWritingScreen> {
  final rnd = Random();
  final canvasKey = GlobalKey<BoldDrawingCanvasState>();
  String? cheer;
  final history = <int>[3];
  int historyIndex = 0;
  bool askTens = true;
  bool answered = false;

  int get number => history[historyIndex];

  static String _word(int n) => const {
        1: 'واحد', 2: 'اثنان', 3: 'ثلاثة', 4: 'أربعة', 5: 'خمسة',
        6: 'ستة', 7: 'سبعة', 8: 'ثمانية', 9: 'تسعة',
      }[n] ?? '$n';

  void _celebrate() {
    setState(() => cheer = kCheers[rnd.nextInt(kCheers.length)]);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => cheer = null);
    });
  }

  void _speak() {
    if (number < 10) {
      VoiceService.arabic(_word(number));
    } else {
      VoiceService.arabic(arNum(number));
    }
  }

  void _next() {
    canvasKey.currentState?.clear();
    final nextNumber = 1 + rnd.nextInt(50);
    setState(() {
      if (historyIndex < history.length - 1) {
        history.removeRange(historyIndex + 1, history.length);
      }
      history.add(nextNumber);
      historyIndex++;
      askTens = rnd.nextBool();
      answered = false;
    });
    _celebrate();
  }

  void _previous() {
    if (historyIndex == 0) return;
    canvasKey.currentState?.clear();
    setState(() {
      historyIndex--;
      askTens = rnd.nextBool();
      answered = false;
    });
  }

  void _answerPlaceValue(bool tappedTens) {
    if (answered) return;
    final correct = tappedTens == askTens;
    if (correct) {
      setState(() => answered = true);
      _celebrate();
    } else {
      setState(() => cheer = 'حاول مرة أخرى 💪');
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) setState(() => cheer = null);
      });
    }
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
    final isTwoDigit = number >= 10;
    final tensDigit = number ~/ 10;
    final onesDigit = number % 10;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('كتابة الأرقام'),
          actions: [
            IconButton(onPressed: _speak, tooltip: 'استمع', icon: const Icon(Icons.volume_up_rounded)),
            IconButton(onPressed: () => canvasKey.currentState?.clear(), tooltip: 'مسح', icon: const Icon(Icons.delete_outline_rounded)),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 6),
                const Text('اكتب العدد', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(arNum(number), style: const TextStyle(fontSize: 66, fontWeight: FontWeight.w900)),
                if (isTwoDigit) ...[
                  const SizedBox(height: 6),
                  Text('اضغط على رقم ${askTens ? 'العشرات' : 'الآحاد'} في العدد 👇', style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Button3D(
                        onTap: () => _answerPlaceValue(true),
                        color: answered ? const Color(0xFF00C853) : const Color(0xFF2979FF),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        child: Text(arNum(tensDigit), style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white)),
                      ),
                      const SizedBox(width: 14),
                      Button3D(
                        onTap: () => _answerPlaceValue(false),
                        color: answered ? const Color(0xFF00C853) : const Color(0xFFFF6B35),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        child: Text(arNum(onesDigit), style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white)),
                      ),
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
                        onPressed: historyIndex > 0 ? _previous : null,
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
