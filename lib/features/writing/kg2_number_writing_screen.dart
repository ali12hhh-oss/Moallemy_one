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
  int number = 3;
  bool askTens =
      true; // للأعداد المكوّنة من رقمين: هل نسأل عن العشرات أم الآحاد؟
  bool answered = false;

  static String _word(int n) =>
      const {
        1: 'واحد',
        2: 'اثنان',
        3: 'ثلاثة',
        4: 'أربعة',
        5: 'خمسة',
        6: 'ستة',
        7: 'سبعة',
        8: 'ثمانية',
        9: 'تسعة',
      }[n] ??
      '$n';

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
    setState(() {
      number = 1 + rnd.nextInt(50);
      askTens = rnd.nextBool();
      answered = false;
    });
    _celebrate();
  }

  void _answerPlaceValue(bool tappedTens) {
    if (answered) return;
    final correct = tappedTens == askTens;
    if (correct) {
      setState(() => answered = true);
      _celebrate();
    } else {
      // إجابة خاطئة: نعيد المحاولة ولا ننتقل.
      setState(() => cheer = 'حاول مرة أخرى 💪');
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) setState(() => cheer = null);
      });
    }
  }

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
            IconButton(
              onPressed: _speak,
              tooltip: 'استمع',
              icon: const Icon(Icons.volume_up_rounded),
            ),
            IconButton(
              onPressed: () => canvasKey.currentState?.clear(),
              tooltip: 'مسح',
              icon: const Icon(Icons.delete_outline_rounded),
            ),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 6),
                const Text(
                  'اكتب العدد',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  arNum(number),
                  style: const TextStyle(
                    fontSize: 66,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (isTwoDigit) ...[
                  const SizedBox(height: 6),
                  Text(
                    'اضغط على رقم ${askTens ? 'العشرات' : 'الآحاد'} في العدد 👇',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Button3D(
                        onTap: () => _answerPlaceValue(true),
                        color:
                            answered
                                ? const Color(0xFF00C853)
                                : const Color(0xFF2979FF),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        child: Text(
                          arNum(tensDigit),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Button3D(
                        onTap: () => _answerPlaceValue(false),
                        color:
                            answered
                                ? const Color(0xFF00C853)
                                : const Color(0xFFFF6B35),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        child: Text(
                          arNum(onesDigit),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 6),
                Expanded(child: BoldDrawingCanvas(key: canvasKey)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                  child: FilledButton.icon(
                    onPressed: _next,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text('التالي'),
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
