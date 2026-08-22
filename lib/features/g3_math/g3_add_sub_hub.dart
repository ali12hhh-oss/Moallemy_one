import 'package:flutter/material.dart';

import '../../widgets/button_3d.dart';
import 'g3_add_sub_screen.dart';

class G3AddSubHub extends StatelessWidget {
  const G3AddSubHub({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الجمع والطرح')),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Button3D(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const G3AddSubScreen(isAddition: true),
                    ),
                  ),
              color: const Color(0xFF00C853),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              child: const Row(
                children: [
                  Text('➕', style: TextStyle(fontSize: 40)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الجمع',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'أفقي وعمودي، بأرقام حتى ٩٩٩',
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
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const G3AddSubScreen(isAddition: false),
                    ),
                  ),
              color: const Color(0xFFFF6B35),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              child: const Row(
                children: [
                  Text('➖', style: TextStyle(fontSize: 40)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الطرح',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'أفقي وعمودي، بأرقام حتى ٩٩٩',
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
