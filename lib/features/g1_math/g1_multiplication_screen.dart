import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../widgets/button_3d.dart';

class G1MultiplicationScreen extends StatefulWidget {
  const G1MultiplicationScreen({super.key});
  @override
  State<G1MultiplicationScreen> createState() => _G1MultiplicationScreenState();
}

class _G1MultiplicationScreenState extends State<G1MultiplicationScreen> {
  int table = 1;
  static const colors = [
    Color(0xFF7C4DFF),
    Color(0xFF2979FF),
    Color(0xFFFF6B35),
  ];

  @override
  Widget build(BuildContext context) {
    final color = colors[table - 1];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('جدول الضرب')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
              child: Row(
                children:
                    [1, 2, 3].map((t) {
                      final selected = t == table;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Button3D(
                            onTap: () => setState(() => table = t),
                            color: colors[t - 1],
                            depth: selected ? 2 : 7,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: Text(
                                'جدول ${arNum(t)}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 10,
                itemBuilder: (_, i) {
                  final n = i + 1;
                  final product = table * n;
                  final text =
                      '${arNum(table)} × ${arNum(n)} = ${arNum(product)}';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Button3D(
                      onTap:
                          () => VoiceService.arabic(
                            '${arNum(table)} في ${arNum(n)} يساوي ${arNum(product)}',
                          ),
                      color: color,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            text,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
