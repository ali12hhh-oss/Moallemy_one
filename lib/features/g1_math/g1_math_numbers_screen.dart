import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/speakable_text.dart';

class G1MathNumbersScreen extends StatefulWidget {
  const G1MathNumbersScreen({super.key});
  @override
  State<G1MathNumbersScreen> createState() => _G1MathNumbersScreenState();
}

class _G1MathNumbersScreenState extends State<G1MathNumbersScreen> {
  bool placeValueMode = false;

  static String _word(int n) {
    const ones = {1: 'واحد', 2: 'اثنان', 3: 'ثلاثة', 4: 'أربعة', 5: 'خمسة', 6: 'ستة', 7: 'سبعة', 8: 'ثمانية', 9: 'تسعة'};
    const tens = {10: 'عشرة', 20: 'عشرون', 30: 'ثلاثون', 40: 'أربعون', 50: 'خمسون', 60: 'ستون', 70: 'سبعون', 80: 'ثمانون', 90: 'تسعون'};
    if (n == 100) return 'مئة';
    if (ones.containsKey(n)) return ones[n]!;
    if (tens.containsKey(n)) return tens[n]!;
    return '$n';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const SpeakableText('الأرقام ١-١٠٠', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
            child: Row(children: [
              Expanded(child: Button3D(onTap: () => setState(() => placeValueMode = false), color: !placeValueMode ? const Color(0xFF2979FF) : const Color(0xFF90CAF9), depth: !placeValueMode ? 2 : 7, padding: const EdgeInsets.symmetric(vertical: 12), child: const Center(child: Text('العدّ ١-١٠٠', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white))))),
              const SizedBox(width: 10),
              Expanded(child: Button3D(onTap: () => setState(() => placeValueMode = true), color: placeValueMode ? const Color(0xFF7C4DFF) : const Color(0xFFB39DDB), depth: placeValueMode ? 2 : 7, padding: const EdgeInsets.symmetric(vertical: 12), child: const Center(child: Text('الآحاد والعشرات والمئات', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white))))),
            ]),
          ),
          const SizedBox(height: 8),
          Expanded(child: placeValueMode ? _placeValueView() : _countingGrid()),
        ]),
      ),
    );
  }

  Widget _countingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(14),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 8, crossAxisSpacing: 8),
      itemCount: 100,
      itemBuilder: (_, i) {
        final n = i + 1;
        return Card(child: InkWell(onTap: () => VoiceService.arabic(arNum(n)), child: Center(child: Text(arNum(n), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))));
      },
    );
  }

  Widget _placeValueView() {
    return ListView(padding: const EdgeInsets.all(16), children: [
      _section('آحاد (١-٩)', 'رقم واحد بمفرده', [for (var i = 1; i <= 9; i++) i], const Color(0xFF2979FF), 1),
      const SizedBox(height: 22),
      _section('عشرات (١٠-٩٠)', 'كل عشرة أرقام تُشكّل عشرة واحدة', [for (var i = 10; i <= 90; i += 10) i], const Color(0xFF7C4DFF), 10),
      const SizedBox(height: 22),
      _section('مئات', 'عشر عشرات تُشكّل مئة واحدة كاملة!', const [100], const Color(0xFFFF6B35), 100),
    ]);
  }

  Widget _section(String title, String desc, List<int> numbers, Color color, int unit) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SpeakableText(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
      SpeakableText(desc, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
      const SizedBox(height: 10),
      Wrap(spacing: 10, runSpacing: 10, children: numbers.map((n) => Button3D(
        onTap: () => VoiceService.arabic('${arNum(n)}، ${_word(n)}'),
        color: color,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Text(arNum(n), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
      )).toList()),
    ]);
  }
}
