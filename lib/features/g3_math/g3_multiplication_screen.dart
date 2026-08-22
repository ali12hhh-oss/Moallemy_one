import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../widgets/button_3d.dart';

class G3MultiplicationScreen extends StatefulWidget {
  const G3MultiplicationScreen({super.key});
  @override
  State<G3MultiplicationScreen> createState() => _G3MultiplicationScreenState();
}

class _G3MultiplicationScreenState extends State<G3MultiplicationScreen> {
  int table = 1;
  static const colors = [
    Color(0xFF7C4DFF),
    Color(0xFF2979FF),
    Color(0xFFFF6B35),
    Color(0xFF00C853),
    Color(0xFFFF1E7E),
    Color(0xFF00BFA6),
    Color(0xFFFFC107),
    Color(0xFF8E24AA),
    Color(0xFF3D5AFE),
    Color(0xFFE53935),
  ];

  @override
  Widget build(BuildContext context) {
    final color = colors[table - 1];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('جدول الضرب ١-١٠')),
        body: Column(
          children: [
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                children: List.generate(10, (i) {
                  final t = i + 1;
                  final selected = t == table;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Button3D(
                      onTap: () => setState(() => table = t),
                      color: colors[i],
                      depth: selected ? 2 : 7,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Text(
                        arNum(t),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 4),
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
                      onTap: () => VoiceService.arabic(
                        '${arNum(table)} في ${arNum(n)} يساوي ${arNum(product)}',
                      ),
                      color: color,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      child: Center(
                        child: Text(
                          text,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
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
