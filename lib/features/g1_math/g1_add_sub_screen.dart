import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../core/storage/progress_v8.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

/// شاشة جمع/طرح بصرية: تُعرض الفواكه ليعدّها الطفل ويتعلّم من خلال العدّ
/// الحسّي بدل الأرقام المجرّدة وحدها. الناتج لا يتجاوز ١٠ دائمًا.
class G1AddSubScreen extends StatefulWidget {
  final bool isAddition;
  const G1AddSubScreen({super.key, required this.isAddition});

  @override
  State<G1AddSubScreen> createState() => _G1AddSubScreenState();
}

class _G1AddSubScreenState extends State<G1AddSubScreen> {
  final rnd = Random();
  static const fruits = ['🍎', '🍌', '🍊', '🍇', '🍓'];
  late String fruit;
  late int a, b, answer;
  late List<int> options;
  int score = 0;
  String? cheer;

  @override
  void initState() {
    super.initState();
    _next();
  }

  void _next() {
    fruit = fruits[rnd.nextInt(fruits.length)];
    if (widget.isAddition) {
      // a + b <= 10
      a = 1 + rnd.nextInt(8);
      b = 1 + rnd.nextInt(10 - a);
      answer = a + b;
    } else {
      // a <= 10, b <= a, a - b الناتج ضمن حدود منطقية
      a = 2 + rnd.nextInt(9); // 2..10
      b = 1 + rnd.nextInt(a);
      answer = a - b;
    }
    final others = {for (var i = 0; i <= 10; i++) i}..remove(answer);
    final list = others.toList()..shuffle(rnd);
    options = [answer, ...list.take(3)]..shuffle(rnd);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final op = widget.isAddition ? 'زائد' : 'ناقص';
      VoiceService.arabic('${arNum(a)} $op ${arNum(b)}، كم الناتج؟');
    });
  }

  void _answer(int chosen) {
    if (chosen == answer) {
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
  }

  @override
  Widget build(BuildContext context) {
    final op = widget.isAddition ? '+' : '−';
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('${widget.isAddition ? 'الجمع' : 'الطرح'} • ${arNum(score)} ⭐')),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(children: [
              // المجموعة الأولى: a من الفاكهة.
              Wrap(alignment: WrapAlignment.center, spacing: 6, children: List.generate(a, (i) {
                final crossed = !widget.isAddition && i < b;
                return Stack(alignment: Alignment.center, children: [
                  Text(fruit, style: TextStyle(fontSize: 34, color: crossed ? Colors.grey.withValues(alpha: .4) : null)),
                  if (crossed) const Icon(Icons.close_rounded, color: Colors.red, size: 30),
                ]);
              })),
              const SizedBox(height: 10),
              if (widget.isAddition) ...[
                const Text('+', style: TextStyle(fontSize: 26)),
                const SizedBox(height: 6),
                Wrap(alignment: WrapAlignment.center, spacing: 6, children: List.generate(b, (_) => Text(fruit, style: const TextStyle(fontSize: 34)))),
              ],
              const SizedBox(height: 16),
              Text('${arNum(a)} $op ${arNum(b)} = ؟', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              IconButton(
                icon: const Icon(Icons.volume_up_rounded),
                onPressed: () {
                  final opWord = widget.isAddition ? 'زائد' : 'ناقص';
                  VoiceService.arabic('${arNum(a)} $opWord ${arNum(b)}');
                },
              ),
              const SizedBox(height: 8),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  children: options.map((o) {
                    return Button3D(
                      onTap: () => _answer(o),
                      color: widget.isAddition ? const Color(0xFF00C853) : const Color(0xFFFF6B35),
                      child: Center(child: Text(arNum(o), style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Colors.white))),
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
