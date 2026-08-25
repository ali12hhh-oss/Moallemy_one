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

  String get _markedLetter => letterWithHaraka(
        harakaSampleLetters[letterIndex],
        widget.haraka,
      );

  void _move(int delta) {
    _stop();
    setState(() {
      letterIndex = (letterIndex + delta + harakaSampleLetters.length) %
          harakaSampleLetters.length;
      cheer = null;
    });
    canvasKey.currentState?.clear();
  }

  void _speakMarkedLetter() => VoiceService.arabic(_markedLetter);

  void _celebrate() {
    setState(() => cheer = kCheers[letterIndex % kCheers.length]);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => cheer = null);
    });
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = widget.haraka;
    final width = MediaQuery.sizeOf(context).width;
    final markedSize = (width * .22).clamp(64.0, 110.0);

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
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 620),
                          child: Column(
                            children: [
                              Text(
                                'الحرف مع ${h.name}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withValues(alpha: .10),
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: .30),
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      _markedLetter,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: markedSize,
                                        height: 1.05,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      _markedLetter,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: 190,
                                      child: Button3D(
                                        onTap: _speakMarkedLetter,
                                        color: const Color(0xFF7C4DFF),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.volume_up_rounded,
                                                color: Colors.white),
                                            SizedBox(width: 6),
                                            Text(
                                              'اسمع صوت الحركة',
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
                              const SizedBox(height: 14),
                              if (!writingMode)
                                Column(
                                  children: [
                                    const Text(
                                      'اختر أي حرف لسماع الحرف مع الحركة',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 105,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 8,
                                        childAspectRatio: 1.25,
                                      ),
                                      itemCount: arabicLetters.length,
                                      itemBuilder: (_, i) {
                                        final marked = letterWithHaraka(
                                            arabicLetters[i].letter, h);
                                        return Button3D(
                                          onTap: () => VoiceService.arabic(marked),
                                          color: const Color(0xFF2979FF),
                                          padding: const EdgeInsets.all(8),
                                          child: Center(
                                            child: Text(
                                              marked,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 30,
                                                height: 1,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    const Text(
                                      'اكتب الحرف مع الحركة التي تسمعها',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _markedLetter,
                                      style: TextStyle(
                                        fontSize: (width * .18).clamp(58.0, 90.0),
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
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      height: 190,
                                      child: BoldDrawingCanvas(key: canvasKey),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Button3D(
                                            onTap: _speakMarkedLetter,
                                            color: const Color(0xFF7C4DFF),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.volume_up_rounded,
                                                    color: Colors.white),
                                                SizedBox(width: 5),
                                                Text('استمع',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w900)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Button3D(
                                            onTap: () {
                                              canvasKey.currentState?.clear();
                                              _celebrate();
                                            },
                                            color: const Color(0xFF00A896),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            child: const Text('مسح',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w900)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: Button3D(
                                      onTap: () => _move(-1),
                                      color: _previousColor,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.arrow_back_rounded,
                                              color: Colors.white),
                                          SizedBox(width: 6),
                                          Text('السابق',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w900)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Button3D(
                                      onTap: () => _move(1),
                                      color: _nextColor,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('التالي',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w900)),
                                          SizedBox(width: 6),
                                          Icon(Icons.arrow_forward_rounded,
                                              color: Colors.white),
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
