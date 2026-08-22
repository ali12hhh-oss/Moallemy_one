import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../core/storage/progress_v8.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

class _WordProblem {
  final String text;
  final int answer;
  const _WordProblem(this.text, this.answer);
}

/// بنك مسائل كلامية كبير للصف الثالث: جمع، طرح، ضرب، وقسمة، بأسماء وعناصر
/// وأرقام عشوائية في كل مرة — ما يعطي عمليًا مسائل لا نهائية التنوّع.
class G3WordProblemsScreen extends StatefulWidget {
  const G3WordProblemsScreen({super.key});
  @override
  State<G3WordProblemsScreen> createState() => _G3WordProblemsScreenState();
}

class _G3WordProblemsScreenState extends State<G3WordProblemsScreen> {
  final rnd = Random();
  static const names = [
    'أحمد',
    'سارة',
    'علي',
    'ليلى',
    'يوسف',
    'نور',
    'مريم',
    'خالد',
    'زينب',
    'حسن',
    'هدى',
    'كريم',
  ];
  static const items = [
    'تفاحات 🍎',
    'كرات ⚽',
    'أقلام ✏️',
    'نجوم ⭐',
    'حلويات 🍬',
    'كتب 📚',
    'ورودًا 🌹',
    'بيضًا 🥚',
    'أقراصًا 🍪',
    'بالونات 🎈',
  ];
  static const boxItems = ['علب', 'أكياس', 'سلال', 'صناديق'];

  late _WordProblem problem;
  late List<int> options;
  int score = 0;
  String? cheer;

  @override
  void initState() {
    super.initState();
    _next();
  }

  String _name() => names[rnd.nextInt(names.length)];
  String _item() => items[rnd.nextInt(items.length)];

  _WordProblem _additionProblem() {
    final name = _name(), item = _item();
    final a = 20 + rnd.nextInt(60);
    final b = 10 + rnd.nextInt(40);
    final templates = [
      'عند $name ${arNum(a)} $item، وأعطاه صديقه ${arNum(b)} $item أخرى. كم أصبح لدى $name؟',
      'اشترى $name ${arNum(a)} $item، ثم اشترى ${arNum(b)} $item أخرى. كم $item عند $name الآن؟',
      'في الصف الأول ${arNum(a)} طالبًا، وفي الصف الثاني ${arNum(b)} طالبًا. كم عدد الطلاب في الصفين معًا؟',
      'جمع $name ${arNum(a)} $item يوم السبت، و${arNum(b)} $item يوم الأحد. كم المجموع؟',
    ];
    return _WordProblem(templates[rnd.nextInt(templates.length)], a + b);
  }

  _WordProblem _subtractionProblem() {
    final name = _name(), item = _item();
    final a = 60 + rnd.nextInt(100);
    final b = 10 + rnd.nextInt(a - 10);
    final templates = [
      'عند $name ${arNum(a)} $item، أعطى منها ${arNum(b)} لصديقه. كم بقي مع $name؟',
      'كان في السلة ${arNum(a)} $item، أخذ $name منها ${arNum(b)}. كم بقي في السلة؟',
      'كان عند البائع ${arNum(a)} $item، باع منها ${arNum(b)}. كم بقي عنده؟',
      'ادّخر $name ${arNum(a)} ريالًا، وأنفق ${arNum(b)} ريالًا. كم تبقّى معه؟',
    ];
    return _WordProblem(templates[rnd.nextInt(templates.length)], a - b);
  }

  _WordProblem _multiplicationProblem() {
    final name = _name(),
        item = _item(),
        box = boxItems[rnd.nextInt(boxItems.length)];
    final groups = 2 + rnd.nextInt(8); // 2..9
    final perGroup = 2 + rnd.nextInt(9); // 2..10
    final templates = [
      'عند $name ${arNum(groups)} $box، في كل واحد منها ${arNum(perGroup)} $item. كم المجموع الكلي؟',
      'اشترى $name ${arNum(groups)} صناديق، في كل صندوق ${arNum(perGroup)} $item. كم عدد $item عنده؟',
      'في الحفلة ${arNum(groups)} طاولات، على كل طاولة ${arNum(perGroup)} كراسٍ. كم عدد الكراسي؟',
    ];
    return _WordProblem(
      templates[rnd.nextInt(templates.length)],
      groups * perGroup,
    );
  }

  _WordProblem _divisionProblem() {
    final name = _name(),
        item = _item(),
        box = boxItems[rnd.nextInt(boxItems.length)];
    final divisor = 2 + rnd.nextInt(5); // 2..6
    final quotient = 2 + rnd.nextInt(8); // 2..9
    final total = divisor * quotient;
    final templates = [
      'عند $name ${arNum(total)} $item، يريد توزيعها بالتساوي على ${arNum(divisor)} $box. كم يضع في كل واحد؟',
      'في الصف ${arNum(total)} طالبًا، قُسّموا إلى ${arNum(divisor)} مجموعات متساوية. كم عدد كل مجموعة؟',
      'لدى المعلمة ${arNum(total)} $item، وزّعتها بالتساوي على ${arNum(divisor)} طلاب. كم نصيب كل طالب؟',
    ];
    return _WordProblem(templates[rnd.nextInt(templates.length)], quotient);
  }

  _WordProblem _generate() {
    final kind = rnd.nextInt(4);
    return switch (kind) {
      0 => _additionProblem(),
      1 => _subtractionProblem(),
      2 => _multiplicationProblem(),
      _ => _divisionProblem(),
    };
  }

  void _next() {
    problem = _generate();
    final others = {
      for (var i = max(0, problem.answer - 6); i <= problem.answer + 6; i++) i,
    }..remove(problem.answer);
    final list = others.toList()..shuffle(rnd);
    options = [problem.answer, ...list.take(3)]..shuffle(rnd);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => VoiceService.arabic(problem.text),
    );
  }

  void _answer(int chosen) {
    if (chosen == problem.answer) {
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
        appBar: AppBar(title: Text('مسائل كلامية • ${arNum(score)} ⭐')),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.volume_up_rounded),
                        onPressed: () => VoiceService.arabic(problem.text),
                      ),
                      Expanded(
                        child: Text(
                          problem.text,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      children: options.map((o) {
                        return Button3D(
                          onTap: () => _answer(o),
                          color: const Color(0xFF7C4DFF),
                          child: Center(
                            child: Text(
                              arNum(o),
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
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
