import 'package:flutter/material.dart';

import '../../data/content.dart';
import '../../core/audio/voice_service.dart';

class WordBankScreen extends StatefulWidget {
  const WordBankScreen({super.key});
  @override
  State<WordBankScreen> createState() => _S();
}

class _S extends State<WordBankScreen> {
  String filter = 'الكل';
  final cats = [
    'الكل',
    'حيوانات',
    'طعام',
    'أشياء',
    'طبيعة',
    'مواصلات',
    'جسم',
    'أشخاص',
  ];
  @override
  Widget build(BuildContext c) {
    final list = filter == 'الكل'
        ? arabicWordBank
        : arabicWordBank.where((x) => x['category'] == filter).toList();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('موسوعة الكلمات')),
        body: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              child: Row(
                children: cats
                    .map(
                      (x) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(x),
                          selected: filter == x,
                          onSelected: (_) => setState(() => filter = x),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.35,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final x = list[i];
                  return Card(
                    child: InkWell(
                      onTap: () => VoiceService.arabic(x['word']!),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              x['emoji']!,
                              style: const TextStyle(fontSize: 45),
                            ),
                            Text(
                              x['word']!,
                              style: const TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              x['syllables']!,
                              style: const TextStyle(fontSize: 17),
                            ),
                            Text(
                              x['category']!,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
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
