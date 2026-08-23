import 'package:flutter/material.dart';

import '../../widgets/button_3d.dart';
import 'numbers_screen_v6.dart';
import 'kg2_place_value_screen.dart';

class Kg2NumbersHub extends StatelessWidget {
  const Kg2NumbersHub({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الأرقام 🔢')),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Button3D(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NumbersScreenV6(start: 1, end: 50),
                ),
              ),
              color: const Color(0xFF2979FF),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              child: const Row(
                children: [
                  Text('🔢', style: TextStyle(fontSize: 40)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الأعداد ١ – ٥٠',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'عدّ وانطق كل الأعداد من ١ إلى ٥٠',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Button3D(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Kg2PlaceValueScreen()),
              ),
              color: const Color(0xFF7C4DFF),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              child: const Row(
                children: [
                  Text('🏗️', style: TextStyle(fontSize: 40)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مراتب الأعداد',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'تعلّم الآحاد والعشرات (شرح وليس اختبار)',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
