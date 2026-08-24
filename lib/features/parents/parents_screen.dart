import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/adaptive/adaptive_learning_engine_v24.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../core/storage/app_storage.dart';
import '../../core/storage/child_progress_repository.dart';
import '../../models/child.dart';

class ParentsScreen extends StatefulWidget {
  const ParentsScreen({super.key});

  @override
  State<ParentsScreen> createState() => _ParentsScreenState();
}

class _ParentsScreenState extends State<ParentsScreen> {
  List<Child> children = const [];
  Child? child;
  int attempts = 0;
  int successes = 0;
  List<String> weakSkills = const [];
  int stars = 0;
  int xp = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final kids = await AppStorage.getChildren();
    final active = await AppStorage.activeId();
    Child? selected;
    for (final item in kids) {
      if (item.id == active) {
        selected = item;
        break;
      }
    }
    selected ??= kids.isEmpty ? null : kids.first;

    if (selected != null && selected.id != active) {
      await AppStorage.setActive(selected.id);
    }

    final summary = await AdaptiveLearningEngineV24.summary();
    final weak = await AdaptiveLearningEngineV24.weakSkills();
    final state = await ChildProgressRepository.load();
    final currentStars = _int(state['stars'], selected?.stars ?? 0);
    final currentXp = _int(state['xp']);

    if (!mounted) return;
    setState(() {
      children = kids;
      child = selected;
      attempts = summary['attempts'] ?? 0;
      successes = summary['successes'] ?? 0;
      weakSkills = weak;
      stars = currentStars;
      xp = currentXp;
      loading = false;
    });
  }

  Future<void> _selectChild(Child selected) async {
    if (child?.id == selected.id) return;
    setState(() => loading = true);
    await AppStorage.setActive(selected.id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final accuracy = attempts == 0 ? 0.0 : successes / attempts;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('متابعة الأسرة')),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _load,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (children.length > 1) ...[
                      _childrenSwitcher(),
                      const SizedBox(height: 12),
                    ],
                    _headerCard(),
                    const SizedBox(height: 12),
                    _statsCard(accuracy),
                    const SizedBox(height: 12),
                    _learningCard(),
                    const SizedBox(height: 12),
                    _weakCard(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _childrenSwitcher() => Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'الأطفال',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),
              ...children.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _selectChild(item),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: child?.id == item.id
                            ? Theme.of(context).colorScheme.primary.withValues(alpha: .12)
                            : Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: child?.id == item.id
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          _avatar(item, radius: 25),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                                ),
                                Text('${item.stage} • ${arNum(item.stars)} ⭐'),
                              ],
                            ),
                          ),
                          if (child?.id == item.id)
                            const Icon(Icons.check_circle_rounded),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _headerCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              _avatar(child, radius: 34),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      child?.name ?? 'لا يوجد طفل',
                      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      child == null
                          ? 'سجّل الطفل من الصفحة الرئيسية.'
                          : 'المرحلة: ${child!.stage} • العمر: ${arNum(child!.age)}',
                    ),
                    if (child?.activeTitle != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('اللقب: ${child!.activeTitle} 🏆'),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _statsCard(double accuracy) => Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('ملخص الأداء', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
              const SizedBox(height: 14),
              Text('المحاولات: ${arNum(attempts)}'),
              const SizedBox(height: 8),
              Text('الإجابات الصحيحة: ${arNum(successes)}'),
              const SizedBox(height: 8),
              Text('الدقة: ${arNum((accuracy * 100).round())}٪'),
              const SizedBox(height: 7),
              LinearProgressIndicator(value: accuracy.clamp(0, 1).toDouble()),
              const SizedBox(height: 14),
              Text('النجوم: ${arNum(stars)} ⭐'),
              Text('الخبرة: ${arNum(xp)} XP'),
            ],
          ),
        ),
      );

  Widget _learningCard() => Card(
        child: ListTile(
          leading: const Icon(Icons.school_rounded),
          title: const Text('ما تم تعلمه'),
          subtitle: Text(
            attempts == 0
                ? 'لم يبدأ الطفل تدريبات مسجلة بعد.'
                : 'تم تسجيل ${arNum(attempts)} محاولة تعليمية لهذا الطفل، مع حفظ نتائجه على الجهاز.',
          ),
        ),
      );

  Widget _weakCard() => Card(
        child: ListTile(
          leading: const Icon(Icons.refresh_rounded),
          title: const Text('مهارات تحتاج إلى تقوية'),
          subtitle: Text(
            weakSkills.isEmpty
                ? 'لا توجد مهارات ضعيفة مسجلة حالياً. استمروا بالتدريب 🌟'
                : weakSkills.join(' • '),
          ),
        ),
      );

  Widget _avatar(Child? item, {double radius = 30}) {
    if (item == null) {
      return CircleAvatar(radius: radius, child: const Text('🧒', style: TextStyle(fontSize: 28)));
    }
    if (item.avatarPath.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.transparent,
        child: ClipOval(
          child: Image.file(
            File(item.avatarPath),
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _assetAvatar(item, radius),
          ),
        ),
      );
    }
    return _assetAvatar(item, radius);
  }

  Widget _assetAvatar(Child item, double radius) => CircleAvatar(
        radius: radius,
        backgroundColor: Colors.transparent,
        child: ClipOval(
          child: SvgPicture.asset(
            item.avatarAsset,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            placeholderBuilder: (_) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
        ),
      );

  int _int(dynamic value, [int fallback = 0]) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
