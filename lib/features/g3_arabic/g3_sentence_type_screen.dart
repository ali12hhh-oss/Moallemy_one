import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/storage/progress_v8.dart';
import '../../data/grammar_data.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

class G3SentenceTypeScreen extends StatefulWidget {
  const G3SentenceTypeScreen({super.key});
  @override
  State<G3SentenceTypeScreen> createState() => _G3SentenceTypeScreenState();
}

class _G3SentenceTypeScreenState extends State<G3SentenceTypeScreen> {
  final rnd = Random();
  bool learnMode = true;
  late SentenceTypeItem target;
  int score = 0;
  String? cheer;

  static const colors = [
    Color(0xFF2979FF),
    Color(0xFF00C853),
  ];

  @override
  void initState() {
    super.initState();
    _next();
  }

  void _next() {
    target = sentenceTypes[rnd.nextInt(sentenceTypes.length)];
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => VoiceService.arabic(target.sentence),
    );
  }

  void _answer(bool chosenVerbal) {
    if (chosenVerbal == target.isVerbal) {
      score++;
      setState(() => cheer = kCheers[rnd.nextInt(kCheers.length)]);
      ProgressV8.addRewards(stars: 1, xp: 5);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => cheer = null);
          _next();
        }
      });
    } else {
      setState(() => cheer = 'حاول مرة أخرى 💪');
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) setState(() => cheer = null);
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('نوع الجملة')),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Button3D(
                          onTap: () => setState(() => learnMode = true),
                          color: learnMode
                              ? const Color(0xFF7C4DFF)
                              : const Color(0xFFB39DDB),
                          depth: learnMode ? 2 : 7,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: const Center(
                            child: Text(
                              'تعلّم',
                              style: TextStyle(
                                fontSize: 16,
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
                          onTap: () => setState(() => learnMode = false),
                          color: !learnMode
                              ? const Color(0xFF00C853)
                              : const Color(0xFFA5D6A7),
                          depth: !learnMode ? 2 : 7,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: const Center(
                            child: Text(
                              'تدرّب',
                              style: TextStyle(
                                fontSize: 16,
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
                if (learnMode) ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 10, 16, 8),
                    child: Text(
                      'تعلّم نوع الجملة',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(14, 4, 14, 20),
                      children: [
                        _lessonCard(
                          title: 'الجملة الاسمية',
                          explanation:
                              'الجملة الاسمية تبدأ باسم، وتخبرنا عن شخص أو شيء أو صفة.',
                          examples: const [
                            'القمرُ جميلٌ',
                            'الشمسُ مشرقةٌ',
                            'المعلمُ نشيطٌ',
                            'الحديقةُ واسعةٌ',
                          ],
                          color: colors[0],
                        ),
                        const SizedBox(height: 14),
                        _lessonCard(
                          title: 'الجملة الفعلية',
                          explanation:
                              'الجملة الفعلية تبدأ بفعل، وتخبرنا عن عمل أو حدث.',
                          examples: const [
                            'كتب الولدُ الدرسَ',
                            'لعبت البنتُ في الحديقة',
                            'أكل الطفلُ التفاحة',
                            'قرأت سارة قصة',
                            'ركض الولدان بسرعة',
                          ],
                          color: colors[1],
                        ),
                      ],
                    ),
                  ),
                ] else
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            'الجملة الاسمية تبدأ باسم. الجملة الفعلية تبدأ بفعل.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 26),
                          GestureDetector(
                            onTap: () => VoiceService.arabic(target.sentence),
                            child: Text(
                              target.sentence,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Expanded(
                                child: Button3D(
                                  onTap: () => _answer(false),
                                  color: colors[0],
                                  padding: const EdgeInsets.symmetric(vertical: 22),
                                  child: const Center(
                                    child: Text(
                                      'اسمية',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Button3D(
                                  onTap: () => _answer(true),
                                  color: colors[1],
                                  padding: const EdgeInsets.symmetric(vertical: 22),
                                  child: const Center(
                                    child: Text(
                                      'فعلية',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
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
            ),
            CelebrationOverlay(message: cheer),
          ],
        ),
      ),
    );
  }

  Widget _lessonCard({
    required String title,
    required String explanation,
    required List<String> examples,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            explanation,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'أمثلة:',
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          ...examples.map(
            (example) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Button3D(
                onTap: () => VoiceService.arabic(example),
                color: color,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    example,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
