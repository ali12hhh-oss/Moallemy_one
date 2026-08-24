import 'package:flutter/material.dart';

import '../../core/storage/app_storage.dart';
import '../../core/theme/stage_colors.dart';
import '../../models/child.dart';
import '../../widgets/button_3d.dart';
import '../exam/prep_exam_screen.dart';

class ChildRegistrationScreen extends StatefulWidget {
  const ChildRegistrationScreen({super.key});
  @override
  State<ChildRegistrationScreen> createState() =>
      _ChildRegistrationScreenState();
}

class _ChildRegistrationScreenState extends State<ChildRegistrationScreen> {
  final name = TextEditingController();
  String stageId = 'kg1';
  bool saving = false;

  static const stages = [
    ('kg1', 'الروضة الأولى', '🎨'),
    ('kg2', 'الروضة الثانية', '🔤'),
    ('g1', 'الصف الأول', '🌟'),
    ('g2', 'الصف الثاني', '🚀'),
    ('g3', 'الصف الثالث', '🏆'),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final kids = await AppStorage.getChildren();
    final active = await AppStorage.activeId();
    Child? c;
    if (active != null) {
      for (final k in kids) {
        if (k.id == active) {
          c = k;
          break;
        }
      }
    }
    c ??= kids.isEmpty ? null : kids.first;
    final loaded = c;
    if (loaded != null && mounted) {
      setState(() {
        name.text = loaded.name;
        stageId = stages
            .firstWhere((s) => s.$2 == loaded.stage, orElse: () => stages.first)
            .$1;
      });
    }
  }

  Future<void> _save() async {
    final n = name.text.trim();
    if (n.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('اكتب اسم الطفل أولاً 🌟')));
      return;
    }
    setState(() => saving = true);
    final kids = await AppStorage.getChildren();
    final active = await AppStorage.activeId();
    final selected = stages.firstWhere((s) => s.$1 == stageId).$2;
    final index = active == null ? -1 : kids.indexWhere((k) => k.id == active);
    if (index >= 0) {
      final old = kids[index];
      kids[index] = Child(
        id: old.id,
        name: n,
        age: _age(stageId),
        stage: selected,
        stars: old.stars,
        lessons: old.lessons,
        quizzes: old.quizzes,
        correct: old.correct,
        total: old.total,
        minutes: old.minutes,
        streak: old.streak,
        weakItems: old.weakItems,
      );
      await AppStorage.setActive(old.id);
    } else {
      final id = DateTime.now().microsecondsSinceEpoch.toString();
      kids.add(Child(id: id, name: n, age: _age(stageId), stage: selected));
      await AppStorage.setActive(id);
    }
    await AppStorage.saveChildren(kids);
    if (!mounted) return;
    setState(() => saving = false);
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _CelebrationDialog(name: n, stage: selected),
    );
    if (mounted) Navigator.pop(context);
  }

  int _age(String id) => switch (id) {
    'kg1' => 4,
    'kg2' => 5,
    'g1' => 7,
    'g2' => 8,
    _ => 9,
  };

  void _openPlacementTest() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PrepExamScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('تسجيل اسم البطل')),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const Text(
              'اكتب اسمك يا بطل ⭐',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text('سيظهر اسمك ومرحلتك في الصفحة الرئيسية.'),
            const SizedBox(height: 22),
            TextField(
              controller: name,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'اسم الطفل',
                prefixIcon: Icon(Icons.person_rounded),
                hintText: 'مثال: أحمد',
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'اختر مرحلتك الدراسية',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...stages.map((s) {
              final selected = stageId == s.$1;
              final color = StageColors.of(s.$1);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Button3D(
                  onTap: () => setState(() => stageId = s.$1),
                  color: color,
                  depth: selected ? 2 : 8,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Text(s.$3, style: const TextStyle(fontSize: 26)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          s.$2,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (selected)
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 6),
            Button3D(
              onTap: _openPlacementTest,
              color: const Color(0xFFFFB300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const Text('📝', style: TextStyle(fontSize: 30)),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'اختبار تحديد المستوى',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'اختبار للمرحلتين السابقتين وتمهيد للصف الأول — ليس مرحلة دراسية.',
                          style: TextStyle(fontSize: 12.5, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Button3D(
              onTap: saving ? () {} : _save,
              color: const Color(0xFF00C853),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.save_rounded, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    saving ? 'جارٍ الحفظ...' : 'حفظ والبدء 🚀',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
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

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }
}

class _CelebrationDialog extends StatefulWidget {
  final String name;
  final String stage;
  const _CelebrationDialog({required this.name, required this.stage});

  @override
  State<_CelebrationDialog> createState() => _CelebrationDialogState();
}

class _CelebrationDialogState extends State<_CelebrationDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> bounce;

  static const cheers = [
    'أحسنت يا بطل! 🎉',
    'رائع جدًا! 🌟',
    'ما شاء الله عليك! 🏆',
    'يلا نبدأ المغامرة! 🚀',
  ];

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    bounce = CurvedAnimation(parent: controller, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cheer = cheers[widget.name.length % cheers.length];
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 30),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFD54F), Color(0xFFFF7043)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: bounce,
              child: const Text('🎉⭐🎊', style: TextStyle(fontSize: 46)),
            ),
            const SizedBox(height: 14),
            Text(
              cheer,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'تم حفظ اسم ${widget.name} في ${widget.stage} 🌟\nسنحفظ تقدمك مع كل نشاط.',
              style: const TextStyle(color: Colors.white, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 22),
            Button3D(
              onTap: () => Navigator.pop(context),
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: const Center(
                child: Text(
                  'هيا نبدأ!',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFFF7043),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
