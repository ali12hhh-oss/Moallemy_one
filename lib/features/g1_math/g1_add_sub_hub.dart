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
        appBar: AppBar(
          title: const Text('الجمع والطرح', style: TextStyle(color: Colors.white)),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Column(
              children: [
                Expanded(
                  child: _operationCard(
                    context,
                    isAddition: true,
                    title: 'الجمع',
                    subtitle: 'نتعلم كيف نضم الأشياء معًا',
                    color: const Color(0xFF00C853),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _operationCard(
                    context,
                    isAddition: false,
                    title: 'الطرح',
                    subtitle: 'نتعلم كيف نأخذ الأشياء ونعرف ما بقي',
                    color: const Color(0xFFFF6B35),
                  ),
                ),
              ],
            ),
          ),
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
                Text(isAddition ? '➕' : '➖', style: const TextStyle(fontSize: 36)),
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
                      label: isAddition ? 'تعلم الجمع' : 'تعلم الطرح',
                      icon: '📚',
                      color: color,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => G1AddSubLearningScreen(isAddition: isAddition),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _actionButton(
                      label: isAddition ? 'اختبار الجمع' : 'اختبار الطرح',
                      icon: '⭐',
                      color: color.withValues(alpha: .82),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => G1AddSubScreen(isAddition: isAddition),
                        ),
                      ),
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
          Text(icon, style: const TextStyle(fontSize: 32)),
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
