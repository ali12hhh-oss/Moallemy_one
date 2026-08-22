import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../core/storage/progress_v8.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

class G2CompareOrderScreen extends StatefulWidget {
  const G2CompareOrderScreen({super.key});
  @override
  State<G2CompareOrderScreen> createState() => _G2CompareOrderScreenState();
}

class _G2CompareOrderScreenState extends State<G2CompareOrderScreen> {
  bool compareMode = true;
  final rnd = Random();
  int score = 0;
  String? cheer;

  // وضع المقارنة
  late int x, y;
  // وضع الترتيب
  late List<int> shuffled;
  late List<int> correctOrder;
  late List<int> chosen;
  late bool ascending;

  @override
  void initState() {
    super.initState();
    _nextCompare();
    _nextOrder();
  }

  void _nextCompare() {
    x = 1 + rnd.nextInt(99);
    y = 1 + rnd.nextInt(99);
    while (y == x) {
      y = 1 + rnd.nextInt(99);
    }
  }

  void _nextOrder() {
    ascending = rnd.nextBool();
    final set = <int>{};
    while (set.length < 4) {
      set.add(1 + rnd.nextInt(99));
    }
    correctOrder = set.toList()..sort((p, q) => ascending ? p.compareTo(q) : q.compareTo(p));
    shuffled = [...correctOrder]..shuffle(rnd);
    chosen = [];
  }

  void _answerCompare(bool pickedX) {
    final correct = pickedX ? x > y : y > x;
    if (correct) {
      score++;
      setState(() => cheer = kCheers[rnd.nextInt(kCheers.length)]);
      ProgressV8.addRewards(stars: 1, xp: 5);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => cheer = null);
          _nextCompare();
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

  void _pickOrder(int n) {
    if (chosen.length >= correctOrder.length) return;
    final expected = correctOrder[chosen.length];
    VoiceService.arabic(arNum(n));
    if (n == expected) {
      setState(() => chosen.add(n));
      if (chosen.length == correctOrder.length) {
        score++;
        setState(() => cheer = kCheers[rnd.nextInt(kCheers.length)]);
        ProgressV8.addRewards(stars: 1, xp: 5);
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() => cheer = null);
            _nextOrder();
          }
        });
      }
    } else {
      setState(() => cheer = 'حاول مرة أخرى 💪');
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) setState(() => cheer = null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('المقارنة والترتيب • ${arNum(score)} ⭐')),
        body: Stack(children: [
          Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
              child: Row(children: [
                Expanded(
                  child: Button3D(
                    onTap: () => setState(() => compareMode = true),
                    color: compareMode ? const Color(0xFF2979FF) : const Color(0xFF90CAF9),
                    depth: compareMode ? 2 : 7,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: const Center(child: Text('أكبر أم أصغر', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white))),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Button3D(
                    onTap: () => setState(() => compareMode = false),
                    color: !compareMode ? const Color(0xFF7C4DFF) : const Color(0xFFB39DDB),
                    depth: !compareMode ? 2 : 7,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: const Center(child: Text('الترتيب', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white))),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 20),
            if (compareMode)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                  child: Column(children: [
                    const Text('أي عدد أكبر؟', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    IconButton(
                      icon: const Icon(Icons.volume_up_rounded),
                      onPressed: () => VoiceService.arabic('${arNum(x)}، أم ${arNum(y)}؟'),
                    ),
                    const SizedBox(height: 16),
                    Row(children: [
                      Expanded(
                        child: Button3D(
                          onTap: () => _answerCompare(true),
                          color: const Color(0xFF00C853),
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Center(child: Text(arNum(x), style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white))),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Button3D(
                          onTap: () => _answerCompare(false),
                          color: const Color(0xFFFF6B35),
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Center(child: Text(arNum(y), style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white))),
                        ),
                      ),
                    ]),
                  ]),
                ),
              )
            else
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    Text(ascending ? 'رتّب الأعداد من الأصغر إلى الأكبر' : 'رتّب الأعداد من الأكبر إلى الأصغر', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    Wrap(spacing: 10, children: chosen.map((n) => Chip(label: Text(arNum(n), style: const TextStyle(fontSize: 18)))).toList()),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 14,
                      runSpacing: 14,
                      children: shuffled.where((n) => !chosen.contains(n)).map((n) {
                        return Button3D(
                          onTap: () => _pickOrder(n),
                          color: const Color(0xFF7C4DFF),
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                          child: Text(arNum(n), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white)),
                        );
                      }).toList(),
                    ),
                  ]),
                ),
              ),
          ]),
          CelebrationOverlay(message: cheer),
        ]),
      ),
    );
  }
}
