import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../widgets/button_3d.dart';

class G3LetterSkillsScreen extends StatefulWidget {
  const G3LetterSkillsScreen({super.key});

  @override
  State<G3LetterSkillsScreen> createState() => _G3LetterSkillsScreenState();
}

class _G3LetterSkillsScreenState extends State<G3LetterSkillsScreen> {
  static const _positionQuestions = <(String, String, String)>[
    ('كتاب', 'ك', 'أول'), ('قلم', 'ل', 'وسط'), ('مدرسة', 'ة', 'آخر'),
    ('شجرة', 'ج', 'وسط'), ('نجم', 'ن', 'أول'), ('سمك', 'ك', 'آخر'),
    ('باب', 'ب', 'أول'), ('بيت', 'ت', 'آخر'), ('جمل', 'م', 'وسط'),
    ('تفاح', 'ح', 'آخر'), ('بحر', 'ح', 'وسط'), ('علم', 'ع', 'أول'),
    ('قمر', 'ر', 'آخر'), ('نهر', 'ه', 'وسط'), ('زهرة', 'ز', 'أول'),
    ('كرسي', 'ر', 'وسط'), ('مفتاح', 'م', 'أول'), ('سيارة', 'ر', 'وسط'),
    ('حديقة', 'ة', 'آخر'), ('طائرة', 'ط', 'أول'), ('حصان', 'ص', 'وسط'),
    ('مكتبة', 'ب', 'وسط'), ('دفتر', 'د', 'أول'), ('سفينة', 'ة', 'آخر'),
  ];

  static const _missingQuestions = <(String, String, String)>[
    ('ك_تاب', 'ت', 'كتاب'), ('ق_لم', 'ل', 'قلم'), ('م_رسة', 'د', 'مدرسة'),
    ('ش_رة', 'ج', 'شجرة'), ('ن_ر', 'ه', 'نهر'), ('ب_ت', 'ي', 'بيت'),
    ('ج_ل', 'م', 'جمل'), ('ت_اح', 'ف', 'تفاح'), ('ح_ر', 'ب', 'بحر'),
    ('ز_رة', 'ه', 'زهرة'), ('س_ينة', 'ف', 'سفينة'), ('م_تاح', 'ف', 'مفتاح'),
    ('س_ارة', 'ي', 'سيارة'), ('ح_ديقة', 'د', 'حديقة'), ('د_تر', 'ف', 'دفتر'),
    ('ك_سي', 'ر', 'كرسي'), ('ط_رة', 'ائ', 'طائرة'), ('م_تبة', 'ك', 'مكتبة'),
  ];

  static const _buildWords = <List<String>>[
    ['ك', 'ت', 'ا', 'ب'], ['ق', 'ل', 'م'], ['ش', 'ج', 'ر', 'ة'],
    ['ب', 'ي', 'ت'], ['ج', 'م', 'ل'], ['ت', 'ف', 'ا', 'ح'],
    ['ن', 'ه', 'ر'], ['ز', 'ه', 'ر', 'ة'], ['س', 'ف', 'ي', 'ن', 'ة'],
    ['م', 'ف', 'ت', 'ا', 'ح'], ['س', 'ي', 'ا', 'ر', 'ة'], ['ح', 'د', 'ي', 'ق', 'ة'],
    ['ح', 'ص', 'ا', 'ن'], ['م', 'ك', 'ت', 'ب', 'ة'], ['د', 'ف', 'ت', 'ر'],
    ['ق', 'م', 'ر'], ['ع', 'ل', 'م'], ['ب', 'ح', 'ر'], ['ن', 'ج', 'م'],
    ['و', 'ر', 'د'], ['ق', 'ط', 'ة'], ['ك', 'ل', 'ب'], ['ب', 'ا', 'ب'],
    ['م', 'د', 'ر', 'س', 'ة'],
  ];

  static const _soundLetters = [
    'ب', 'ت', 'ج', 'د', 'ر', 'س', 'م', 'ن', 'ق', 'ل', 'ف', 'ك',
  ];

  final _rnd = Random();
  int positionIndex = 0;
  int missingIndex = 0;
  int buildIndex = 0;
  int soundIndex = 0;
  String? positionAnswer;
  String? missingAnswer;
  List<String> selectedBuildLetters = [];
  String? soundAnswer;

  @override
  void dispose() {
    VoiceService.stop();
    super.dispose();
  }

  void _speak(String text) {
    VoiceService.stop();
    VoiceService.arabic(text);
  }

  List<String> _shuffled(List<String> source) => [...source]..shuffle(_rnd);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('مهارات الحروف')),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
            children: [
              const Text(
                'تدريبات متقدمة على استخدام الحروف داخل الكلمات',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 14),
              _section('١. الحرف في الكلمة', 'حدد موقع الحرف: أول، وسط، أم آخر الكلمة', const Color(0xFF7C4DFF), _positionCard()),
              const SizedBox(height: 14),
              _section('٢. أكمل الكلمة', 'اختر الحرف الناقص لتكوين كلمة صحيحة', const Color(0xFFFF6B35), _missingCard()),
              const SizedBox(height: 14),
              _section('٣. كوّن الكلمة', 'رتّب الحروف لتكوين الكلمة ثم تحقق من إجابتك', const Color(0xFF00BFA6), _buildCard()),
              const SizedBox(height: 14),
              _section('٤. اسمع ثم اختر الحرف', 'استمع للصوت ثم اختر الحرف الذي سمعته', const Color(0xFF2979FF), _soundCard()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(
    String title,
    String subtitle,
    Color color,
    Widget child,
  ) => Container(
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .08),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withValues(alpha: .28), width: 2),
        ),
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      );

  Widget _positionCard() {
    final q = _positionQuestions[positionIndex];
    const options = ['أول', 'وسط', 'آخر'];
    return Column(
      children: [
        Text(
          q.$1,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        Text(
          'أين يقع الحرف «${q.$2}»؟',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: options
              .map(
                (o) => SizedBox(
                  width: 96,
                  child: Button3D(
                    onTap: () {
                      final ok = o == q.$3;
                      setState(() => positionAnswer =
                          ok ? 'صحيح ✅' : 'حاول مرة أخرى');
                      if (ok) _speak(q.$1);
                    },
                    color: o == 'أول'
                        ? const Color(0xFF00A896)
                        : o == 'وسط'
                            ? const Color(0xFFFFB300)
                            : const Color(0xFFEF5350),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      o,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        if (positionAnswer != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              positionAnswer!,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        const SizedBox(height: 6),
        _nextButton(
          'كلمة أخرى',
          () => setState(() {
            positionIndex = (positionIndex + 1) % _positionQuestions.length;
            positionAnswer = null;
          }),
        ),
      ],
    );
  }

  Widget _missingCard() {
    final q = _missingQuestions[missingIndex];
    final options = _shuffled([q.$2, 'ب', 'م', 'ل', 'ن']);
    return Column(
      children: [
        Text(
          q.$1,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        const Text(
          'ما الحرف الناقص؟',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: options
              .map(
                (l) => SizedBox(
                  width: 58,
                  child: Button3D(
                    onTap: () {
                      final ok = l == q.$2;
                      setState(() => missingAnswer =
                          ok ? 'صحيح ✅' : 'حاول مرة أخرى');
                      if (ok) _speak(q.$3);
                    },
                    color: const Color(0xFF8E24AA),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    child: Text(
                      l,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        if (missingAnswer != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              missingAnswer!,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        const SizedBox(height: 6),
        _nextButton(
          'كلمة أخرى',
          () => setState(() {
            missingIndex = (missingIndex + 1) % _missingQuestions.length;
            missingAnswer = null;
          }),
        ),
      ],
    );
  }

  Widget _buildCard() {
    final target = _buildWords[buildIndex];
    final shuffled = _shuffled(target);
    final formed = selectedBuildLetters.join();
    final isComplete = selectedBuildLetters.length == target.length;
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          runSpacing: 8,
          children: shuffled
              .map(
                (l) => SizedBox(
                  width: 58,
                  height: 58,
                  child: Button3D(
                    onTap: () {
                      if (selectedBuildLetters.length >= target.length) return;
                      setState(() => selectedBuildLetters.add(l));
                    },
                    color: const Color(0xFF00BFA6),
                    padding: EdgeInsets.zero,
                    child: Text(
                      l,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 10),
        Text(
          formed.isEmpty ? 'اضغط الحروف بالترتيب الصحيح' : formed,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: [
            SizedBox(
              width: 150,
              child: Button3D(
                onTap: () {
                  if (!isComplete) return;
                  final ok = formed == target.join();
                  setState(() => missingAnswer =
                      ok ? 'صحيح ✅' : 'الترتيب غير صحيح');
                  if (ok) _speak(formed);
                },
                color: const Color(0xFF00A896),
                padding: const EdgeInsets.symmetric(vertical: 11),
                child: const Text(
                  'تحقق',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 150,
              child: Button3D(
                onTap: () => setState(() => selectedBuildLetters = []),
                color: const Color(0xFFEF5350),
                padding: const EdgeInsets.symmetric(vertical: 11),
                child: const Text(
                  'مسح',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (missingAnswer != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              missingAnswer!,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        const SizedBox(height: 6),
        _nextButton(
          'كلمة جديدة',
          () => setState(() {
            buildIndex = (buildIndex + 1) % _buildWords.length;
            selectedBuildLetters = [];
            missingAnswer = null;
          }),
        ),
      ],
    );
  }

  Widget _soundCard() {
    final target = _soundLetters[soundIndex];
    final options = _shuffled([
      target,
      ..._soundLetters.where((l) => l != target).take(4),
    ]);
    return Column(
      children: [
        SizedBox(
          width: 180,
          child: Button3D(
            onTap: () => _speak(target),
            color: const Color(0xFF2979FF),
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.volume_up_rounded, color: Colors.white),
                SizedBox(width: 7),
                Text(
                  'استمع للصوت',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'أي حرف سمعت؟',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 7,
          children: options
              .map(
                (l) => SizedBox(
                  width: 54,
                  child: Button3D(
                    onTap: () {
                      final ok = l == target;
                      setState(() => soundAnswer =
                          ok ? 'صحيح ✅' : 'حاول مرة أخرى');
                    },
                    color: const Color(0xFF2979FF),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      l,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        if (soundAnswer != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              soundAnswer!,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        const SizedBox(height: 6),
        _nextButton(
          'حرف آخر',
          () => setState(() {
            soundIndex = (soundIndex + 1) % _soundLetters.length;
            soundAnswer = null;
          }),
        ),
      ],
    );
  }

  Widget _nextButton(String label, VoidCallback onTap) =>
      TextButton(onPressed: onTap, child: Text(label));
}
