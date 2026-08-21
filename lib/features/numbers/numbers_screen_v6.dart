import 'package:flutter/material.dart';
import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';

class NumbersScreenV6 extends StatelessWidget {
  final int start;
  final int end;
  const NumbersScreenV6({super.key, this.start = 0, this.end = 100});

  @override
  Widget build(BuildContext context) {
    final count = end - start + 1;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('الأرقام ${arNum(start)}–${arNum(end)}')),
        body: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10),
          itemCount: count,
          itemBuilder: (_, i) {
            final n = start + i;
            return Card(
              child: InkWell(
                onTap: () => VoiceService.arabic(_numberName(n)),
                child: Center(child: Text(arNum(n), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold))),
              ),
            );
          },
        ),
      ),
    );
  }

  static String _numberName(int n) {
    const names = <int, String>{
      0: 'صفر', 1: 'واحد', 2: 'اثنان', 3: 'ثلاثة', 4: 'أربعة', 5: 'خمسة', 6: 'ستة', 7: 'سبعة', 8: 'ثمانية', 9: 'تسعة', 10: 'عشرة',
    };
    return names[n] ?? n.toString();
  }
}
