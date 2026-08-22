import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../core/storage/progress_v8.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

/// القسمة: مفهوم جديد للصف الثالث. نُدرّسها بصريًا عبر توزيع عناصر إلى
/// مجموعات متساوية، ثم نتدرّب عليها بأسئلة قسمة بسيطة (بلا باقٍ).
class G3DivisionScreen extends StatefulWidget {
  const G3DivisionScreen({super.key});
  @override
  State<G3DivisionScreen> createState() => _G3DivisionScreenState();
}

class _G3DivisionScreenState extends State<G3DivisionScreen> {
  bool learnMode = true;
  final rnd = Random();
  late int dividend, divisor, quotient;
  late List<int> options;
  int score = 0;
  String? cheer;

  static const icons = ['🍎', '⭐', '🎈', '🍬', '⚽'];
  late String icon;

  @override
  void initState() {
    super.initState();
    _generate();
  }

  void _generate() {
    divisor = 2 + rnd.nextInt(4); // 2..5
    quotient = 2 + rnd.nextInt(5); // 2..6
    dividend = divisor * quotient;
    icon = icons[rnd.nextInt(icons.length)];
    final others = {
      for (var i = max(1, quotient - 3); i <= quotient + 3; i++) i,
    }..remove(quotient);
    final list = others.toList()..shuffle(rnd);
    options = [quotient, ...list.take(3)]..shuffle(rnd);
  }

  void _answer(int chosen) {
    if (chosen == quotient) {
      score++;
      setState(() => cheer = kCheers[rnd.nextInt(kCheers.length)]);
      ProgressV8.addRewards(stars: 1, xp: 5);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => cheer = null);
          _generate();
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
        appBar: AppBar(title: Text('القسمة • ${arNum(score)} ⭐')),
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          'عندنا ${arNum(dividend)} $icon، ونريد توزيعها على ${arNum(divisor)} مجموعات متساوية.',
                          style: const TextStyle(fontSize: 17),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 14,
                          runSpacing: 10,
                          children: List.generate(divisor, (g) {
                            return Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Wrap(
                                spacing: 2,
                                children: List.generate(
                                  learnMode ? quotient : 0,
                                  (_) => Text(
                                    icon,
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.volume_up_rounded),
                              onPressed: () => VoiceService.arabic(
                                '${arNum(dividend)} تقسيم ${arNum(divisor)}',
                              ),
                            ),
                            Text(
                              '${arNum(dividend)} ÷ ${arNum(divisor)} = ${learnMode ? arNum(quotient) : '؟'}',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (learnMode)
                          FilledButton.icon(
                            onPressed: () => setState(() => learnMode = false),
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text('جرّب بنفسك'),
                          )
                        else
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: 2,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              children: options.map((o) {
                                return Button3D(
                                  onTap: () => _answer(o),
                                  color: const Color(0xFF00C853),
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
                ),
              ],
            ),
            CelebrationOverlay(message: cheer),
          ],
        ),
      ),
    );
  }
}
