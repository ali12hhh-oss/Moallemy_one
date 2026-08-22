import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../widgets/button_3d.dart';

/// شاشة **تعليمية** (وليست اختبارًا): تُعرّف الطفل بمفهوم الآحاد والعشرات.
/// آحاد = ١ إلى ٩ (رقم واحد بمفرده). عشرات = ١٠ إلى ٥٠ بالعشرات
/// (كل عشرة = عشر نقاط مجمّعة معًا)، مع النطق لكل عدد.
class Kg2PlaceValueScreen extends StatefulWidget {
  const Kg2PlaceValueScreen({super.key});
  @override
  State<Kg2PlaceValueScreen> createState() => _Kg2PlaceValueScreenState();
}

class _Kg2PlaceValueScreenState extends State<Kg2PlaceValueScreen> {
  bool onesMode = true;

  static const ones = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  static const tens = [10, 20, 30, 40, 50];

  static String _word(int n) =>
      const {
        1: 'واحد',
        2: 'اثنان',
        3: 'ثلاثة',
        4: 'أربعة',
        5: 'خمسة',
        6: 'ستة',
        7: 'سبعة',
        8: 'ثمانية',
        9: 'تسعة',
        10: 'عشرة',
        20: 'عشرون',
        30: 'ثلاثون',
        40: 'أربعون',
        50: 'خمسون',
      }[n] ??
      '$n';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('مراتب الأعداد')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Button3D(
                      onTap: () => setState(() => onesMode = true),
                      color:
                          onesMode
                              ? const Color(0xFF2979FF)
                              : const Color(0xFF90CAF9),
                      depth: onesMode ? 2 : 7,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: const Center(
                        child: Text(
                          'آحاد',
                          style: TextStyle(
                            fontSize: 18,
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
                      onTap: () => setState(() => onesMode = false),
                      color:
                          !onesMode
                              ? const Color(0xFF7C4DFF)
                              : const Color(0xFFB39DDB),
                      depth: !onesMode ? 2 : 7,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: const Center(
                        child: Text(
                          'عشرات',
                          style: TextStyle(
                            fontSize: 18,
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
            Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                onesMode
                    ? 'الآحاد أعداد من رقم واحد فقط: من ١ إلى ٩.'
                    : 'العشرات مجموعات من عشر نقاط معًا. اضغط على أي عدد لتسمعه وترى العشرات مجمّعة.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(14),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.05,
                ),
                itemCount: onesMode ? ones.length : tens.length,
                itemBuilder: (_, i) {
                  final n = onesMode ? ones[i] : tens[i];
                  return Button3D(
                    onTap:
                        () => VoiceService.arabic(
                          '$n${onesMode ? '، من الآحاد' : '، من العشرات'}',
                        ),
                    color:
                        onesMode
                            ? const Color(0xFF2979FF)
                            : const Color(0xFF7C4DFF),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          arNum(n),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _word(n),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _DotGroups(count: n, ten: !onesMode),
                      ],
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

/// تمثيل بصري: نقاط فردية للآحاد، أو "حبال" من ١٠ نقاط لكل عشرة.
class _DotGroups extends StatelessWidget {
  final int count;
  final bool ten;
  const _DotGroups({required this.count, required this.ten});

  @override
  Widget build(BuildContext context) {
    if (!ten) {
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: 3,
        children: List.generate(count, (_) => const _Dot()),
      );
    }
    final groups = count ~/ 10;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 4,
      children: List.generate(
        groups,
        (_) => Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(10, (_) => const _Dot()),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();
  @override
  Widget build(BuildContext context) => Container(
    width: 6,
    height: 6,
    margin: const EdgeInsets.symmetric(horizontal: .5),
    decoration: const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
  );
}
