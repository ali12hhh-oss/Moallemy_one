import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../widgets/button_3d.dart';

class G2MathNumbersScreen extends StatefulWidget {
  const G2MathNumbersScreen({super.key});
  @override
  State<G2MathNumbersScreen> createState() => _G2MathNumbersScreenState();
}

class _G2MathNumbersScreenState extends State<G2MathNumbersScreen> {
  bool placeValueMode = false;
  int page = 0; // 0..9 → كل صفحة تمثل مئة (١-١٠٠، ١٠١-٢٠٠... ٩٠١-٩٩٩)

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الأرقام ١-٩٩٩')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Button3D(
                      onTap: () => setState(() => placeValueMode = false),
                      color: !placeValueMode
                          ? const Color(0xFF2979FF)
                          : const Color(0xFF90CAF9),
                      depth: !placeValueMode ? 2 : 7,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: const Center(
                        child: Text(
                          'العدّ بالصفحات',
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
                      onTap: () => setState(() => placeValueMode = true),
                      color: placeValueMode
                          ? const Color(0xFF7C4DFF)
                          : const Color(0xFFB39DDB),
                      depth: placeValueMode ? 2 : 7,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: const Center(
                        child: Text(
                          'آحاد، عشرات، مئات',
                          style: TextStyle(
                            fontSize: 13,
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
            const SizedBox(height: 8),
            Expanded(child: placeValueMode ? _placeValueView() : _pagedGrid()),
          ],
        ),
      ),
    );
  }

  Widget _pagedGrid() {
    final start = page * 100 + 1;
    final end = page == 9 ? 999 : start + 99;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          child: Row(
            children: [
              IconButton(
                onPressed: page > 0 ? () => setState(() => page--) : null,
                icon: const Icon(Icons.arrow_forward_rounded),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '${arNum(start)} – ${arNum(end)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: page < 9 ? () => setState(() => page++) : null,
                icon: const Icon(Icons.arrow_back_rounded),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(14),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: end - start + 1,
            itemBuilder: (_, i) {
              final n = start + i;
              return Card(
                child: InkWell(
                  onTap: () => VoiceService.arabic(arNum(n)),
                  child: Center(
                    child: Text(
                      arNum(n),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _placeValueView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _section('آحاد (١-٩)', const Color(0xFF2979FF), [
          for (var i = 1; i <= 9; i++) i,
        ]),
        const SizedBox(height: 22),
        _section('عشرات (١٠-٩٠)', const Color(0xFF7C4DFF), [
          for (var i = 10; i <= 90; i += 10) i,
        ]),
        const SizedBox(height: 22),
        _section('مئات (١٠٠-٩٠٠)', const Color(0xFFFF6B35), [
          for (var i = 100; i <= 900; i += 100) i,
        ]),
      ],
    );
  }

  Widget _section(String title, Color color, List<int> numbers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: numbers.map((n) {
            return Button3D(
              onTap: () => VoiceService.arabic(arNum(n)),
              color: color,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Text(
                arNum(n),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
