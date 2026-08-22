import 'package:flutter/material.dart';

import '../../core/adaptive/adaptive_learning_engine_v24.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../core/storage/app_storage.dart';
import '../../core/storage/progress_v8.dart';
import '../../models/child.dart';

class ParentsScreen extends StatefulWidget {
  const ParentsScreen({super.key});

  @override
  State<ParentsScreen> createState() => _ParentsScreenState();
}

class _ParentsScreenState extends State<ParentsScreen> {
  Child? child;
  int attempts = 0;
  int successes = 0;
  List<String> weakSkills = const [];
  Map<String, dynamic> progress = const {};
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
    final summary = await AdaptiveLearningEngineV24.summary();
    final weak = await AdaptiveLearningEngineV24.weakSkills();
    final shared = await ProgressV8.load();
    if (!mounted) return;
    setState(() {
      child = selected;
      attempts = summary['attempts'] ?? 0;
      successes = summary['successes'] ?? 0;
      weakSkills = weak;
      progress = shared;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final accuracy = attempts == 0 ? 0.0 : successes / attempts;
    final stars = (progress['stars'] ?? child?.stars ?? 0) as int;
    final xp = (progress['xp'] ?? 0) as int;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('متابعة الأسرة')),
        body:
            loading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    children: [
                      _headerCard(),
                      const SizedBox(height: 12),
                      _statsCard(accuracy, stars, xp),
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

  Widget _headerCard() => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 34,
            child: Text('🧒', style: TextStyle(fontSize: 32)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  child?.name ?? 'لا يوجد طفل',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  child == null
                      ? 'سجّل الطفل من الصفحة الرئيسية.'
                      : 'المرحلة: ${child!.stage}',
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _statsCard(double accuracy, int stars, int xp) => Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ملخص الأداء',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
          ),
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
            : 'تم تسجيل ${arNum(attempts)} محاولة تعليمية، مع حفظ نتائج المهارات على الجهاز.',
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
}
