import 'package:flutter/material.dart';

import '../../widgets/button_3d.dart';
import 'g2_compare_order_learning_screen.dart';
import 'g2_compare_order_screen.dart';

class G2CompareOrderHub extends StatelessWidget {
  const G2CompareOrderHub({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('المقارنة والترتيب')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Column(
              children: [
                Expanded(
                  child: _buildSection(
                    context,
                    title: 'المقارنة',
                    icon: '⚖️',
                    color: const Color(0xFF2979FF),
                    subtitle: 'أكبر من، أصغر من، يساوي',
                    learnLabel: 'تعلم المقارنة',
                    onLearn: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const G2CompareOrderLearningScreen(
                          comparisonMode: true,
                        ),
                      ),
                    ),
                    testLabel: 'اختبار المقارنة',
                    onTest: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const G2CompareOrderScreen(
                          initialCompareMode: true,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _buildSection(
                    context,
                    title: 'الترتيب',
                    icon: '🔢',
                    color: const Color(0xFF7C4DFF),
                    subtitle: 'ترتيب الأعداد تصاعديًا وتنازليًا',
                    learnLabel: 'تعلم الترتيب',
                    onLearn: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const G2CompareOrderLearningScreen(
                          comparisonMode: false,
                        ),
                      ),
                    ),
                    testLabel: 'اختبار الترتيب',
                    onTest: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const G2CompareOrderScreen(
                          initialCompareMode: false,
                        ),
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
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
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
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
