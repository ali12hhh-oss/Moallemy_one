import 'package:flutter/material.dart';
import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../widgets/button_3d.dart';

class G2MultiplicationScreen extends StatefulWidget {
  const G2MultiplicationScreen({super.key});
  @override
  State<G2MultiplicationScreen> createState() => _G2MultiplicationScreenState();
}

class _G2MultiplicationScreenState extends State<G2MultiplicationScreen> {
  int table = 1;
  static const colors = [Color(0xFF7C4DFF), Color(0xFF2979FF), Color(0xFFFF6B35), Color(0xFF00C853), Color(0xFFFF1E7E)];

  @override
  Widget build(BuildContext context) {
    final color = colors[table - 1];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('جدول الضرب')),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 4),
            child: Row(children: [1, 2, 3, 4, 5].map((t) {
              final selected = t == table;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Button3D(
                    onTap: () => setState(() => table = t),
                    color: colors[t - 1],
                    depth: selected ? 2 : 7,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(child: Text(arNum(t), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Colors.white))),
                  ),
                ),
              );
            }).toList()),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 10,
              itemBuilder: (_, i) {
                final n = i + 1;
                final product = table * n;
                final text = '${arNum(table)} × ${arNum(n)} = ${arNum(product)}';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Button3D(
                    onTap: () => VoiceService.arabic('${arNum(table)} في ${arNum(n)} يساوي ${arNum(product)}'),
                    color: color,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    child: Center(child: Text(text, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white))),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
