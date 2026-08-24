import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

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
  final TextEditingController name = TextEditingController();

  static const int maxChildren = 2;

  static const List<(String, String, String)> avatars = [
    ('assets/images/child_avatars/boy_1.svg', 'ولد ١', 'boy'),
    ('assets/images/child_avatars/boy_2.svg', 'ولد ٢', 'boy'),
    ('assets/images/child_avatars/girl_1.svg', 'بنت ١', 'girl'),
    ('assets/images/child_avatars/girl_2.svg', 'بنت ٢', 'girl'),
  ];

  static const List<(String, String, String)> stages = [
    ('kg1', 'الروضة الأولى', '🎨'),
    ('kg2', 'الروضة الثانية', '🔤'),
    ('g1', 'الصف الأول', '🌟'),
    ('g2', 'الصف الثاني', '🚀'),
    ('g3', 'الصف الثالث', '🏆'),
  ];

  List<Child> kids = [];
  int selectedChildIndex = 0;
  String stageId = 'kg1';
  String selectedAvatar = 'assets/images/child_avatars/boy_1.svg';
  String avatarPath = '';
  bool saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final loadedKids = await AppStorage.getChildren();
    final activeId = await AppStorage.activeId();

    if (!mounted) return;

    setState(() {
      kids = loadedKids;

      if (loadedKids.isEmpty) {
        selectedChildIndex = 0;
        _resetNewChild();
        return;
      }

      var activeIndex = 0;
      if (activeId != null) {
        final index = loadedKids.indexWhere((child) => child.id == activeId);
        if (index >= 0) activeIndex = index;
      }

      selectedChildIndex = activeIndex;
      _loadChildData(loadedKids[activeIndex]);
    });
  }

  void _loadChildData(Child child) {
    name.text = child.name;

    final matchingStage =
        stages.where((stage) => stage.$2 == child.stage).toList();

    stageId = matchingStage.isEmpty
        ? stages.first.$1
        : matchingStage.first.$1;

    selectedAvatar = child.avatarAsset.isNotEmpty
        ? child.avatarAsset
        : avatars.first.$1;
    avatarPath = child.avatarPath;
  }

  void _resetNewChild() {
    name.clear();
    stageId = 'kg1';
    avatarPath = '';
    selectedAvatar = selectedChildIndex == 0 ? avatars[0].$1 : avatars[1].$1;
  }

  void _selectChild(int index) {
    if (index < 0 || index > 1) return;

    if (index == 1 && kids.length < 2) {
      setState(() {
        selectedChildIndex = 1;
        _resetNewChild();
      });
      return;
    }

    if (index >= kids.length) return;

    setState(() {
      selectedChildIndex = index;
      _loadChildData(kids[index]);
    });
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 88,
        maxWidth: 1000,
        maxHeight: 1000,
      );

      if (picked == null || !mounted) return;

      setState(() {
        avatarPath = picked.path;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذر فتح معرض الصور. حاول مرة أخرى.'),
        ),
      );
    }
  }

  Future<void> _save() async {
    final childName = name.text.trim();

    if (childName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اكتب اسم الطفل أولاً 🌟')),
      );
      return;
    }

    if (saving) return;

    setState(() => saving = true);

    try {
      final currentKids = await AppStorage.getChildren();
      final selectedStage =
          stages.firstWhere((stage) => stage.$1 == stageId).$2;

      if (selectedChildIndex < currentKids.length) {
        final old = currentKids[selectedChildIndex];

        currentKids[selectedChildIndex] = Child(
          id: old.id,
          name: childName,
          age: _age(stageId),
          stage: selectedStage,
          stars: old.stars,
          lessons: old.lessons,
          quizzes: old.quizzes,
          correct: old.correct,
          total: old.total,
          minutes: old.minutes,
          streak: old.streak,
          weakItems: List<String>.from(old.weakItems),
          ownedItems: List<String>.from(old.ownedItems),
          avatarAsset: selectedAvatar,
          avatarPath: avatarPath,
        );

        await AppStorage.setActive(old.id);
      } else {
        if (currentKids.length >= maxChildren) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('يمكن تسجيل طفلين فقط في هذا الحساب.'),
              ),
            );
          }
          return;
        }

        final id = DateTime.now().microsecondsSinceEpoch.toString();
        currentKids.add(
          Child(
            id: id,
            name: childName,
            age: _age(stageId),
            stage: selectedStage,
            avatarAsset: selectedAvatar,
            avatarPath: avatarPath,
          ),
        );

        await AppStorage.setActive(id);
      }

      await AppStorage.saveChildren(currentKids);

      if (!mounted) return;

      setState(() {
        kids = currentKids;
        saving = false;
      });

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => _CelebrationDialog(
          name: childName,
          stage: selectedStage,
        ),
      );

      if (!mounted) return;
      Navigator.pop(context);
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  int _age(String id) {
    switch (id) {
      case 'kg1':
        return 4;
      case 'kg2':
        return 5;
      case 'g1':
        return 7;
      case 'g2':
        return 8;
      default:
        return 9;
    }
  }

  void _openPlacementTest() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PrepExamScreen()),
    );
  }

  Widget _childSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'اختر بطاقة الطفل',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _childSelectorButton(
                index: 0,
                label: 'الطفل الأول',
                icon: Icons.looks_one_rounded,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _childSelectorButton(
                index: 1,
                label: 'الطفل الثاني',
                icon: Icons.looks_two_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _childSelectorButton({
    required int index,
    required String label,
    required IconData icon,
  }) {
    final selected = selectedChildIndex == index;
    final exists = index < kids.length;

    return Button3D(
      onTap: () => _selectChild(index),
      color: selected
          ? const Color(0xFF7E57C2)
          : exists
              ? const Color(0xFF26A69A)
              : const Color(0xFF78909C),
      depth: selected ? 2 : 7,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            exists ? 'مسجل' : 'إضافة',
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _avatarPreview() {
    const double size = 105.0;

    if (avatarPath.isNotEmpty) {
      return ClipOval(
        child: Image.file(
          File(avatarPath),
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => SvgPicture.asset(
            selectedAvatar,
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    return SvgPicture.asset(
      selectedAvatar,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }

  Widget _avatarSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFFE8EAF6), Color(0xFFFCE4EC)],
        ),
        border: Border.all(color: const Color(0xFF7E57C2), width: 2),
      ),
      child: Column(
        children: [
          const Text(
            'اختر صورة الطفل',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          Container(
            width: 120,
            height: 120,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                  color: Colors.black.withValues(alpha: 0.15),
                ),
              ],
            ),
            child: _avatarPreview(),
          ),
          const SizedBox(height: 14),
          const Text(
            'شخصيات مختلفة للأولاد والبنات',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: avatars.map((avatar) {
              final selected =
                  avatarPath.isEmpty && selectedAvatar == avatar.$1;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAvatar = avatar.$1;
                    avatarPath = '';
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 82,
                  height: 100,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF7E57C2)
                          : Colors.transparent,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: selected ? 10 : 4,
                        color: Colors.black.withValues(
                          alpha: selected ? 0.18 : 0.08,
                        ),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SvgPicture.asset(
                          avatar.$1,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        avatar.$2,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo_library_rounded),
              label: const Text('اختيار صورة من معرض الهاتف'),
            ),
          ),
          if (avatarPath.isNotEmpty) ...[
            const SizedBox(height: 7),
            const Text(
              'تم اختيار صورة من الهاتف ✓',
              style: TextStyle(
                color: Color(0xFF00A152),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ],
      ),
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
            const Text(
              'يمكن تسجيل طفلين، ولكل طفل بطاقة وتقدم ونجوم وألقاب خاصة به.',
            ),
            const SizedBox(height: 22),
            _childSelector(),
            const SizedBox(height: 22),
            _avatarSection(),
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
            ...stages.map((stage) {
              final selected = stageId == stage.$1;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Button3D(
                  onTap: () => setState(() => stageId = stage.$1),
                  color: StageColors.of(stage.$1),
                  depth: selected ? 2 : 8,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Text(stage.$3, style: const TextStyle(fontSize: 26)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          stage.$2,
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
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              child: const Row(
                children: [
                  Text('📝', style: TextStyle(fontSize: 30)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'اختبار تحديد المستوى',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'اختبار للمرحلتين السابقتين وتمهيد للصف الأول — ليس مرحلة دراسية.',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Button3D(
              onTap: () {
                if (!saving) {
                  _save();
                }
              },
              color: const Color(0xFF00C853),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.save_rounded, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    saving
                        ? 'جارٍ الحفظ...'
                        : selectedChildIndex < kids.length
                            ? 'حفظ تعديلات الطفل 🚀'
                            : 'حفظ الطفل 🚀',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (kids.length >= maxChildren)
              const Center(
                child: Text(
                  'تم تسجيل طفلين. يمكنك التبديل بينهما من الأعلى.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.grey,
                  ),
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

class _CelebrationDialog extends StatelessWidget {
  final String name;
  final String stage;

  const _CelebrationDialog({
    required this.name,
    required this.stage,
  });

  @override
  Widget build(BuildContext context) {
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
            const Text('🎉⭐🎊', style: TextStyle(fontSize: 46)),
            const SizedBox(height: 14),
            const Text(
              'تم التسجيل بنجاح! 🎉',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'تم حفظ اسم $name في $stage 🌟\n'
              'سنحفظ تقدمك مع كل نشاط.',
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
