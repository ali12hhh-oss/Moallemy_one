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
  static const _missingLetterQuestions = <({String word, int missingIndex, String answer})>[
    (word: 'كتاب', missingIndex: 1, answer: 'ت'),
    (word: 'قلم', missingIndex: 1, answer: 'ل'),
    (word: 'مدرسة', missingIndex: 1, answer: 'د'),
    (word: 'شجرة', missingIndex: 1, answer: 'ج'),
    (word: 'نهر', missingIndex: 1, answer: 'ه'),
    (word: 'بيت', missingIndex: 1, answer: 'ي'),
    (word: 'جمل', missingIndex: 1, answer: 'م'),
    (word: 'تفاح', missingIndex: 1, answer: 'ف'),
    (word: 'بحر', missingIndex: 1, answer: 'ح'),
    (word: 'زهرة', missingIndex: 1, answer: 'ه'),
    (word: 'سفينة', missingIndex: 1, answer: 'ف'),
    (word: 'مفتاح', missingIndex: 1, answer: 'ف'),
    (word: 'سيارة', missingIndex: 1, answer: 'ي'),
    (word: 'حديقة', missingIndex: 1, answer: 'د'),
    (word: 'دفتر', missingIndex: 1, answer: 'ف'),
    (word: 'كرسي', missingIndex: 1, answer: 'ر'),
    (word: 'طائرة', missingIndex: 1, answer: 'ا'),
    (word: 'مكتبة', missingIndex: 1, answer: 'ك'),
    (word: 'وردة', missingIndex: 1, answer: 'ر'),
    (word: 'قطة', missingIndex: 1, answer: 'ط'),
    (word: 'كلب', missingIndex: 1, answer: 'ل'),
    (word: 'باب', missingIndex: 1, answer: 'ا'),
    (word: 'قمر', missingIndex: 1, answer: 'م'),
    (word: 'علم', missingIndex: 1, answer: 'ل'),
    (word: 'ورد', missingIndex: 1, answer: 'ر'),
    (word: 'صيف', missingIndex: 1, answer: 'ي'),
    (word: 'خبز', missingIndex: 1, answer: 'ب'),
    (word: 'عنب', missingIndex: 1, answer: 'ن'),
    (word: 'لون', missingIndex: 1, answer: 'و'),
    (word: 'سهم', missingIndex: 1, answer: 'ه'),
    (word: 'نعمة', missingIndex: 1, answer: 'ع'),
    (word: 'شمس', missingIndex: 1, answer: 'م'),
    (word: 'حصان', missingIndex: 1, answer: 'ص'),
    (word: 'فصل', missingIndex: 1, answer: 'ص'),
    (word: 'مطار', missingIndex: 1, answer: 'ط'),
    (word: 'مزرعة', missingIndex: 1, answer: 'ز'),
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
    (sentence: 'وضعت الأم الطعام على ____.', answer: 'الطاولة', options: ['الطاولة', 'الحقيبة', 'الشجرة', 'السيارة']),
    (sentence: 'تسكن العصافير فوق ____.', answer: 'الشجرة', options: ['الشجرة', 'الكرسي', 'البحر', 'الكتاب']),
    (sentence: 'يشاهد الأطفال ____ في السماء.', answer: 'النجوم', options: ['النجوم', 'الأقلام', 'الكراسي', 'الحقائب']),
    (sentence: 'أحب أن أسمع ____ الجميل.', answer: 'الصوت', options: ['الصوت', 'الطاولة', 'المفتاح', 'الحقيبة']),
    (sentence: 'يحمل الجندي ____.', answer: 'العلم', options: ['العلم', 'الممحاة', 'الوردة', 'الملعقة']),
    (sentence: 'في المكتبة نجد ____ كثيرة.', answer: 'كتباً', options: ['كتباً', 'كرات', 'تفاحات', 'أكواباً']),
    (sentence: 'في الصباح أفتح ____.', answer: 'النافذة', options: ['النافذة', 'الحقيبة', 'الكرة', 'الدفتر']),
    (sentence: 'ينظف الطفل ____ بفرشاته.', answer: 'أسنانه', options: ['أسنانه', 'حقيبته', 'كرته', 'دفتره']),
    (sentence: 'تسير السيارة في ____.', answer: 'الشارع', options: ['الشارع', 'السماء', 'البحر', 'المكتبة']),
    (sentence: 'يضع الطالب كتبه في ____.', answer: 'حقيبته', options: ['حقيبته', 'مطبخه', 'حديقته', 'سيارته']),
    (sentence: 'يحب الطفل اللعب في ____.', answer: 'الملعب', options: ['الملعب', 'المكتبة', 'المطبخ', 'الفصل']),
    (sentence: 'تشرب القطة ____.', answer: 'الحليب', options: ['الحليب', 'العصير', 'الخبز', 'الماء']),
    (sentence: 'يقطف الفلاح ____ من الشجرة.', answer: 'الثمر', options: ['الثمر', 'الكتب', 'الأقلام', 'الحقائب']),
    (sentence: 'نحفظ النقود في ____.', answer: 'المحفظة', options: ['المحفظة', 'الكتاب', 'الكرة', 'الكرسي']),
    (sentence: 'أشعل أبي ____ في المساء.', answer: 'المصباح', options: ['المصباح', 'القلم', 'الباب', 'الطائرة']),
    (sentence: 'يلبس الطفل ____ في قدميه.', answer: 'الحذاء', options: ['الحذاء', 'القبعة', 'الحقيبة', 'الساعة']),
    (sentence: 'نقرأ الوقت من ____.', answer: 'الساعة', options: ['الساعة', 'الوردة', 'السبورة', 'الطاولة']),
    (sentence: 'يكتب المعلم على ____.', answer: 'السبورة', options: ['السبورة', 'الحافلة', 'الشجرة', 'الحقيبة']),
    (sentence: 'يحفظ الطفل أغراضه في ____.', answer: 'الصندوق', options: ['الصندوق', 'البحر', 'الشارع', 'الحديقة']),
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
  ];

  static const _sortWords = <List<String>>[
    ['ك', 'ت', 'ا', 'ب'], ['ق', 'ل', 'م'], ['ب', 'ي', 'ت'], ['ج', 'م', 'ل'],
    ['ن', 'ه', 'ر'], ['و', 'ر', 'د'], ['ق', 'م', 'ر'], ['ع', 'ل', 'م'],
    ['س', 'م', 'ك'], ['ب', 'ا', 'ب'], ['ق', 'ط', 'ة'], ['ك', 'ل', 'ب'],
    ['و', 'ر', 'د', 'ة'], ['ش', 'ج', 'ر', 'ة'], ['د', 'ف', 'ت', 'ر'],
    ['ك', 'ر', 'س', 'ي'], ['م', 'ف', 'ت', 'ا', 'ح'], ['س', 'ي', 'ا', 'ر', 'ة'],
    ['ح', 'د', 'ي', 'ق', 'ة'], ['م', 'ك', 'ت', 'ب', 'ة'], ['س', 'ف', 'ي', 'ن', 'ة'],
    ['ط', 'ا', 'ئ', 'ر', 'ة'], ['م', 'د', 'ر', 'س', 'ة'], ['ح', 'ص', 'ا', 'ن'],
    ['ز', 'ه', 'ر', 'ة'], ['ت', 'ف', 'ا', 'ح'], ['م', 'ز', 'ر', 'ع', 'ة'],
    ['م', 'ص', 'ب', 'ا', 'ح'], ['ح', 'ل', 'ي', 'ب'], ['م', 'ل', 'ع', 'ب'],
  ];

  final _random = Random();
  int _mode = 0;
  int _questionIndex = 0;
  String? _selectedAnswer;
  String? _feedback;
  bool _correct = false;
  Timer? _feedbackTimer;
  Timer? _advanceTimer;
  List<String> _sortSelected = <String>[];
  List<String> _sortOptions = <String>[];
  int? _lastAnswerIndex;

  @override
  void initState() {
    super.initState();
    _sortOptions = _shuffle(_sortWords.first);
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakCurrent());
  }

  @override
  void dispose() {
    _feedbackTimer?.cancel();
    _advanceTimer?.cancel();
    VoiceService.stop();
    super.dispose();
  }

  List<T> _shuffle<T>(List<T> source) => [...source]..shuffle(_random);

  Future<void> _speakCurrent() async {
    if (!mounted) return;
    if (_mode == 0) {
      final q = _missingLetterQuestions[_questionIndex];
      await VoiceService.arabic(_questionSpeechForMissing(q));
    } else if (_mode == 1) {
      await VoiceService.arabic(_missingWordQuestions[_questionIndex].sentence.replaceAll('____', 'مكان فارغ'));
    } else if (_mode == 2) {
      await VoiceService.arabic(_listenQuestions[_questionIndex].word);
    }
  }

  String _questionSpeechForMissing(({String word, int missingIndex, String answer}) q) {
    final letters = q.word.runes.map(String.fromCharCode).toList();
    final speech = <String>[];
    for (var i = 0; i < letters.length; i++) {
      speech.add(i == q.missingIndex ? 'مكان فارغ' : letters[i]);
    }
    return speech.join(' ');
  }

  void _showFeedback(bool correct) {
    _feedbackTimer?.cancel();
    if (!mounted) return;
    setState(() {
      _correct = correct;
      _feedback = correct ? 'أحسنت! إجابة صحيحة 🌟' : 'حاول مرة أخرى 💪';
    });
    _feedbackTimer = Timer(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() => _feedback = null);
    });
  }

  void _answerQuestion(String answer, String correct) {
    if (_lastAnswerIndex == _questionIndex && _selectedAnswer == correct) return;
    final ok = answer == correct;
    setState(() {
      _selectedAnswer = answer;
      if (ok) _lastAnswerIndex = _questionIndex;
    });
    _showFeedback(ok);
    if (ok) {
      _advanceTimer?.cancel();
      _advanceTimer = Timer(const Duration(milliseconds: 1700), () {
        if (mounted) _nextQuestion(autoSpeak: true);
      });
    }
  }

  void _nextQuestion({bool autoSpeak = false}) {
    final length = switch (_mode) {
      0 => _missingLetterQuestions.length,
      1 => _missingWordQuestions.length,
      2 => _listenQuestions.length,
      _ => _sortWords.length,
    };
    _feedbackTimer?.cancel();
    _advanceTimer?.cancel();
    setState(() {
      _questionIndex = (_questionIndex + 1) % length;
      _selectedAnswer = null;
      _feedback = null;
      _sortSelected = <String>[];
      _lastAnswerIndex = null;
      if (_mode == 3) _sortOptions = _shuffle(_sortWords[_questionIndex]);
    });
    if (autoSpeak && _mode != 3) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _speakCurrent());
    }
  }

  void _setMode(int mode) {
    _feedbackTimer?.cancel();
    _advanceTimer?.cancel();
    VoiceService.stop();
    setState(() {
      _mode = mode;
      _questionIndex = 0;
      _selectedAnswer = null;
      _feedback = null;
      _sortSelected = <String>[];
      _lastAnswerIndex = null;
      if (mode == 3) _sortOptions = _shuffle(_sortWords.first);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakCurrent());
  }

  void _selectMissingLetter(String letter, ({String word, int missingIndex, String answer}) q) {
    if (_selectedAnswer == q.answer) return;
    _answerQuestion(letter, q.answer);
  }

  void _selectMissingWord(String word, ({String sentence, String answer, List<String> options}) q) {
    if (_selectedAnswer == q.answer) return;
    _answerQuestion(word, q.answer);
  }

  void _selectListenWord(String word, ({String word, List<String> options}) q) {
    if (_selectedAnswer == q.word) return;
    _answerQuestion(word, q.word);
  }

  void _selectSortLetter(String letter, List<String> target) {
    if (_sortSelected.length >= target.length) return;
    setState(() => _sortSelected.add(letter));
    if (_sortSelected.length == target.length) {
      final formed = _sortSelected.join();
      final correct = target.join();
      final ok = formed == correct;
      _showFeedback(ok);
      if (ok) {
        _advanceTimer?.cancel();
        _advanceTimer = Timer(const Duration(milliseconds: 1900), () {
          if (mounted) _nextQuestion();
        });
      }
    }
  }

  void _resetSort() {
    _feedbackTimer?.cancel();
    _advanceTimer?.cancel();
    setState(() {
      _sortSelected = <String>[];
      _feedback = null;
    });
  }

  Widget _feedbackInline() {
    final text = _feedback;
    if (text == null) return const SizedBox.shrink();
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: Padding(
        key: ValueKey(text),
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _correct ? const Color(0xFF218838) : const Color(0xFFC62828),
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('مهارات الحروف')),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 30),
            children: [
              _modeBar(width),
              const SizedBox(height: 16),
              if (_mode == 0) _missingLetterCard(),
              if (_mode == 1) _missingWordCard(),
              if (_mode == 2) _listenCard(),
              if (_mode == 3) _sortWordCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _modeBar(double width) {
    const labels = ['الحرف المفقود', 'الكلمة المفقودة', 'اسمع وأجب', 'رتب الكلمة'];
    const colors = [Color(0xFF7C4DFF), Color(0xFFEF6C00), Color(0xFF00897B), Color(0xFF1565C0)];
    return Row(
      children: List.generate(labels.length, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.only(end: index == labels.length - 1 ? 0 : 5),
            child: Button3D(
              onTap: () => _setMode(index),
              color: colors[index],
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: width < 430 ? 12 : 14),
              child: Text(labels[index], maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
            ),
          ),
        );
      }),
    );
  }

  Widget _card({required Color color, required Widget child}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: color.withValues(alpha: .25), width: 2),
      ),
      child: child,
    );
  }

  Widget _heading(String title, String subtitle, Color color) => Column(
        children: [
          Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900, color: color)),
          const SizedBox(height: 6),
          Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        ],
      );

  Widget _missingLetterCard() {
    final q = _missingLetterQuestions[_questionIndex];
    final options = _shuffle(<String>{q.answer, 'ب', 'م', 'ن', 'ل', 'ر'}.toList());
    final letters = q.word.runes.map(String.fromCharCode).toList();
    final filled = _selectedAnswer == q.answer;
    return _card(
      color: const Color(0xFF7C4DFF),
      child: Column(
        children: [
          _heading('الحرف المفقود', 'اختر الحرف ليكتمل شكل الكلمة', const Color(0xFF7C4DFF)),
          const SizedBox(height: 22),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              textDirection: TextDirection.rtl,
              children: List.generate(letters.length, (i) {
                final missing = i == q.missingIndex;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 360),
                    transitionBuilder: (child, animation) => SlideTransition(
                      position: Tween<Offset>(begin: const Offset(0, .9), end: Offset.zero).animate(animation),
                      child: FadeTransition(opacity: animation, child: child),
                    ),
                    child: missing && !filled
                        ? Container(key: const ValueKey('blank'), width: 60, height: 66, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .92), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF7C4DFF), width: 2)))
                        : Text(letters[i], key: ValueKey('${q.word}:$i:$filled'), style: const TextStyle(fontSize: 52, fontWeight: FontWeight.w900)),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 14),
          const Text('اختر الحرف الناقص', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 13),
          _letterOptions(options, q),
          _feedbackInline(),
          const SizedBox(height: 18),
          _nextButton('سؤال جديد', _nextQuestion, emphasized: true),
        ],
      ),
    );
  }

  Widget _letterOptions(List<String> options, ({String word, int missingIndex, String answer}) q) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 8,
      children: options.map((letter) {
        return SizedBox(
          width: 58,
          height: 60,
          child: Button3D(
            onTap: () => _selectMissingLetter(letter, q),
            color: const Color(0xFF8E24AA),
            padding: EdgeInsets.zero,
            child: Center(child: Text(letter, style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900))),
          ),
        );
      }).toList(),
    );
  }

  Widget _missingWordCard() {
    final q = _missingWordQuestions[_questionIndex];
    final filled = _selectedAnswer == q.answer;
    return _card(
      color: const Color(0xFFEF6C00),
      child: Column(
        children: [
          _heading('الكلمة المفقودة', 'اختر الكلمة لتكمل الجملة', const Color(0xFFEF6C00)),
          const SizedBox(height: 22),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 360),
            child: Container(
              key: ValueKey('${q.sentence}:$filled'),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 24),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: .88), borderRadius: BorderRadius.circular(22)),
              child: _sentenceView(q.sentence, filled ? q.answer : null),
            ),
          ),
          _feedbackInline(),
          const SizedBox(height: 24),
          _wordOptions(q),
          const SizedBox(height: 18),
          _nextButton('جملة جديدة', _nextQuestion, emphasized: true),
        ],
      ),
    );
  }

  Widget _sentenceView(String sentence, String? filledWord) {
    final parts = sentence.split('____');
    if (parts.length != 2) {
      return Text(sentence, textAlign: TextAlign.center, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, height: 1.5));
    }
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      textDirection: TextDirection.rtl,
      children: [
        Text(parts[0], style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, height: 1.5)),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          transitionBuilder: (child, animation) => SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, .8), end: Offset.zero).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          ),
          child: filledWord == null
              ? Container(key: const ValueKey('sentenceBlank'), width: 108, height: 52, margin: const EdgeInsets.symmetric(horizontal: 6), decoration: BoxDecoration(color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFEF6C00), width: 2)))
              : Container(key: ValueKey(filledWord), constraints: const BoxConstraints(minWidth: 96), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7), margin: const EdgeInsets.symmetric(horizontal: 6), decoration: BoxDecoration(color: const Color(0xFFFFE0B2), borderRadius: BorderRadius.circular(14)), child: Text(filledWord, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900))),
        ),
        Text(parts[1], style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, height: 1.5)),
      ],
    );
  }

  Widget _wordOptions(({String sentence, String answer, List<String> options}) q) {
    final options = _shuffle(q.options);
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: options.map((word) => SizedBox(
        width: 150,
        height: 60,
        child: Button3D(
          onTap: () => _selectMissingWord(word, q),
          color: const Color(0xFFF57C00),
          padding: EdgeInsets.zero,
          child: Center(child: Text(word, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900))),
        ),
      )).toList(),
    );
  }

  Widget _listenCard() {
    final q = _listenQuestions[_questionIndex];
    return _card(
      color: const Color(0xFF00897B),
      child: Column(
        children: [
          _heading('اسمع وأجب', 'استمع إلى الكلمة ثم اخترها من الخيارات', const Color(0xFF00897B)),
          const SizedBox(height: 24),
          Button3D(
            onTap: _speakCurrent,
            color: const Color(0xFF00695C),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
            child: const Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.volume_up_rounded, color: Colors.white, size: 30),
              SizedBox(width: 9),
              Text('استمع للكلمة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
            ]),
          ),
          const SizedBox(height: 24),
          _listenOptions(q),
          _feedbackInline(),
          const SizedBox(height: 18),
          _nextButton('كلمة جديدة', _nextQuestion, emphasized: true),
        ],
      ),
    );
  }

  Widget _listenOptions(({String word, List<String> options}) q) {
    final options = _shuffle(q.options);
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: options.map((word) => SizedBox(
        width: 150,
        height: 60,
        child: Button3D(
          onTap: () => _selectListenWord(word, q),
          color: const Color(0xFF00897B),
          padding: EdgeInsets.zero,
          child: Center(child: Text(word, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900))),
        ),
      )).toList(),
    );
  }

  Widget _sortWordCard() {
    final target = _sortWords[_questionIndex];
    final completed = _sortSelected.length == target.length;
    final formedWord = _sortSelected.join();
    return _card(
      color: const Color(0xFF1565C0),
      child: Column(
        children: [
          _heading('رتب الكلمة', 'رتّب الحروف المبعثرة لتكوين الكلمة الصحيحة', const Color(0xFF1565C0)),
          const SizedBox(height: 22),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 320),
            child: Container(
              key: ValueKey(_sortSelected.join('|')),
              constraints: const BoxConstraints(minHeight: 92),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: .9), borderRadius: BorderRadius.circular(22)),
              child: _sortSelected.isEmpty
                  ? const Center(child: Text('اختر الحروف بالترتيب', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)))
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              formedWord,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, height: 1.15),
                            ),
                          ),
                        ),
                        if (completed) _feedbackInline(),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 22),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 10,
            children: _sortOptions.asMap().entries.map((entry) {
              final letter = entry.value;
              final usedCount = _sortSelected.where((item) => item == letter).length;
              final totalCount = target.where((item) => item == letter).length;
              final enabled = usedCount < totalCount;
              return SizedBox(
                width: 64,
                height: 62,
                child: Button3D(
                  onTap: enabled ? () => _selectSortLetter(letter, target) : null,
                  color: enabled ? const Color(0xFF1976D2) : const Color(0xFF90A4AE),
                  padding: EdgeInsets.zero,
                  child: Center(child: Text(letter, style: const TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.w900))),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          _nextButton('كلمة جديدة', _nextQuestion, emphasized: true),
          const SizedBox(height: 8),
          SizedBox(
            width: 220,
            height: 52,
            child: Button3D(
              onTap: _resetSort,
              color: const Color(0xFF607D8B),
              padding: EdgeInsets.zero,
              child: const Center(child: Text('مسح الترتيب', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nextButton(String label, VoidCallback onTap, {bool emphasized = false}) => SizedBox(
        width: emphasized ? 220 : 180,
        height: emphasized ? 60 : 54,
        child: Button3D(
          onTap: onTap,
          color: emphasized ? const Color(0xFF37474F) : const Color(0xFF546E7A),
          padding: EdgeInsets.zero,
          child: Center(child: Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900))),
        ),
      );
}