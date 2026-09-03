import 'package:flutter/material.dart';
import '../../widgets/button_3d.dart';
import 'g3_add_sub_learning_screen.dart';
import 'g3_add_sub_screen.dart';

class G3AddSubHub extends StatelessWidget {
  const G3AddSubHub({super.key});

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
                Expanded(child: _section(context, true)),
                const SizedBox(height: 12),
                Expanded(child: _section(context, false)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(BuildContext context, bool addition) {
    final color = addition ? const Color(0xFF00C853) : const Color(0xFFFF6B35);
    return Card(
      elevation: 6,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        child: Column(
          children: [
            Row(children: [
              Text(addition ? '➕' : '➖', style: const TextStyle(fontSize: 36)),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(addition ? 'الجمع' : 'الطرح', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900, color: color)),
                const SizedBox(height: 2),
                const Text('آحاد وعشرات ومئات • أفقي وعمودي', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ])),
            ]),
            const SizedBox(height: 10),
            Expanded(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Expanded(child: _button(context, addition ? 'تعلم الجمع' : 'تعلم الطرح', '📚', color, () => Navigator.push(context, MaterialPageRoute(builder: (_) => G3AddSubLearningScreen(isAddition: addition))))),
              const SizedBox(width: 10),
              Expanded(child: _button(context, addition ? 'اختبار الجمع' : 'اختبار الطرح', '⭐', color.withValues(alpha: .80), () => Navigator.push(context, MaterialPageRoute(builder: (_) => G3AddSubScreen(isAddition: addition))))),
            ])),
          ],
        ),
      ),
    );
  }

  Widget _button(BuildContext context, String label, String icon, Color color, VoidCallback onTap) {
    return Button3D(
      onTap: onTap,
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(icon, style: const TextStyle(fontSize: 34)),
        const SizedBox(height: 5),
        Text(label, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: Colors.white)),
      ]),
    );
  }
}
