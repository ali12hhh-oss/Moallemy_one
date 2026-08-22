import 'package:flutter/material.dart';

import '../../data/harakat.dart';
import '../../widgets/button_3d.dart';
import 'g1_haraka_screen.dart';

class G1HarakatHub extends StatelessWidget {
  const G1HarakatHub({super.key});

  static const items = <(Haraka, Color)>[
    (Haraka.fatha, Color(0xFF7C4DFF)),
    (Haraka.damma, Color(0xFF2979FF)),
    (Haraka.kasra, Color(0xFFFF1E7E)),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الحركات')),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children:
              items.map((e) {
                final h = e.$1;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Button3D(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => G1HarakaScreen(haraka: h),
                          ),
                        ),
                    color: e.$2,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 24,
                    ),
                    child: Row(
                      children: [
                        Text(
                          '◌${h.mark}',
                          style: const TextStyle(
                            fontSize: 44,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                h.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 3),
                              const Text(
                                'كل الحروف بهذه الحركة، وكلمات ممدودة',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
