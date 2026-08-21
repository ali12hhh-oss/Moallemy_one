import 'package:flutter/material.dart';
import '../stories/stories_screen.dart';

class Kg2StoriesScreen extends StatelessWidget {
  const Kg2StoriesScreen({super.key});

  static const _kg2Stories = [
    (
      title: 'رحلة الحروف السعيدة',
      emoji: '🔤',
      text:
          'في يوم مشمس، قرر الحرف "ب" أن يبحث عن أصدقائه. مشى حتى قابل "ا" فقالا معًا "با". '
          'ثم قابل "ب" حرف "د" فتعانقا وصارا "بد". فرح الحرفان معًا لأنهما اكتشفا أن الحروف حين تجتمع تصنع كلمات جميلة. '
          'استمر "ب" في رحلته حتى جمع كلمات كثيرة، وعاد إلى بيته سعيدًا وهو يردد: كل حرف مهم، وكل كلمة تبدأ بخطوة صغيرة!',
    ),
    (
      title: 'مزرعة الأعداد',
      emoji: '🔢',
      text:
          'في مزرعة جميلة، كان هناك دجاجة واحدة، وبطتان، وثلاث قطط تلعب في الحديقة. '
          'عدّ الفلاح الحيوانات كل صباح: واحد، اثنان، ثلاثة... حتى وصل إلى عشرة! '
          'وفي يوم من الأيام تعلّم أن كل عشرة حيوانات تُشكّل مجموعة واحدة كبيرة، تمامًا كما تتجمع عشر نقاط لتصنع "عشرة" كاملة. '
          'من يومها، أحبّ الجميع في المزرعة العدّ معًا كل صباح!',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('القصص 📖')),
        body: ListView(
          padding: const EdgeInsets.all(14),
          children: _kg2Stories.map((s) {
            return Card(
              child: ListTile(
                leading: Text(s.emoji, style: const TextStyle(fontSize: 38)),
                title: Text(s.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(s.text, maxLines: 2, overflow: TextOverflow.ellipsis),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoryPage(s: s.title, text: s.text, emoji: s.emoji))),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
