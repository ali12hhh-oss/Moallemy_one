import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';

class EarlyBasicsScreen extends StatelessWidget {
  final String stageId;
  const EarlyBasicsScreen({super.key, required this.stageId});

  static const colors = <({String name, String emoji})>[
    (name: 'أحمر', emoji: '🔴'),
    (name: 'أزرق', emoji: '🔵'),
    (name: 'أصفر', emoji: '🟡'),
    (name: 'أخضر', emoji: '🟢'),
    (name: 'برتقالي', emoji: '🟠'),
    (name: 'بنفسجي', emoji: '🟣'),
  ];

  static const shapes = <({String name, String emoji})>[
    (name: 'دائرة', emoji: '⚪'),
    (name: 'مربع', emoji: '⬜'),
    (name: 'مثلث', emoji: '🔺'),
    (name: 'مستطيل', emoji: '▭'),
    (name: 'نجمة', emoji: '⭐'),
  ];

  @override
  Widget build(BuildContext context) {
    final kg1 = stageId == 'kg1';
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(kg1 ? 'أساسيات الروضة الأولى' : 'أساسيات الروضة الثانية'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Text(
                  kg1
                      ? 'نتعلم بالألوان والصور والأشكال والعد والاستماع، بدون ضغط على الطفل.'
                      : 'نراجع الأساسيات ثم ننتقل تدريجياً إلى الحروف والكلمات والكتابة.',
                  style: const TextStyle(fontSize: 18, height: 1.6),
                ),
              ),
            ),
            _section(context, 'الألوان 🎨', colors),
            _section(context, 'الأشكال 🔺', shapes),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Text('🔢', style: TextStyle(fontSize: 32)),
                title: const Text(
                  'العد والأعداد الأولى',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                subtitle: Text(
                  kg1 ? 'من ١ إلى ١٠' : 'من ١ إلى ٢٠ مع العد بالصور',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(
    BuildContext context,
    String title,
    List<({String name, String emoji})> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (_, i) => Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => VoiceService.arabic(items[i].name),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(items[i].emoji, style: const TextStyle(fontSize: 34)),
                  Text(
                    items[i].name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
