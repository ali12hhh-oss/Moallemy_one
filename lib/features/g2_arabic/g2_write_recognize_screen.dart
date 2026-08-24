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
        if (mounted) setState(() => modelReady = true);
        return;
      }
      if (mounted) setState(() => downloading = true);
      final ok = await modelManager.downloadModel('ar');
      if (mounted) {
        setState(() {
          downloading = false;
          modelReady = ok;
          if (!ok) {
            error = 'تعذّر تحميل نموذج التعرّف على الكتابة. تحقق من الاتصال بالإنترنت وحاول مجددًا.';
          }
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          downloading = false;
          error = 'تعذّر تحميل نموذج التعرّف على الكتابة. تحقق من الاتصال بالإنترنت وحاول مجددًا.';
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
    if (_currentPaintStroke != null) {
      strokesForPaint.add(_currentPaintStroke!);
    }
    if (_currentRecoStroke != null) {
      strokesForRecognition.add(_currentRecoStroke!);
    }
    _currentPaintStroke = null;
    _currentRecoStroke = null;
    setState(() {});
  }

  Future<void> _recognize() async {
    if (!modelReady || recognizer == null || strokesForRecognition.isEmpty) {
      return;
    }
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الكتابة الذكية ✏️'),
          actions: [
            IconButton(
              onPressed: _clear,
              tooltip: 'مسح',
              icon: const Icon(Icons.delete_outline_rounded),
            ),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
                children: [
                  if (downloading)
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'جارٍ تحميل نموذج التعرّف على الكتابة لأول مرة (يحتاج إنترنت)...',
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (error != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Text(
                        error!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(8, 6, 8, 4),
                    child: Text(
                      'اكتب أي حرف أو كلمة أو جملة بحرية تامة، بأي اتجاه',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: penColors.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (_, i) {
                        final c = penColors[i];
                        final selected = c.toARGB32() == penColor.toARGB32();
                        return GestureDetector(
                          onTap: () => setState(() => penColor = c),
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selected
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 330,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: GestureDetector(
                            onPanStart: (d) => _onPanStart(d.localPosition),
                            onPanUpdate: (d) => _onPanUpdate(d.localPosition),
                            onPanEnd: (_) => _onPanEnd(),
                            child: CustomPaint(
                              painter: _RecoPainter([
                                ...strokesForPaint,
                                if (_currentPaintStroke != null)
                                  _currentPaintStroke!,
                              ], penColor),
                              child: const SizedBox.expand(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (recognizedText != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'قرأت: $recognizedText',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: modelReady &&
                              !recognizing &&
                              strokesForRecognition.isNotEmpty
                          ? _recognize
                          : null,
                      icon: recognizing
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.record_voice_over_rounded),
                      label: Text(
                        recognizing ? 'جارٍ القراءة...' : 'اقرأ ما كتبته 🔊',
                      ),
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
