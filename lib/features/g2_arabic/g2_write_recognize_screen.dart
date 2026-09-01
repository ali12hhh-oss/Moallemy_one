import 'package:flutter/material.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart'
    as mlkit;

import '../../core/audio/voice_service.dart';
import '../../widgets/celebration_overlay.dart';

/// سبورة كتابة ذكية تعمل على الجهاز بعد تنزيل نموذج العربية لأول مرة.
class G2WriteRecognizeScreen extends StatefulWidget {
  const G2WriteRecognizeScreen({super.key});
  @override
  State<G2WriteRecognizeScreen> createState() => _G2WriteRecognizeScreenState();
}

class _G2WriteRecognizeScreenState extends State<G2WriteRecognizeScreen> {
  final modelManager = mlkit.DigitalInkRecognizerModelManager();
  mlkit.DigitalInkRecognizer? recognizer;

  final List<List<Offset>> strokesForPaint = [];
  final List<mlkit.Stroke> strokesForRecognition = [];
  List<Offset>? _currentPaintStroke;
  mlkit.Stroke? _currentRecoStroke;

  Color penColor = const Color(0xFF3949AB);
  static const penColors = [
    Color(0xFF3949AB),
    Color(0xFFE53935),
    Color(0xFF00897B),
    Color(0xFFFB8C00),
    Color(0xFF8E24AA),
    Color(0xFF212121),
  ];

  bool modelReady = false;
  bool downloading = false;
  bool recognizing = false;
  String? recognizedText;
  String? error;
  String? cheer;

  @override
  void initState() {
    super.initState();
    recognizer = mlkit.DigitalInkRecognizer(languageCode: 'ar');
    _ensureModel();
  }

  Future<void> _ensureModel() async {
    try {
      final downloaded = await modelManager.isModelDownloaded('ar');
      if (downloaded) {
        recognizer?.close();
        recognizer = mlkit.DigitalInkRecognizer(languageCode: 'ar');
        if (mounted) setState(() => modelReady = true);
        return;
      }

      if (mounted) {
        setState(() {
          downloading = true;
          error = null;
        });
      }

      // لا نجعل تنزيل النموذج مقصورًا على Wi‑Fi؛ بعض الأجهزة لا تكمل
      // التنزيل عندما يكون الاتصال عبر بيانات الهاتف.
      final ok = await modelManager
          .downloadModel('ar', isWifiRequired: false)
          .timeout(const Duration(seconds: 90), onTimeout: () => false);

      if (ok) {
        recognizer?.close();
        recognizer = mlkit.DigitalInkRecognizer(languageCode: 'ar');
      }

      if (mounted) {
        setState(() {
          downloading = false;
          modelReady = ok;
          if (!ok) {
            error = 'تعذّر تجهيز نموذج التعرّف على الكتابة. تحقق من الاتصال بالإنترنت وحاول مجددًا.';
          }
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          downloading = false;
          modelReady = false;
          error = 'تعذّر تجهيز نموذج التعرّف على الكتابة. تحقق من الاتصال بالإنترنت وحاول مجددًا.';
        });
      }
    }
  }

  void _clear() {
    setState(() {
      strokesForPaint.clear();
      strokesForRecognition.clear();
      recognizedText = null;
      error = null;
    });
  }

  void _onPanStart(Offset p) {
    _currentPaintStroke = [p];
    _currentRecoStroke = mlkit.Stroke();
    _currentRecoStroke!.points.add(
      mlkit.StrokePoint(
        x: p.dx,
        y: p.dy,
        t: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    setState(() {});
  }

  void _onPanUpdate(Offset p) {
    _currentPaintStroke?.add(p);
    _currentRecoStroke?.points.add(
      mlkit.StrokePoint(
        x: p.dx,
        y: p.dy,
        t: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    setState(() {});
  }

  void _onPanEnd() {
    if (_currentPaintStroke != null) strokesForPaint.add(_currentPaintStroke!);
    if (_currentRecoStroke != null) strokesForRecognition.add(_currentRecoStroke!);
    _currentPaintStroke = null;
    _currentRecoStroke = null;
    setState(() {});
  }

  Future<void> _recognize() async {
    if (!modelReady || recognizer == null || strokesForRecognition.isEmpty) return;
    setState(() {
      recognizing = true;
      recognizedText = null;
      error = null;
    });
    try {
      final ink = mlkit.Ink()..strokes = strokesForRecognition;
      final candidates = await recognizer!.recognize(ink);
      if (!mounted) return;
      if (candidates.isNotEmpty && candidates.first.text.trim().isNotEmpty) {
        final text = candidates.first.text.trim();
        setState(() {
          recognizedText = text;
          recognizing = false;
          cheer = 'أحسنت! قرأت: $text 🎉';
        });
        await VoiceService.arabic(text);
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) setState(() => cheer = null);
        });
      } else {
        setState(() {
          recognizing = false;
          error = 'لم أستطع قراءة الكتابة بوضوح، حاول الكتابة بخط أكبر وأوضح.';
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          recognizing = false;
          error = 'حدث خطأ أثناء التعرّف على الكتابة، حاول مجددًا.';
        });
      }
    }
  }

  @override
  void dispose() {
    recognizer?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الكتابة الذكية ✏️')),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 42,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: penColors.map((c) {
                        final selected = c.toARGB32() == penColor.toARGB32();
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: GestureDetector(
                            onTap: () => setState(() => penColor = c),
                            child: Container(
                              width: 31,
                              height: 31,
                              decoration: BoxDecoration(
                                color: c,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: selected ? Colors.white : Colors.transparent,
                                  width: 3,
                                ),
                                boxShadow: selected
                                    ? [const BoxShadow(blurRadius: 3)]
                                    : null,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  if (downloading || error != null)
                    SizedBox(
                      height: 34,
                      child: Center(
                        child: Text(
                          downloading
                              ? 'جارٍ تحميل نموذج الكتابة لأول مرة...'
                              : error!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: downloading ? theme.colorScheme.onSurface : Colors.red,
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: theme.colorScheme.outlineVariant, width: 2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onPanStart: (d) => _onPanStart(d.localPosition),
                            onPanUpdate: (d) => _onPanUpdate(d.localPosition),
                            onPanEnd: (_) => _onPanEnd(),
                            child: CustomPaint(
                              painter: _RecoPainter([
                                ...strokesForPaint,
                                if (_currentPaintStroke != null) _currentPaintStroke!,
                              ], penColor),
                              child: const SizedBox.expand(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (recognizedText != null)
                    SizedBox(
                      height: 34,
                      child: Center(
                        child: Text(
                          'قرأت: $recognizedText',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _clear,
                            icon: const Icon(Icons.delete_sweep_rounded),
                            label: const Text('مسح السبورة'),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFE53935),
                              minimumSize: const Size(0, 56),
                              textStyle: const TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: modelReady && !recognizing && strokesForRecognition.isNotEmpty
                                ? _recognize
                                : null,
                            icon: recognizing
                                ? const SizedBox(
                                    width: 17,
                                    height: 17,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Icon(Icons.record_voice_over_rounded),
                            label: Text(recognizing ? 'جارٍ القراءة...' : 'اقرأ ما كتبته 🔊'),
                            style: FilledButton.styleFrom(minimumSize: const Size(0, 56)),
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
      ),
    );
  }
}

class _RecoPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final Color color;
  _RecoPainter(this.strokes, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final pen = Paint()
      ..color = color
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    for (final stroke in strokes) {
      for (var i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(stroke[i], stroke[i + 1], pen);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RecoPainter oldDelegate) => true;
}
