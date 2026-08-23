import 'package:flutter/material.dart';

import '../../core/theme/stage_colors.dart';
import '../../widgets/button_3d.dart';
import '../colors/kg1_colors_screen.dart';
import '../exam/prep_exam_screen.dart';
import '../g1_arabic/g1_arabic_hub.dart';
import '../g1_english/g1_english_hub.dart';
import '../g1_hub/g1_games_stories_hub.dart';
import '../g1_math/g1_math_hub.dart';
import '../g2_arabic/g2_arabic_hub.dart';
import '../g2_english/g2_english_hub.dart';
import '../g2_hub/g2_games_stories_hub.dart';
import '../g2_math/g2_math_hub.dart';
import '../g3_arabic/g3_arabic_hub.dart';
import '../g3_english/g3_english_hub.dart';
import '../g3_hub/g3_games_stories_hub.dart';
import '../g3_math/g3_math_hub.dart';
import '../hub/kg2_stories_games_hub.dart';
import '../letters/letters_screen.dart';
import '../letters/kg2_letters_screen.dart';
import '../numbers/numbers_screen_v6.dart';
import '../numbers/kg2_numbers_hub.dart';
import '../shapes/kg1_shapes_screen.dart';
import '../shapes/kg2_shapes_screen.dart';
import '../writing/kg1_writing_screen.dart';
import '../writing/kg2_writing_hub.dart';
import '../games/kg1_games_screen.dart';

class StageScreen extends StatelessWidget {
  final String stageId;
  const StageScreen({super.key, required this.stageId});

  static const data = {
    'kg1': ('الروضة الأولى', '٣–٤ سنوات', '🎨'),
    'kg2': ('الروضة الثانية', '٤–٥ سنوات', '🔤'),
    'prep': ('التمهيدي', '٥–٦ سنوات', '📝'),
    'g1': ('الصف الأول', '٦–٧ سنوات', '🌟'),
    'g2': ('الصف الثاني', '٧–٨ سنوات', '🚀'),
    'g3': ('الصف الثالث', '٨–٩ سنوات', '🏆'),
  };

  void open(BuildContext c, Widget w) => Navigator.push(c, MaterialPageRoute(builder: (_) => w));

  String? _imageFor(String title) {
    if (title == 'English') return 'assets/images/games/english_bg.jpg';
    if (title == 'الرياضيات' || title == 'الأرقام') return 'assets/images/games/math_bg.jpg';
    if (title == 'اللغة العربية' || title == 'الحروف' || title == 'الكتابة') return 'assets/images/games/arabic_bg.jpg';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final d = data[stageId]!;
    final color = StageColors.of(stageId);
    final cards = <Widget>[];

    void add(String title, String subtitle, String emoji, Widget page) {
      cards.add(_ActivityButton(
        title: title,
        subtitle: subtitle,
        emoji: emoji,
        color: color,
        imageAsset: _imageFor(title),
        onTap: () => open(context, page),
      ));
    }

    if (stageId == 'kg1') {
      add('الحروف', 'كل الحروف الـ٢٨: النطق والاسم مع كلمات ونطقها', '🔤', const LettersScreen());
      add('الأرقام', 'الأرقام من ١ إلى ١٠ مع النطق', '🔢', const NumbersScreenV6(start: 1, end: 10));
      add('الكتابة', 'كتابة الحروف والأرقام على الشاشة بخط عريض وواضح', '✏️', const Kg1WritingScreen());
      add('الألوان', 'كل الألوان بأسماء واضحة مع حيوان بنفس اللون', '🎨', const Kg1ColorsScreen());
      add('الأشكال', 'مربع ومثلث ودائرة ومستطيل ومنحرف وشبه منحرف', '🔷', const Kg1ShapesScreen());
      add('الألعاب', 'لعبة الحروف ولعبة الأرقام مع تشجيع', '🎮', const Kg1GamesScreen());
    } else if (stageId == 'kg2') {
      add('الحروف', 'كل حرف بأشكاله الثلاثة: أول ووسط وآخر، مع النطق', '🔤', const Kg2LettersScreen());
      add('الأرقام', 'الأعداد من ١ إلى ٥٠، ومراتب الأعداد (آحاد وعشرات)', '🔢', const Kg2NumbersHub());
      add('الكتابة', 'كتابة الحروف بأشكالها ودمجها، وكتابة الأعداد', '✏️', const Kg2WritingHub());
      add('الألوان', 'كل الألوان بأسماء واضحة مع حيوان بنفس اللون', '🎨', const Kg1ColorsScreen());
      add('الأشكال', 'كل الأشكال، بالإضافة إلى الخماسي والسداسي والمعيّن', '🔷', const Kg2ShapesScreen());
      add('القصص والألعاب', 'قصتان تعليميتان، وأربع ألعاب للحروف والأعداد', '📖', const Kg2StoriesGamesHub());
    } else if (stageId == 'prep') {
      add('ابدأ الاختبار الشامل 📝', 'حروف • أرقام • ألوان • أشكال • دمج حروف • آحاد • عشرات', '🏆', const PrepExamScreen());
    } else if (stageId == 'g1') {
      add('اللغة العربية', 'حروف وكلمات (قراءة وكتابة)، والحركات الثلاث', '📚', const G1ArabicHub());
      add('English', 'حروف صغيرة، أرقام ١-١٠، وكتابة', '🇬🇧', const G1EnglishHub());
      add('الرياضيات', 'الأرقام حتى ١٠٠، جمع وطرح، ضرب وعدّ', '🧮', const G1MathHub());
      add('ألعاب وقصص', 'ثلاث ألعاب وثلاث قصص صوتية', '🎮', const G1GamesStoriesHub());
    } else if (stageId == 'g2') {
      add('اللغة العربية', 'حروف وكلمات حتى أربعة أحرف وجمل، حركات، وقواعد اللغة', '📚', const G2ArabicHub());
      add('English', 'حروف كبيرة وصغيرة، مفردات، جمل، ضمائر، وكتابة', '🇬🇧', const G2EnglishHub());
      add('الرياضيات', 'الأرقام حتى ٩٩٩، جمع وطرح، مقارنة وترتيب، ضرب حتى ٥، مسائل كلامية', '🧮', const G2MathHub());
      add('ألعاب وقصص', 'أربع ألعاب وأربع قصص بقراءة صوتية', '🎮', const G2GamesStoriesHub());
    } else if (stageId == 'g3') {
      add('اللغة العربية', 'حروف وكلمات حتى خمسة أحرف وفقرات، وقواعد متقدمة', '📚', const G3ArabicHub());
      add('English', 'جمل is/am/are، قراءة، وكتابة جمل كاملة', '🇬🇧', const G3EnglishHub());
      add('الرياضيات', 'الأرقام حتى ٩٩٩٩، ضرب كامل، قسمة، كسور، ومسائل متنوعة', '🧮', const G3MathHub());
      add('ألعاب وقصص', 'خمس ألعاب وأربع قصص طويلة بقراءة صوتية', '🎮', const G3GamesStoriesHub());
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(d.$1)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [color, _darker(color)], begin: Alignment.topRight, end: Alignment.bottomLeft),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(children: [
                Text(d.$3, style: const TextStyle(fontSize: 45)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(d.$1, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: Colors.white)),
                  Text(d.$2, style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 6),
                  Text(stageId == 'prep' ? 'مرحلة تقييم شاملة: نراجع كل ما تعلّمه طفلك في الروضة الأولى والثانية.' : 'اختر النشاط الذي تريد أن تتعلمه اليوم.', style: const TextStyle(color: Colors.white)),
                ])),
              ]),
            ),
            const SizedBox(height: 18),
            Text(stageId == 'prep' ? 'اختبار المراجعة' : 'مواد المرحلة', style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            ...cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 12), child: c)),
          ],
        ),
      ),
    );
  }

  static Color _darker(Color c) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withLightness((hsl.lightness - .16).clamp(0.0, 1.0)).toColor();
  }
}

class _ActivityButton extends StatelessWidget {
  final String title, subtitle, emoji;
  final Color color;
  final String? imageAsset;
  final VoidCallback onTap;
  const _ActivityButton({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
    required this.imageAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(children: [
      Container(width: 52, height: 52, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .3), shape: BoxShape.circle), child: Center(child: Text(emoji, style: const TextStyle(fontSize: 25)))),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
        const SizedBox(height: 2),
        Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
      ])),
      const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.white),
    ]);

    return Button3D(
      onTap: onTap,
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: imageAsset == null
          ? content
          : ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(children: [
                Positioned.fill(child: Image.asset(imageAsset!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox.shrink())),
                Positioned.fill(child: Container(color: Colors.black.withValues(alpha: .28))),
                Padding(padding: const EdgeInsets.symmetric(vertical: 1), child: content),
              ]),
            ),
    );
  }
}
