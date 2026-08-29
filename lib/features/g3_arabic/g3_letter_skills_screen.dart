import 'dart:async';
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
  static const _missingLetterQuestions = <({String pattern, String answer, String word})>[
    (pattern: 'ك_تاب', answer: 'ت', word: 'كتاب'),
    (pattern: 'ق_لم', answer: 'ل', word: 'قلم'),
    (pattern: 'م_رسة', answer: 'د', word: 'مدرسة'),
    (pattern: 'ش_رة', answer: 'ج', word: 'شجرة'),
    (pattern: 'ن_ر', answer: 'ه', word: 'نهر'),
    (pattern: 'ب_ت', answer: 'ي', word: 'بيت'),
    (pattern: 'ج_ل', answer: 'م', word: 'جمل'),
    (pattern: 'ت_اح', answer: 'ف', word: 'تفاح'),
    (pattern: 'ح_ر', answer: 'ب', word: 'بحر'),
    (pattern: 'ز_رة', answer: 'ه', word: 'زهرة'),
    (pattern: 'س_ينة', answer: 'ف', word: 'سفينة'),
    (pattern: 'م_تاح', answer: 'ف', word: 'مفتاح'),
    (pattern: 'س_ارة', answer: 'ي', word: 'سيارة'),
    (pattern: 'ح_يقة', answer: 'د', word: 'حديقة'),
    (pattern: 'د_تر', answer: 'ف', word: 'دفتر'),
    (pattern: 'ك_سي', answer: 'ر', word: 'كرسي'),
    (pattern: 'ط_رة', answer: 'ا', word: 'طائرة'),
    (pattern: 'م_تبة', answer: 'ك', word: 'مكتبة'),
    (pattern: 'و_دة', answer: 'ر', word: 'وردة'),
    (pattern: 'ق_ة', answer: 'ط', word: 'قطة'),
    (pattern: 'ك_ب', answer: 'ل', word: 'كلب'),
    (pattern: 'ب_ب', answer: 'ا', word: 'باب'),
    (pattern: 'ق_مر', answer: 'م', word: 'قمر'),
    (pattern: 'ع_م', answer: 'ل', word: 'علم'),
    (pattern: 'و_د', answer: 'ر', word: 'ورد'),
    (pattern: 'ص_ف', answer: 'ي', word: 'صيف'),
    (pattern: 'خ_ز', answer: 'ب', word: 'خبز'),
    (pattern: 'ع_ب', answer: 'ن', word: 'عنب'),
    (pattern: 'ل_ن', answer: 'و', word: 'لون'),
    (pattern: 'س_م', answer: 'ه', word: 'سهم'),
    (pattern: 'ن_مة', answer: 'ع', word: 'نعمة'),
    (pattern: 'ش_مس', answer: 'م', word: 'شمس'),
    (pattern: 'ح_ان', answer: 'ص', word: 'حصان'),
    (pattern: 'ف_ل', answer: 'ص', word: 'فصل'),
    (pattern: 'ر_ان', answer: 'م', word: 'رمضان'),
    (pattern: 'م_ران', answer: 'ط', word: 'مطران'),
  ];

  static const _missingWordQuestions = <({String sentence, String answer, List<String> options})>[
    (sentence: 'يقرأ أحمد ____ في المساء.', answer: 'كتاباً', options: ['كتاباً', 'تفاحة', 'كرة', 'حقيبة']),
    (sentence: 'وضعت سارة القلم في ____.', answer: 'الحقيبة', options: ['الحقيبة', 'الحديقة', 'السماء', 'البحر']),
    (sentence: 'تشرق ____ كل صباح.', answer: 'الشمس', options: ['الشمس', 'الوردة', 'الطاولة', 'الحقيبة']),
    (sentence: 'يلعب سامر بـ ____.', answer: 'الكرة', options: ['الكرة', 'الكتاب', 'القلم', 'المفتاح']),
    (sentence: 'ينمو الزرع في ____.', answer: 'الحديقة', options: ['الحديقة', 'المدرسة', 'السيارة', 'الغرفة']),
    (sentence: 'نشرب الماء من ____.', answer: 'الكوب', options: ['الكوب', 'الدفتر', 'الكرسي', 'القلم']),
    (sentence: 'تطير الطائرة في ____.', answer: 'السماء', options: ['السماء', 'الفصل', 'الحقيبة', 'المطبخ']),
    (sentence: 'يعيش السمك في ____.', answer: 'البحر', options: ['البحر', 'البيت', 'الملعب', 'المكتبة']),
    (sentence: 'ذهبت ليلى إلى ____ لتتعلم.', answer: 'المدرسة', options: ['المدرسة', 'الحديقة', 'المتجر', 'المزرعة']),
    (sentence: 'فتح أبي ____ بالمفتاح.', answer: 'الباب', options: ['الباب', 'الكتاب', 'الكرة', 'الوردة']),
    (sentence: 'جلست مريم على ____.', answer: 'الكرسي', options: ['الكرسي', 'الشجرة', 'القلم', 'الكوب']),
    (sentence: 'وضعت الوردة في ____.', answer: 'المزهرية', options: ['المزهرية', 'الدفتر', 'الملعب', 'الشارع']),
    (sentence: 'عاد الطفل إلى ____ بعد الدرس.', answer: 'البيت', options: ['البيت', 'البحر', 'المدرسة', 'الحديقة']),
    (sentence: 'يكتب التلميذ في ____.', answer: 'الدفتر', options: ['الدفتر', 'الملعقة', 'الكرة', 'السيارة']),
    (sentence: 'أكلت هند ____ حمراء.', answer: 'تفاحة', options: ['تفاحة', 'حقيبة', 'ممحاة', 'وسادة']),
    (sentence: 'ركب خالد ____ إلى المدرسة.', answer: 'الحافلة', options: ['الحافلة', 'الكتاب', 'القلم', 'الطاولة']),
    (sentence: 'في الشتاء نرتدي ____.', answer: 'المعطف', options: ['المعطف', 'الدفتر', 'الباب', 'الكرة']),
    (sentence: 'يساعد الطبيب ____ المرضى.', answer: 'يعالج', options: ['يعالج', 'يرسم', 'يلعب', 'ينام']),
    (sentence: 'وضعت الأم الطعام على ____.', answer: 'الطاولة', options: ['الطاولة', 'الحقيبة', 'الشجرة', 'السيارة']),
    (sentence: 'تسكن العصافير فوق ____.', answer: 'الشجرة', options: ['الشجرة', 'الكرسي', 'البحر', 'الكتاب']),
    (sentence: 'يشاهد الأطفال ____ في السماء.', answer: 'النجوم', options: ['النجوم', 'الأقلام', 'الكراسي', 'الحقائب']),
    (sentence: 'أحب أن أسمع ____ الجميل.', answer: 'الصوت', options: ['الصوت', 'الطاولة', 'المفتاح', 'الحقيبة']),
    (sentence: 'يحمل الجندي ____.', answer: 'العَلَم', options: ['العَلَم', 'الممحاة', 'الوردة', 'الملعقة']),
    (sentence: 'في المكتبة نجد ____ كثيرة.', answer: 'كتباً', options: ['كتباً', 'كرات', 'تفاحات', 'أكواباً']),
    (sentence: 'في الصباح أفتح ____.', answer: 'النافذة', options: ['النافذة', 'الحقيبة', 'الكرة', 'الدفتر']),
    (sentence: 'ينظف الطفل ____ بفرشاته.', answer: 'أسنانه', options: ['أسنانه', 'حقيبته', 'كرته', 'دفتره']),
    (sentence: 'تسير السيارة في ____.', answer: 'الشارع', options: ['الشارع', 'السماء', 'البحر', 'المكتبة']),
    (sentence: 'يضع الطالب كتبه في ____.', answer: 'حقيبته', options: ['حقيبته', 'مطبخه', 'حديقته', 'سيارته']),
    (sentence: 'يحب الطفل اللعب في ____.', answer: 'الملعب', options: ['الملعب', 'المكتبة', 'المطبخ', 'الفصل']),
    (sentence: 'تشرب القطة ____.', answer: 'الحليب', options: ['الحليب', 'العصير', 'الخبز', 'الماء المالح']),
    (sentence: 'يقطف الفلاح ____ من الشجرة.', answer: 'الثمر', options: ['الثمر', 'الكتب', 'الأقلام', 'الحقائب']),
    (sentence: 'نحفظ النقود في ____.', answer: 'المحفظة', options: ['المحفظة', 'الكتاب', 'الكرة', 'الكرسي']),
    (sentence: 'أشعل أبي ____ في المساء.', answer: 'المصباح', options: ['المصباح', 'القلم', 'الباب', 'الطائرة']),
    (sentence: 'يلبس الطفل ____ في قدميه.', answer: 'الحذاء', options: ['الحذاء', 'القبعة', 'الحقيبة', 'الساعة']),
    (sentence: 'نقرأ الوقت من ____.', answer: 'الساعة', options: ['الساعة', 'الوردة', 'السبورة', 'الطاولة']),
    (sentence: 'يكتب المعلم على ____.', answer: 'السبورة', options: ['السبورة', 'الحافلة', 'الشجرة', 'الحقيبة']),
  ];

  static const _listenQuestions = <({String word, List<String> options})>[
    (word: 'مدرسة', options: ['مدرسة', 'مزرعة', 'مكتبة', 'سيارة']),
    (word: 'حديقة', options: ['حديقة', 'حقيبة', 'حافلة', 'حقيقة']),
    (word: 'مفتاح', options: ['مفتاح', 'مصباح', 'مطرقة', 'مخبز']),
    (word: 'سفينة', options: ['سفينة', 'مدينة', 'ساعة', 'سحابة']),
    (word: 'حصان', options: ['حصان', 'حمار', 'حصيرة', 'حيوان']),
    (word: 'برتقالة', options: ['برتقالة', 'بطاطا', 'بطيخة', 'بحيرة']),
    (word: 'كتاب', options: ['كتاب', 'كرسي', 'كلب', 'كوب']),
    (word: 'شجرة', options: ['شجرة', 'شباك', 'شعير', 'شمعة']),
    (word: 'سيارة', options: ['سيارة', 'سفينة', 'سبورة', 'ستارة']),
    (word: 'زهرة', options: ['زهرة', 'زرافة', 'زجاجة', 'زر']),
    (word: 'قلم', options: ['قلم', 'قمر', 'قميص', 'قطة']),
    (word: 'دراجة', options: ['دراجة', 'دجاجة', 'دفتر', 'دب']),
    (word: 'نافذة', options: ['نافذة', 'نجمة', 'نخلة', 'نظارة']),
    (word: 'مزرعة', options: ['مزرعة', 'مدرسة', 'مطر', 'مظلة']),
    (word: 'طائرة', options: ['طائرة', 'طاولة', 'طماطم', 'طريق']),
    (word: 'وردة', options: ['وردة', 'ورقة', 'وادي', 'وسادة']),
    (word: 'نهر', options: ['نهر', 'نجم', 'نخل', 'نمل']),
    (word: 'شمس', options: ['شمس', 'شجرة', 'شمعة', 'شريط']),
    (word: 'قمر', options: ['قمر', 'قلم', 'قلب', 'قارب']),
    (word: 'مكتبة', options: ['مكتبة', 'ممحاة', 'مزرعة', 'مغارة']),
    (word: 'ملعب', options: ['ملعب', 'مكتب', 'ملعقة', 'مفتاح']),
    (word: 'تفاحة', options: ['تفاحة', 'تمرة', 'تاج', 'تلة']),
    (word: 'سمكة', options: ['سمكة', 'سلة', 'سفينة', 'سوار']),
    (word: 'خبز', options: ['خبز', 'خاتم', 'خيمة', 'خروف']),
    (word: 'غيمة', options: ['غيمة', 'غزال', 'غرفة', 'غصن']),
    (word: 'بيت', options: ['بيت', 'باب', 'بدر', 'بستان']),
    (word: 'جمل', options: ['جمل', 'جبل', 'جزر', 'جرس']),
    (word: 'كرة', options: ['كرة', 'كرسي', 'كراسة', 'كعكة']),
    (word: 'دفتر', options: ['دفتر', 'دجاج', 'دراجة', 'دب']),
    (word: 'مصباح', options: ['مصباح', 'مفتاح', 'مسبح', 'مطار']),
    (word: 'ماء', options: ['ماء', 'موز', 'مرآة', 'مطر']),
    (word: 'سوق', options: ['سوق', 'سور', 'سيف', 'سقف']),
    (word: 'باب', options: ['باب', 'بحر', 'بستان', 'بدر']),
    (word: 'كتاب', options: ['كتاب', 'كوكب', 'كوب', 'كلب']),
  ];

  final _random = Random();
  int _mode = 0;
  int _questionIndex = 0;
  String? _answer;
  String? _feedback;
  bool _correct = false;
  Timer? _feedbackTimer;

  List<T> _shuffle<T>(List<T> values) => [...values]..shuffle(_random);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakCurrent());
  }

  @override
  void dispose() {
    _feedbackTimer?.cancel();
    VoiceService.stop();
    super.dispose();
  }

  void _speakCurrent() {
    if (_mode == 0) {
      VoiceService.arabic(_missingLetterQuestions[_questionIndex].word);
    } else if (_mode == 1) {
      VoiceService.arabic(_missingWordQuestions[_questionIndex].sentence);
    } else {
      VoiceService.arabic(_listenQuestions[_questionIndex].word);
    }
  }

  void _showFeedback(bool correct) {
    _feedbackTimer?.cancel();
    setState(() {
      _correct = correct;
      _feedback = correct ? 'أحسنت! إجابة صحيحة 🌟' : 'حاول مرة أخرى 💪';
    });
    _feedbackTimer = Timer(const Duration(milliseconds: 1300), () {
      if (mounted) setState(() => _feedback = null);
    });
  }

  void _answerQuestion(String answer, String correct) {
    final ok = answer == correct;
    setState(() => _answer = ok ? correct : answer);
    _showFeedback(ok);
    if (ok && _mode == 2) {
      Future<void>.delayed(const Duration(milliseconds: 450), () {
        if (mounted) _speakCurrent();
      });
    }
  }

  void _nextQuestion() {
    final length = _mode == 0
        ? _missingLetterQuestions.length
        : _mode == 1
            ? _missingWordQuestions.length
            : _listenQuestions.length;
    setState(() {
      _questionIndex = (_questionIndex + 1) % length;
      _answer = null;
      _feedback = null;
    });
    _speakCurrent();
  }

  void _setMode(int mode) {
    _feedbackTimer?.cancel();
    setState(() {
      _mode = mode;
      _questionIndex = 0;
      _answer = null;
      _feedback = null;
    });
    _speakCurrent();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('مهارات الحروف')),
        body: SafeArea(
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 32),
                children: [
                  _modeBar(width),
                  const SizedBox(height: 16),
                  if (_mode == 0) _missingLetterCard(),
                  if (_mode == 1) _missingWordCard(),
                  if (_mode == 2) _listenCard(),
                ],
              ),
              if (_feedback != null)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 34),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        decoration: BoxDecoration(
                          color: _correct ? const Color(0xFF43A047) : const Color(0xFFE53935),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: const [
                            BoxShadow(color: Color(0x55000000), blurRadius: 18, offset: Offset(0, 8)),
                          ],
                        ),
                        child: AnimatedScale(
                          scale: 1,
                          duration: const Duration(milliseconds: 180),
                          child: Text(
                            _feedback!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _modeBar(double width) {
    const labels = ['الحرف المفقود', 'الكلمة المفقودة', 'اسمع وأجب'];
    const colors = [Color(0xFF7C4DFF), Color(0xFFEF6C00), Color(0xFF00897B)];
    return Row(
      children: List.generate(3, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.only(end: index == 2 ? 0 : 6),
            child: Button3D(
              onTap: () => _setMode(index),
              color: colors[index],
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: width < 430 ? 12 : 14),
              child: Text(
                labels[index],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _card({required Color color, required Widget child}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: color.withValues(alpha: .28), width: 2),
      ),
      child: child,
    );
  }

  Widget _heading(String title, String subtitle, Color color) => Column(
        children: [
          Text(title, style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900, color: color)),
          const SizedBox(height: 5),
          Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        ],
      );

  Widget _missingLetterCard() {
    final q = _missingLetterQuestions[_questionIndex];
    final options = _shuffle(<String>{q.answer, 'ب', 'م', 'ن', 'ل', 'ر'}.toList());
    final shown = _answer == q.answer ? q.word : q.pattern;
    return _card(
      color: const Color(0xFF7C4DFF),
      child: Column(
        children: [
          _heading('الحرف المفقود', 'اختر الحرف الناقص ليكتمل شكل الكلمة', const Color(0xFF7C4DFF)),
          const SizedBox(height: 22),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 420),
            transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
            child: Text(
              shown,
              key: ValueKey(shown),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: 24),
          _letterOptions(options, q.answer),
          const SizedBox(height: 18),
          _nextButton('سؤال جديد', _nextQuestion),
        ],
      ),
    );
  }

  Widget _letterOptions(List<String> options, String correct) => Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 10,
        children: options
            .map(
              (letter) => SizedBox(
                width: 60,
                height: 58,
                child: Button3D(
                  onTap: () => _answerQuestion(letter, correct),
                  color: const Color(0xFF8E24AA),
                  padding: EdgeInsets.zero,
                  child: Text(letter, style: const TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w900)),
                ),
              ),
            )
            .toList(),
      );

  Widget _missingWordCard() {
    final q = _missingWordQuestions[_questionIndex];
    final shown = _answer == q.answer ? q.sentence.replaceFirst('____', q.answer) : q.sentence;
    return _card(
      color: const Color(0xFFEF6C00),
      child: Column(
        children: [
          _heading('الكلمة المفقودة', 'اختر الكلمة التي تكمل الجملة', const Color(0xFFEF6C00)),
          const SizedBox(height: 24),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 450),
            child: Container(
              key: ValueKey(shown),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: .84), borderRadius: BorderRadius.circular(20)),
              child: Text(shown, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, height: 1.5)),
            ),
          ),
          const SizedBox(height: 24),
          _wordOptions(q.answer, q.options),
          const SizedBox(height: 18),
          _nextButton('جملة جديدة', _nextQuestion),
        ],
      ),
    );
  }

  Widget _wordOptions(String correct, List<String> source) {
    final options = _shuffle(source);
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 10,
      children: options.map((word) {
        return SizedBox(
          width: 132,
          child: Button3D(
            onTap: () => _answerQuestion(word, correct),
            color: const Color(0xFFF57C00),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Text(word, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900)),
          ),
        );
      }).toList(),
    );
  }

  Widget _listenCard() {
    final q = _listenQuestions[_questionIndex];
    return _card(
      color: const Color(0xFF00897B),
      child: Column(
        children: [
          _heading('اسمع وأجب', 'استمع إلى الكلمة ثم اختر الكلمة التي سمعتها', const Color(0xFF00897B)),
          const SizedBox(height: 24),
          Button3D(
            onTap: _speakCurrent,
            color: const Color(0xFF00695C),
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.volume_up_rounded, color: Colors.white, size: 28),
                SizedBox(width: 8),
                Text('استمع مرة أخرى', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _wordOptions(q.word, q.options),
          const SizedBox(height: 18),
          _nextButton('كلمة جديدة', _nextQuestion),
        ],
      ),
    );
  }

  Widget _nextButton(String label, VoidCallback onTap) => SizedBox(
        width: 170,
        child: Button3D(
          onTap: onTap,
          color: const Color(0xFF37474F),
          padding: const EdgeInsets.symmetric(vertical: 11),
          child: Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
        ),
      );
}
