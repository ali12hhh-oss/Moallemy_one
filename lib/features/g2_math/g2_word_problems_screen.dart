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

class G2WordProblemsScreen extends StatefulWidget {
  const G2WordProblemsScreen({super.key});
  @override
  State<G2WordProblemsScreen> createState() => _G2WordProblemsScreenState();
}

class _G2WordProblemsScreenState extends State<G2WordProblemsScreen> {
  final rnd = Random();
  static const names = ['أحمد', 'سارة', 'علي', 'ليلى', 'يوسف', 'نور'];
  static const items = ['تفاحات 🍎', 'كرات ⚽', 'أقلام ✏️', 'نجوم ⭐', 'حلويات 🍬', 'كتب 📚'];

  late _WordProblem problem;
  late List<int> options;
  int score = 0;
  String? cheer;

  @override
  void initState() {
    super.initState();
    _next();
  }

  _WordProblem _generate() {
    final name = names[rnd.nextInt(names.length)];
    final item = items[rnd.nextInt(items.length)];
    final isAddition = rnd.nextBool();
    if (isAddition) {
      final a = 2 + rnd.nextInt(8);
      final b = 1 + rnd.nextInt(8);
      final templates = [
        'عند $name ${arNum(a)} $item، وأعطاه صديقه ${arNum(b)} $item أخرى. كم أصبح لدى $name؟',
        'اشترى $name ${arNum(a)} $item، ثم اشترى ${arNum(b)} $item أخرى. كم $item عند $name الآن؟',
      ];
      return _WordProblem(templates[rnd.nextInt(templates.length)], a + b);
    } else {
      final a = 6 + rnd.nextInt(10);
      final b = 1 + rnd.nextInt(a - 1);
      final templates = [
        'عند $name ${arNum(a)} $item، أعطى منها ${arNum(b)} لصديقه. كم بقي مع $name؟',
        'كان في السلة ${arNum(a)} $item، أكل $name منها ${arNum(b)}. كم بقي في السلة؟',
      ];
      return _WordProblem(templates[rnd.nextInt(templates.length)], a - b);
    }
  }

  void _next() {
    problem = _generate();
    final others = {for (var i = max(0, problem.answer - 4); i <= problem.answer + 4; i++) i}..remove(problem.answer);
    final list = others.toList()..shuffle(rnd);
    options = [problem.answer, ...list.take(3)]..shuffle(rnd);
    WidgetsBinding.instance.addPostFrameCallback((_) => VoiceService.arabic(problem.text));
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
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              const SizedBox(height: 10),
              Row(children: [
                IconButton(icon: const Icon(Icons.volume_up_rounded), onPressed: () => VoiceService.arabic(problem.text)),
                Expanded(child: Text(problem.text, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900), textAlign: TextAlign.center)),
              ]),
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
                      child: Center(child: Text(arNum(o), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white))),
                    );
                  }).toList(),
                ),
              ),
            ]),
          ),
          CelebrationOverlay(message: cheer),
        ]),
      ),
    );
  }
}
