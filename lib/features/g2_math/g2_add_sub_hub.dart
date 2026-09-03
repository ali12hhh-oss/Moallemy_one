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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Column(
              children: [
                Expanded(
                  child: _buildSection(
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
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _buildSection(
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
                ),
              ],
            ),
          ),
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
      elevation: 6,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        child: Column(
          children: [
            Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 36)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900, color: color),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _actionButton(
                      label: learnLabel,
                      icon: '📚',
                      color: color,
                      onTap: onLearn,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _actionButton(
                      label: testLabel,
                      icon: '⭐',
                      color: color.withValues(alpha: .78),
                      onTap: onTest,
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

  Widget _actionButton({
    required String label,
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Button3D(
      onTap: onTap,
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(fontSize: 34)),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
