import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../widgets/button_3d.dart';

/// كتابة الأرقام للروضة الثانية فقط.
///
/// التسلسل ثابت من ١ إلى ٥٠. بعد الوصول إلى ١٠ تبدأ أسئلة القيمة المكانية،
/// مع وضع الآحاد على اليمين والعشرات على اليسار بما يتوافق مع اتجاه العربية.
class G2WriteNumbersScreen extends StatefulWidget {
  const G2WriteNumbersScreen({super.key});

  @override
  State<G2WriteNumbersScreen> createState() => _G2WriteNumbersScreenState();
}

class _G2WriteNumbersScreenState extends State<G2WriteNumbersScreen> {
  int number = 1;
  bool _speaking = false;

  bool get hasPlaceValue => number >= 10;

  int get ones => number % 10;
  int get tens => number ~/ 10;

  String get question {
    if (!hasPlaceValue) return 'تعرّف على الرقم ${arNum(number)}';
    // نبدّل السؤال حتى يتدرّب الطفل على الآحاد والعشرات معًا.
    return number.isEven ? 'أين الآحاد؟' : 'أين العشرات؟';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakQuestion());
  }

  Future<void> _speakQuestion() async {
    if (_speaking) return;
    _speaking = true;
    try {
      await VoiceService.arabic(question);
    } finally {
      _speaking = false;
    }
  }

  void _next() {
    if (number >= 50) return;
    setState(() => number++);
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakQuestion());
  }

  void _previous() {
    if (number <= 1) return;
    setState(() => number--);
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakQuestion());
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('كتابة الأرقام ١ - ٥٠'),
          actions: [
            IconButton(
              tooltip: 'استمع إلى السؤال',
              onPressed: _speakQuestion,
              icon: const Icon(Icons.volume_up_rounded),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'الرقم ${arNum(number)} من ٥٠',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
                  child: Column(
                    children: [
                      Button3D(
                        onTap: _speakQuestion,
                        color: const Color(0xFF7C4DFF),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 18,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.record_voice_over_rounded,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                question,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      if (!hasPlaceValue)
                        _singleNumberCard()
                      else
                        _placeValueCards(),
                      const SizedBox(height: 18),
                      Text(
                        hasPlaceValue
                            ? 'الآحاد على اليمين والعشرات على اليسار'
                            : 'سنبدأ بالقيمة المكانية عند الرقم ١٠',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: number > 1 ? _previous : null,
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: const Text('السابق'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 56),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: number < 50 ? _next : null,
                        icon: const Icon(Icons.arrow_back_rounded),
                        label: const Text('التالي'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 56),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _singleNumberCard() {
    return _numberCard(
      title: 'الرقم',
      value: arNum(number),
      color: const Color(0xFF00BFA6),
      large: true,
    );
  }

  Widget _placeValueCards() {
    // Directionality.rtl تجعل أول عنصر في الـRow على الجهة اليمنى.
    // لذلك نضع الآحاد أولًا ثم العشرات، فتظهر الآحاد يمينًا والعشرات يسارًا.
    return Row(
      children: [
        Expanded(
          child: _numberCard(
            title: 'الآحاد',
            value: arNum(ones),
            color: const Color(0xFF2979FF),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _numberCard(
            title: 'العشرات',
            value: arNum(tens),
            color: const Color(0xFFFF6B35),
          ),
        ),
      ],
    );
  }

  Widget _numberCard({
    required String title,
    required String value,
    required Color color,
    bool large = false,
  }) {
    return Button3D(
      onTap: _speakQuestion,
      color: color,
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: large ? 34 : 24,
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: Colors.white,
              fontSize: large ? 58 : 50,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
