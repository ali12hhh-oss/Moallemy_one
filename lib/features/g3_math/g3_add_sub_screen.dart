import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../core/storage/progress_v8.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/celebration_overlay.dart';

/// جمع/طرح بأرقام حتى ٩٩٩، بصيغتين: أفقية وعمودية.
class G3AddSubScreen extends StatefulWidget {
  final bool isAddition;
  const G3AddSubScreen({super.key, required this.isAddition});

  @override
  State<G3AddSubScreen> createState() => _G3AddSubScreenState();
}

class _G3AddSubScreenState extends State<G3AddSubScreen> {
  final rnd = Random();
  bool vertical = false;
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
    if (widget.isAddition) {
      a = 100 + rnd.nextInt(700);
      b = 10 + rnd.nextInt(min(200, 999 - a));
      answer = a + b;
    } else {
      a = 200 + rnd.nextInt(700);
      b = 10 + rnd.nextInt(min(200, a - 10));
      answer = a - b;
    }
    final others = {for (var i = max(0, answer - 8); i <= answer + 8; i++) i}
      ..remove(answer);
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
        appBar: AppBar(
          title: Text(
            '${widget.isAddition ? 'الجمع' : 'الطرح'} • ${arNum(score)} ⭐',
          ),
        ),
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
                          onTap: () => setState(() => vertical = false),
                          color: !vertical
                              ? const Color(0xFF2979FF)
                              : const Color(0xFF90CAF9),
                          depth: !vertical ? 2 : 7,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const Center(
                            child: Text(
                              'أفقي',
                              style: TextStyle(
                                fontSize: 14,
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
                          onTap: () => setState(() => vertical = true),
                          color: vertical
                              ? const Color(0xFF7C4DFF)
                              : const Color(0xFFB39DDB),
                          depth: vertical ? 2 : 7,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const Center(
                            child: Text(
                              'عمودي',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (!vertical)
                    Text(
                      '${arNum(a)} $op ${arNum(b)} = ؟',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    )
                  else
                    SizedBox(
                      width: 160,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            arNum(a),
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(op, style: const TextStyle(fontSize: 26)),
                              const SizedBox(width: 8),
                              Text(
                                arNum(b),
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 3,
                            color: Colors.black87,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                          ),
                          const Text(
                            '؟',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 10),
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
                          color: widget.isAddition
                              ? const Color(0xFF00C853)
                              : const Color(0xFFFF6B35),
                          child: Center(
                            child: Text(
                              arNum(o),
                              style: const TextStyle(
                                fontSize: 26,
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
