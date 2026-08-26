import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../data/content.dart';
import '../../data/harakat.dart';
import '../../widgets/bold_drawing_canvas.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

class G1HarakaScreen extends StatefulWidget {
  final Haraka haraka;
  const G1HarakaScreen({super.key, required this.haraka});
  @override
  State<G1HarakaScreen> createState() => _G1HarakaScreenState();
}

class _G1HarakaScreenState extends State<G1HarakaScreen> {
  bool writingMode = false;
  int letterIndex = 0;
  final canvasKey = GlobalKey<BoldDrawingCanvasState>();
  String? cheer;

  static const _previousColor = Color(0xFF2979FF);
  static const _nextColor = Color(0xFFFF6B35);
  static const _writingColor = Color(0xFF00A896);

  void _stop() => VoiceService.stop();

  String get _markedLetter =>
      letterWithHaraka(arabicLetters[letterIndex].letter, widget.haraka);

  void _move(int delta) {
    _stop();
    setState(() {
      letterIndex =
          (letterIndex + delta + arabicLetters.length) % arabicLetters.length;
      cheer = null;
    });
    canvasKey.currentState?.clear();
  }

  void _selectLetter(int index) {
    _stop();
    setState(() {
      letterIndex = index;
      cheer = null;
    });
    canvasKey.currentState?.clear();
  }

  void _speakMarkedLetter() => VoiceService.arabic(_markedLetter);

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = widget.haraka;
    final width = MediaQuery.sizeOf(context).width;
    final markedSize = (width * .17).clamp(56.0, 88.0);
    final pickerLetterSize = (width * .105).clamp(34.0, 58.0);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(h.name)),
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Button3D(
                            onTap: () {
                              _stop();
                              setState(() => writingMode = false);
                            },
                            color: !writingMode
                                ? const Color(0xFF7C4DFF)
                                : const Color(0xFFB39DDB),
                            depth: !writingMode ? 2 : 7,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: const Center(
                              child: Text(
                                'الحروف والحركات',
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
                            onTap: () {
                              _stop();
                              setState(() => writingMode = true);
                            },
                            color: writingMode
                                ? _writingColor
                                : const Color(0xFF80CBC4),
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
                  const SizedBox(height: 6),
                  Expanded(
                    child: writingMode
                        ? _buildWriting(context, h, width)
                        : _buildLettersAndHaraka(
                            context, h, markedSize, pickerLetterSize),
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

  Widget _buildLettersAndHaraka(
    BuildContext context,
    Haraka h,
    double markedSize,
    double pickerLetterSize,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Column(
            children: [
              const Text(
                'الحرف مع الحركة',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 5),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: .10),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: .30),
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _markedLetter,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: markedSize,
                        height: 1.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 150,
                      child: Button3D(
                        onTap: _speakMarkedLetter,
                        color: const Color(0xFF7C4DFF),
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.volume_up_rounded, color: Colors.white),
                            SizedBox(width: 5),
                            Text(
                              'استمع',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                const Text(
                  'اختر أي حرف لسماع الحرف مع الحركة',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.only(bottom: 6),
                    itemCount: arabicLetters.length,
                    itemBuilder: (_, i) {
                      final marked = letterWithHaraka(arabicLetters[i].letter, h);
                      final selected = letterIndex == i;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: Center(
                          child: SizedBox(
                            width: double.infinity,
                            height: 58,
                            child: Button3D(
                              onTap: () {
                                _selectLetter(i);
                                VoiceService.arabic(marked);
                              },
                              color: selected
                                  ? const Color(0xFF7C4DFF)
                                  : const Color(0xFF2979FF),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                child: Text(
                                  marked,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: pickerLetterSize,
                                    height: 1,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Button3D(
                        onTap: () => _move(-1),
                        color: _previousColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_back_rounded, color: Colors.white),
                            SizedBox(width: 6),
                            Text(
                              'السابق',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Button3D(
                        onTap: () => _move(1),
                        color: _nextColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'التالي',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
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
      ],
    );
  }

  Widget _buildWriting(BuildContext context, Haraka h, double width) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
      child: Column(
        children: [
          const Text(
            'اكتب الحرف مع الحركة التي تسمعها',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 5),
          Text(
            _markedLetter,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: (width * .16).clamp(58.0, 86.0),
              height: 1,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'هذا حرف واحد مع حركة، وليس كلمة مثل با أو بو أو بي.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: BoldDrawingCanvas(key: canvasKey),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Expanded(
                child: Button3D(
                  onTap: _speakMarkedLetter,
                  color: const Color(0xFF7C4DFF),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.volume_up_rounded, color: Colors.white),
                      SizedBox(width: 5),
                      Text(
                        'استمع',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Button3D(
                  onTap: () => canvasKey.currentState?.clear(),
                  color: const Color(0xFF00A896),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  child: const Text(
                    'مسح',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Button3D(
                  onTap: () => _move(-1),
                  color: _previousColor,
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  child: const Text(
                    'السابق',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Button3D(
                  onTap: () => _move(1),
                  color: _nextColor,
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  child: const Text(
                    'التالي',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
