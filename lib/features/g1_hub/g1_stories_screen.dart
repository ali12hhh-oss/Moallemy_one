import 'package:flutter/material.dart';

import '../stories/stories_screen.dart';

class G1StoriesScreen extends StatelessWidget {
  const G1StoriesScreen({super.key});

  static const _stories = [
    (
      title: 'الأرنب الصغير والحديقة',
      emoji: '🐰',
      text:
          'كان هناك أرنب صغير اسمه نور، يعيش قرب حديقة جميلة مليئة بالخضار والفواكه. '
          'في كل صباح، كان نور يذهب إلى الحديقة ليأكل جزرة واحدة، لا أكثر، لأن أمه علّمته ألا يأخذ أكثر من حاجته. '
          'وذات يوم، رأى نور صديقه السلحفاة تحاول الوصول إلى جزرة بعيدة عنها، فسارع لمساعدتها رغم أنه كان مستعجلاً. '
          'شكرته السلحفاة، وقالت له: "المساعدة تجعل القلب سعيدًا يا نور". '
          'من يومها، أصبح نور يساعد كل أصدقائه في الحديقة، وأصبحت الحديقة مكانًا يملؤه الحب والتعاون.',
    ),
    (
      title: 'النجمة التي أضاءت الطريق',
      emoji: '⭐',
      text:
          'في ليلة مظلمة، ضلّ طائر صغير طريقه إلى عشّه، وأصابه الخوف والحزن. '
          'رأته نجمة صغيرة في السماء، فقررت أن تضيء بكل قوتها لتساعده. '
          'بدأ الطائر يتبع ضوء النجمة، خطوة بخطوة، حتى وصل أخيرًا إلى عشّه الدافئ حيث كانت أمه تنتظره بقلق. '
          'قال الطائر للنجمة: "شكرًا لك، لولا ضوؤك لبقيت تائهًا". '
          'ابتسمت النجمة وقالت: "كل ضوء صغير يمكن أن يصنع فرقًا كبيرًا في حياة أحدهم". '
          'ومنذ ذلك اليوم، صار الطائر ينظر إلى السماء كل ليلة، ويشكر النجمة الصغيرة التي أنقذته.',
    ),
    (
      title: 'يوم في مدرسة الحيوانات',
      emoji: '🏫',
      text:
          'في مدرسة خاصة للحيوانات، اجتمع القرد والفيل والبطة في أول يوم دراسي. '
          'أراد كل حيوان أن يتعلّم شيئًا جديدًا: القرد أراد أن يتعلم القراءة، والفيل أراد أن يتعلم الرسم، والبطة أرادت أن تتعلم العدّ. '
          'في البداية، شعر الفيل بالإحباط لأن قلمه كان صغيرًا جدًا بالنسبة له، فساعدته المعلمة بقلم أكبر خاص به. '
          'وتعلّمت البطة العدّ من واحد إلى عشرة وهي تعدّ إخوتها الصغار في البركة. '
          'وفي نهاية اليوم، فخر الجميع بما تعلّموه، وقالوا معًا: "كل يوم نتعلّم شيئًا جديدًا يجعلنا أقوى!"',
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
          children:
              _stories.map((s) {
                return Card(
                  child: ListTile(
                    leading: Text(
                      s.emoji,
                      style: const TextStyle(fontSize: 38),
                    ),
                    title: Text(
                      s.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      s.text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => StoryPage(
                                  s: s.title,
                                  text: s.text,
                                  emoji: s.emoji,
                                ),
                          ),
                        ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
