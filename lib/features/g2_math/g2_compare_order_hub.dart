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
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Expanded(child: _section(context, 'المقارنة', 'أكبر، أصغر، يساوي', const Color(0xFF2979FF), true)),
                const SizedBox(height: 12),
                Expanded(child: _section(context, 'الترتيب', 'تصاعدي وتنازلي', const Color(0xFF7C4DFF), false)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(BuildContext context, String title, String subtitle, Color color, bool comparison) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 14)),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: _button(
                    '📚  تدرب',
                    color,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => G2CompareOrderLearningScreen(comparisonMode: comparison)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _button(
                    '⭐  اختبار',
                    color,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => G2CompareOrderScreen()),
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

  Widget _button(String text, Color color, VoidCallback onTap) {
    return Button3D(
      onTap: onTap,
      color: color,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15)),
      ),
    );
  }
}
