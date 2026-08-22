import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../core/storage/progress_v8.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

/// لعبة إكمال السلسلة: تُعرض ثلاثة أعداد متتالية صعودًا أو نزولًا، ويختار
/// الطفل العدد الرابع الصحيح الذي يكمل التسلسل.
class G1CountingScreen extends StatefulWidget {
  const G1CountingScreen({super.key});
  @override
  State<G1CountingScreen> createState() => _G1CountingScreenState();
}

class _G1CountingScreenState extends State<G1CountingScreen> {
  final rnd = Random();
  bool ascending = true;
  late List<int> sequence;
  late int answer;
  late List<int> options;
  int score = 0;
  String? cheer;

  @override
  void initState() {
    super.initState();
    _next();
  }

  void _switch(bool asc) {
    setState(() => ascending = asc);
    _next();
  }

  void _next() {
    final start = ascending ? 1 + rnd.nextInt(15) : 20 - rnd.nextInt(15);
    sequence = List.generate(3, (i) => ascending ? start + i : start - i);
    answer = ascending ? sequence.last + 1 : sequence.last - 1;
    final others = {for (var i = max(0, answer - 3); i <= answer + 3; i++) i}
      ..remove(answer);
    final list = others.toList()..shuffle(rnd);
    options = [answer, ...list.take(3)]..shuffle(rnd);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VoiceService.arabic(
        '${sequence.map(arNum).join('، ')}... ما العدد التالي؟',
      );
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('العدّ • ${arNum(score)} ⭐')),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Button3D(
                          onTap: () => _switch(true),
                          color:
                              ascending
                                  ? const Color(0xFF00C853)
                                  : const Color(0xFFA5D6A7),
                          depth: ascending ? 2 : 7,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: const Center(
                            child: Text(
                              'تصاعدي ⬆️',
                              style: TextStyle(
                                fontSize: 15,
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
                          onTap: () => _switch(false),
                          color:
                              !ascending
                                  ? const Color(0xFFFF6B35)
                                  : const Color(0xFFFFCCBC),
                          depth: !ascending ? 2 : 7,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: const Center(
                            child: Text(
                              'تنازلي ⬇️',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    children: [
                      ...sequence.map(
                        (n) => Text(
                          arNum(n),
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const Text(
                        '؟',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    icon: const Icon(Icons.volume_up_rounded),
                    onPressed:
                        () =>
                            VoiceService.arabic(sequence.map(arNum).join('، ')),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      children:
                          options.map((o) {
                            return Button3D(
                              onTap: () => _answer(o),
                              color: const Color(0xFF2979FF),
                              child: Center(
                                child: Text(
                                  arNum(o),
                                  style: const TextStyle(
                                    fontSize: 32,
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
