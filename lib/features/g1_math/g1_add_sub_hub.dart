import 'package:flutter/material.dart';

import '../../widgets/button_3d.dart';
import 'g1_add_sub_learning_screen.dart';
import 'g1_add_sub_screen.dart';

class G1AddSubHub extends StatelessWidget {
  const G1AddSubHub({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الجمع والطرح', style: TextStyle(color: Colors.white))),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            _operationCard(
              context,
              isAddition: true,
              title: 'الجمع',
              subtitle: 'نتعلم كيف نضم الأشياء معًا',
              color: const Color(0xFF00C853),
            ),
            const SizedBox(height: 18),
            _operationCard(
              context,
              isAddition: false,
              title: 'الطرح',
              subtitle: 'نتعلم كيف نأخذ الأشياء ونعرف ما بقي',
              color: const Color(0xFFFF6B35),
            ),
          ],
        ),
      ),
    );
  }

  Widget _operationCard(
    BuildContext context, {
    required bool isAddition,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    final symbol = isAddition ? '➕' : '➖';

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text(symbol, style: const TextStyle(fontSize: 42)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: color)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Button3D(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => G1AddSubLearningScreen(isAddition: isAddition),
                      ),
                    ),
                    color: color,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 17),
                    child: Text(
                      isAddition ? 'تعلم الجمع' : 'تعلم الطرح',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Button3D(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => G1AddSubScreen(isAddition: isAddition),
                      ),
                    ),
                    color: color.withValues(alpha: .82),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 17),
                    child: Text(
                      isAddition ? 'اختبار الجمع' : 'اختبار الطرح',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
