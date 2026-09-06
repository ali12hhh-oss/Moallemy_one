import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../widgets/bold_drawing_canvas.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

/// كتابة أرقام الروضة الثانية.
/// الأرقام تسير بالتسلسل، والآحاد دائمًا في يمين العدد والعشرات في يساره.
class Kg2NumberWritingScreen extends StatefulWidget {
  const Kg2NumberWritingScreen({super.key});
  @override
  State<Kg2NumberWritingScreen> createState() => _Kg2NumberWritingScreenState();
}

class _Kg2NumberWritingScreenState extends State<Kg2NumberWritingScreen> {
  final rnd = Random();
  final canvasKey = GlobalKey<BoldDrawingCanvasState>();
  String? cheer;
  static const int firstNumber = 1;
  static const int firstQuestionNumber = 10;
  static const int lastNumber = 50;
  int number = firstNumber;
  bool askTens = true;
  bool answered = false;

  int get tensDigit => number ~/ 10;
  int get onesDigit => number % 10;
  bool get hasPlaceValueQuestion => number >= firstQuestionNumber;

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

  void _speakQuestion() {
    if (!hasPlaceValueQuestion) return;
    final question = askTens
        ? 'أين العشرات في العدد ${arNum(number)}؟'
        : 'أين الآحاد في العدد ${arNum(number)}؟';
    VoiceService.arabic(question);
  }

  void _setNumber(int next) {
    if (next < firstNumber || next > lastNumber) return;
    canvasKey.currentState?.clear();
    setState(() {
      number = next;
      askTens = next >= firstQuestionNumber ? rnd.nextBool() : false;
      answered = false;
    });
  }

  void _next() => _setNumber(number + 1);
  void _previous() => _setNumber(number - 1);

  void _answerPlaceValue(bool tappedTens) {
    if (!hasPlaceValueQuestion || answered) return;
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

  ButtonStyle _controlStyle({required Color background}) =>
      FilledButton.styleFrom(
        minimumSize: const Size(0, 46),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        backgroundColor: background,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
      );

  Widget _placeValueButton({required bool tens}) {
    final selectedCorrect = answered;
    return Expanded(
      child: Button3D(
        onTap: () => _answerPlaceValue(tens),
        color: selectedCorrect
            ? const Color(0xFF00C853)
            : (tens ? const Color(0xFF2979FF) : const Color(0xFFFF6B35)),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          textDirection: TextDirection.rtl,
          children: [
            Text(
              arNum(tens ? tensDigit : onesDigit),
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 7),
            Text(
              tens ? 'العشرات' : 'الآحاد',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    VoiceService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('كتابة الأرقام'),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 1),
                const Text(
                  'اكتب العدد بالترتيب',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                // العدد والسماعة في منتصف الشاشة، من دون إزاحة إلى اليمين أو اليسار.
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  textDirection: TextDirection.rtl,
                  children: [
                    Text(
                      arNum(number),
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      onPressed: _speak,
                      tooltip: 'استمع إلى العدد',
                      icon: const Icon(Icons.volume_up_rounded, size: 32),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                    ),
                  ],
                ),
                if (hasPlaceValueQuestion) ...[
                  // السؤال والعدد في سطر واحد حتى يبقى الرقم قريبًا من نص السؤال.
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      textDirection: TextDirection.rtl,
                      children: [
                        Flexible(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: askTens ? 'أين العشرات في العدد ' : 'أين الآحاد في العدد ',
                                ),
                                TextSpan(
                                  text: arNum(number),
                                  style: const TextStyle(fontSize: 21),
                                ),
                                const TextSpan(text: '؟'),
                              ],
                            ),
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 2),
                        IconButton(
                          onPressed: _speakQuestion,
                          tooltip: 'استمع إلى السؤال',
                          icon: const Icon(Icons.volume_up_rounded, size: 25),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  // خيارا الآحاد والعشرات متساويان في العرض ومتمركزان تمامًا.
                  SizedBox(
                    width: 300,
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        _placeValueButton(tens: false),
                        const SizedBox(width: 6),
                        _placeValueButton(tens: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                ],
                // كل المساحة المتبقية للسبورة؛ لا توجد مساحة جانبية أو عمودية محجوزة بلا داعٍ.
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                    child: SizedBox.expand(
                      child: BoldDrawingCanvas(key: canvasKey),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 2, 8, 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          style: _controlStyle(
                            background: const Color(0xFF00897B),
                          ),
                          onPressed: number > firstNumber ? _previous : null,
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: const Text('السابق'),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: FilledButton.icon(
                          style: _controlStyle(
                            background: const Color(0xFFE53935),
                          ),
                          onPressed: () => canvasKey.currentState?.clear(),
                          icon: const Icon(Icons.delete_sweep_rounded),
                          label: const Text('مسح السبورة'),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: FilledButton.icon(
                          style: _controlStyle(
                            background: const Color(0xFF00897B),
                          ),
                          onPressed: number < lastNumber ? _next : null,
                          icon: const Icon(Icons.arrow_back_rounded),
                          label: const Text('التالي'),
                        ),
                      ),
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
