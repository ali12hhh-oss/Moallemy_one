import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../widgets/button_3d.dart';

class G1CountingLearningScreen extends StatefulWidget {
  const G1CountingLearningScreen({super.key});

  @override
  State<G1CountingLearningScreen> createState() => _G1CountingLearningScreenState();
}

class _G1CountingLearningScreenState extends State<G1CountingLearningScreen> {
  int index = 0;

  static const examples = <Map<String, dynamic>>[
    {'ascending': true, 'numbers': [1, 2, 3, 4], 'text': 'نعد إلى الأمام: ١، ٢، ٣، ٤. العدد الذي بعد ٤ هو ٥.'},
    {'ascending': true, 'numbers': [2, 3, 4, 5], 'text': 'نزيد واحدًا كل مرة: ٢، ٣، ٤، ٥. العدد الذي بعد ٥ هو ٦.'},
    {'ascending': true, 'numbers': [5, 6, 7, 8], 'text': 'هذا عد تصاعدي: ٥، ٦، ٧، ٨. العدد الذي بعد ٨ هو ٩.'},
    {'ascending': true, 'numbers': [7, 8, 9, 10], 'text': 'نصعد عددًا واحدًا كل مرة: ٧، ٨، ٩، ١٠. بعد ١٠ يأتي ١١.'},
    {'ascending': false, 'numbers': [5, 4, 3, 2], 'text': 'نعد إلى الخلف: ٥، ٤، ٣، ٢. العدد الذي بعد ٢ إلى الخلف هو ١.'},
    {'ascending': false, 'numbers': [6, 5, 4, 3], 'text': 'ننقص واحدًا كل مرة: ٦، ٥، ٤، ٣. بعد ٣ إلى الخلف هو ٢.'},
    {'ascending': false, 'numbers': [9, 8, 7, 6], 'text': 'هذا عد تنازلي: ٩، ٨، ٧، ٦. العدد الذي بعد ٦ إلى الخلف هو ٥.'},
    {'ascending': false, 'numbers': [10, 9, 8, 7], 'text': 'ننزل عددًا واحدًا كل مرة: ١٠، ٩، ٨، ٧. بعد ٧ إلى الخلف هو ٦.'},
  ];

  void _speak() {
    VoiceService.arabic(examples[index]['text'] as String);
  }

  void _next() {
    if (index < examples.length - 1) {
      setState(() => index++);
      _speak();
    }
  }

  void _previous() {
    if (index > 0) {
      setState(() => index--);
      _speak();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speak());
  }

  @override
  Widget build(BuildContext context) {
    final example = examples[index];
    final ascending = example['ascending'] as bool;
    final numbers = (example['numbers'] as List<int>);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('تعلّم العد التصاعدي والتنازلي')),
        body: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Text(
                ascending ? 'العدّ التصاعدي ⬆️' : 'العدّ التنازلي ⬇️',
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Text('مثال ${arNum(index + 1)} من ${arNum(examples.length)}'),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12,
                        children: [
                          for (final n in numbers)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(width: 2),
                              ),
                              child: Text(
                                arNum(n),
                                style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        ascending ? 'نزيد ١ في كل خطوة' : 'ننقص ١ في كل خطوة',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        example['text'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 19, height: 1.5),
                      ),
                      const SizedBox(height: 18),
                      IconButton.filled(
                        iconSize: 34,
                        onPressed: _speak,
                        icon: const Icon(Icons.volume_up_rounded),
                        tooltip: 'استمع للشرح',
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Button3D(
                      onTap: index == 0 ? null : _previous,
                      color: const Color(0xFF78909C),
                      child: const Center(child: Text('السابق', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900))),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Button3D(
                      onTap: index == examples.length - 1 ? null : _next,
                      color: const Color(0xFF00BFA6),
                      child: const Center(child: Text('التالي', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900))),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}"}