import 'package:flutter/material.dart';

import '../../widgets/button_3d.dart';
import 'g2_add_sub_learning_screen.dart';
import 'g2_add_sub_screen.dart';

class G2AddSubHub extends StatelessWidget {
  const G2AddSubHub({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الجمع والطرح')),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            _buildSection(
              context,
              title: 'الجمع',
              icon: '➕',
              color: const Color(0xFF00C853),
              subtitle: 'جمع عددين من مرتبتين: آحاد وعشرات',
              learnLabel: 'تعلم الجمع',
              onLearn: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const G2AddSubLearningScreen(isAddition: true),
                ),
              ),
              testLabel: 'اختبار الجمع',
              onTest: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const G2AddSubScreen(isAddition: true),
                ),
              ),
            ),
            const SizedBox(height: 18),
            _buildSection(
              context,
              title: 'الطرح',
              icon: '➖',
              color: const Color(0xFFFF6B35),
              subtitle: 'طرح عددين من مرتبتين: آحاد وعشرات',
              learnLabel: 'تعلم الطرح',
              onLearn: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const G2AddSubLearningScreen(isAddition: false),
                ),
              ),
              testLabel: 'اختبار الطرح',
              onTest: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const G2AddSubScreen(isAddition: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String icon,
    required Color color,
    required String subtitle,
    required String learnLabel,
    required VoidCallback onLearn,
    required String testLabel,
    required VoidCallback onTest,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 38)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Button3D(
                    onTap: onLearn,
                    color: color,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: Column(
                      children: [
                        const Text('📚', style: TextStyle(fontSize: 28)),
                        const SizedBox(height: 4),
                        Text(
                          learnLabel,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Button3D(
                    onTap: onTest,
                    color: color.withValues(alpha: .78),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: Column(
                      children: [
                        const Text('⭐', style: TextStyle(fontSize: 28)),
                        const SizedBox(height: 4),
                        Text(
                          testLabel,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                      ],
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
