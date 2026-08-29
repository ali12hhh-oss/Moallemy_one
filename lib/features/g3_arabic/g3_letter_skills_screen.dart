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
  final _rnd = Random();

  static const _positionWords = <String>[
    'كتاب', 'قلم', 'مدرسة', 'شجرة', 'نجم', 'سمك', 'باب', 'بيت',
    'جمل', 'تفاح', 'بحر', 'علم', 'قمر', 'نهر', 'زهرة', 'كرسي',
    'مفتاح', 'سيارة', 'حديقة', 'طائرة', 'حصان', 'مكتبة', 'دفتر', 'سفينة',
  ];

  static const _missingWords = <(String, String, String)>[
    ('ك_تاب', 'ت', 'كتاب'), ('ق_لم', 'ل', 'قلم'), ('م_رسة', 'د', 'مدرسة'),
    ('ش_رة', 'ج', 'شجرة'), ('ن_ر', 'ه', 'نهر'), ('ب_ت', 'ي', 'بيت'),
    ('ج_ل', 'م', 'جمل'), ('ت_اح', 'ف', 'تفاح'), ('ح_ر', 'ب', 'حبر'),
    ('ز_رة', 'ه', 'زهرة'), ('س_ينة', 'ف', 'سفينة'), ('م_تاح', 'ف', 'مفتاح'),
    ('س_ارة', 'ي', 'سيارة'), ('ح_ديقة', 'د', 'حديقة'), ('د_تر', 'ف', 'دفتر'),
  ];

  static const _buildWords = <(String, List<String>)>[
    ('تابك', ['ك', 'ت', 'ا', 'ب']),
    ('لمق', ['ق', 'ل', 'م']),
    ('ترهشج', ['ش', 'ج', 'ر', 'ة']),
    ('تيب', ['ب', 'ي', 'ت']),
    ('ملج', ['ج', 'م', 'ل']),
    ('احبتف', ['ت', 'ف', 'ا', 'ح']),
    ('مرهن', ['ن', 'ه', 'ر']),
    ('رةزه', ['ز', 'ه', 'ر', 'ة']),
    ('ينةفس', ['س', 'ف', 'ي', 'ن', 'ة']),
    ('تاحفم', ['م', 'ف', 'ت', 'ا', 'ح']),
    ('ارةيس', ['س', 'ي', 'ا', 'ر', 'ة']),
    ('قرةحد', ['ح', 'د', 'ي', 'ق', 'ة']),
  ];

  int positionIndex = 0;
  int missingIndex = 0;
  int buildIndex = 0;
  String? positionAnswer;
  String? missingAnswer;
  String? buildAnswer;

  @override
  void dispose() {
    VoiceService.stop();
    super.dispose();
  }

  void _speak(String text) {
    VoiceService.stop();
    VoiceService.arabic(text);
  }

  String _positionQuestion(String word) {
    final letters = word.characters.toList();
    final target = letters[_rnd.nextInt(letters.length)];
    final index = letters.indexOf(target);
    final position = index == 0 ? 'أول الكلمة' : index == letters.length - 1 ? 'آخر الكلمة' : 'وسط الكلمة';
    return '$target • $position';
  }

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
                'نتدرّب على استخدام الحرف داخل الكلمة، لا على شكل الحرف وحده',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 14),
              _card(
                title: '١. الحرف في الكلمة',
                subtitle: 'حدد موقع الحرف: أول، وسط، أم آخر الكلمة',
                color: const Color(0xFF7C4DFF),
                child: _positionCard(),
              ),
              const SizedBox(height: 14),
              _card(
                title: '٢. أكمل الكلمة',
                subtitle: 'اختر الحرف الذي ينقص الكلمة',
                color: const Color(0xFFFF6B35),
                child: _missingCard(),
              ),
              const SizedBox(height: 14),
              _card(
                title: '٣. كوّن الكلمة',
                subtitle: 'رتّب الحروف لتكوين الكلمة الصحيحة',
                color: const Color(0xFF00BFA6),
                child: _buildCard(),
              ),
              const SizedBox(height: 14),
              _card(
                title: '٤. اسمع ثم اختر الحرف',
                subtitle: 'استمع لصوت الحرف واختره من الخيارات',
                color: const Color(0xFF2979FF),
                child: _soundCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card({required String title, required String subtitle, required Color color, required Widget child}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: .28), width: 2),
      ),
      child: Column(
        children: [
          Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: color)),
          const SizedBox(height: 3),
          Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _positionCard() {
    final word = _positionWords[positionIndex];
    final letters = word.characters.toList();
    final target = letters[letters.length ~/ 2];
    final correct = letters.indexOf(target) == 0 ? 'أول' : letters.indexOf(target) == letters.length - 1 ? 'آخر' : 'وسط';
    final options = ['أول', 'وسط', 'آخر'];
    return Column(children: [
      Text(word, style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w900)),
      const SizedBox(height: 4),
      Text('أين يقع الحرف «$target»؟', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        children: options.map((o) => SizedBox(width: 100, child: Button3D(onTap: () {
          setState(() => positionAnswer = o == correct ? 'صحيح ✅' : 'حاول مرة أخرى');
          if (o == correct) _speak(word);
        }, color: o == 'أول' ? const Color(0xFF00A896) : o == 'وسط' ? const Color(0xFFFFB300) : const Color(0xFFEF5350), padding: const EdgeInsets.symmetric(vertical: 12), child: Text(o, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900))))).toList(),
      ),
      if (positionAnswer != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(positionAnswer!, style: const TextStyle(fontWeight: FontWeight.w900))),
      const SizedBox(height: 8),
      TextButton(onPressed: () => setState(() { positionIndex = (positionIndex + 1) % _positionWords.length; positionAnswer = null; }), child: const Text('كلمة أخرى')),
    ]);
  }

  Widget _missingCard() {
    final item = _missingWords[missingIndex];
    final base = item.$1;
    final correct = item.$2;
    final letters = <String>{correct, 'ب', 'م', 'ل', 'ن'}.toList()..shuffle(_rnd);
    return Column(children: [
      Text(base, style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900)),
      const SizedBox(height: 4),
      Text('ما الحرف الناقص؟', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        children: letters.map((l) => SizedBox(width: 64, child: Button3D(onTap: () {
          final ok = l == correct;
          setState(() => missingAnswer = ok ? 'صحيح ✅' : 'حاول مرة أخرى');
          if (ok) _speak(item.$3);
        }, color: l == correct ? const Color(0xFF43A047) : const Color(0xFF8E24AA), padding: const EdgeInsets.symmetric(vertical: 11), child: Text(l, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w900))))).toList(),
      ),
      if (missingAnswer != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(missingAnswer!, style: const TextStyle(fontWeight: FontWeight.w900))),
      const SizedBox(height: 8),
      TextButton(onPressed: () => setState(() { missingIndex = (missingIndex + 1) % _missingWords.length; missingAnswer = null; }), child: const Text('كلمة أخرى')),
    ]);
  }

  Widget _buildCard() {
    final item = _buildWords[buildIndex];
    final letters = [...item.$2]..shuffle(_rnd);
    return Column(children: [
      Text(item.$1, style: const TextStyle(fontSize: 22, color: Colors.transparent)),
      Wrap(
        alignment: WrapAlignment.center,
        spacing: 6,
        runSpacing: 8,
        textDirection: TextDirection.rtl,
        children: letters.map((l) => Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(color: const Color(0xFF00BFA6).withValues(alpha: .14), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFF00BFA6), width: 2)),
          alignment: Alignment.center,
          child: Text(l, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
        )).toList(),
      ),
      const SizedBox(height: 10),
      Text('اضغط على الحروف بالترتيب الصحيح', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
      const SizedBox(height: 8),
      SizedBox(width: 170, child: Button3D(onTap: () { final word = item.$2.join(); setState(() => buildAnswer = word); _speak(word); }, color: const Color(0xFF00BFA6), padding: const EdgeInsets.symmetric(vertical: 12), child: const Text('تحقق من الكلمة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)))),
      if (buildAnswer != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text('الكلمة: $buildAnswer', style: const TextStyle(fontWeight: FontWeight.w900))),
      const SizedBox(height: 8),
      TextButton(onPressed: () => setState(() { buildIndex = (buildIndex + 1) % _buildWords.length; buildAnswer = null; }), child: const Text('تحدي آخر')),
    ]);
  }

  Widget _soundCard() {
    const letters = ['ب', 'ت', 'ج', 'د', 'س', 'م', 'ن', 'ر', 'ق'];
    final target = letters[positionIndex % letters.length];
    return Column(children: [
      SizedBox(width: 180, child: Button3D(onTap: () => _speak(target), color: const Color(0xFF2979FF), padding: const EdgeInsets.symmetric(vertical: 13), child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.volume_up_rounded, color: Colors.white), SizedBox(width: 7), Text('استمع للصوت', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900))]))),
      const SizedBox(height: 10),
      Text('أي حرف سمعت؟', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
      const SizedBox(height: 8),
      Wrap(alignment: WrapAlignment.center, spacing: 7, children: letters.take(5).map((l) => SizedBox(width: 54, child: Button3D(onTap: () { setState(() => buildAnswer = l == target ? 'صحيح ✅' : 'حاول مرة أخرى'); }, color: const Color(0xFF2979FF), padding: const EdgeInsets.symmetric(vertical: 10), child: Text(l, style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w900))))).toList()),
      if (buildAnswer != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(buildAnswer!, style: const TextStyle(fontWeight: FontWeight.w900))),
    ]);
  }
}
