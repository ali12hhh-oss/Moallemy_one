import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/settings/app_preferences_v10.dart';
import '../../core/storage/app_storage.dart';
import '../../core/theme/stage_colors.dart';
import '../../models/child.dart';
import '../../widgets/button_3d.dart';
import '../../widgets/store_background.dart';
import '../parents/parents_screen.dart';
import '../settings/settings_screen.dart';
import '../shop/shop_screen.dart';
import '../stages/stage_screen.dart';
import '../registration/child_registration_screen.dart';
import '../children/child_profile_screen.dart';
import '../exam/prep_exam_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Child? child;
  final prefs = AppPreferencesV10.instance;
  int _backgroundRevision = 0;

  static const stages = [
    ('kg1', 'الروضة الأولى', '٣–٤ سنوات', '🎨', 'ألوان وأشكال واستماع وأعداد أولى'),
    ('kg2', 'الروضة الثانية', '٤–٥ سنوات', '🔤', 'حروف وأرقام وكتابة وكلمات قصيرة'),
    ('prep', 'اختبار تحديد المستوى', 'مراجعة', '📝', 'اختبار للمرحلتين السابقتين وتمهيد للصف الأول'),
    ('g1', 'الصف الأول', '٦–٧ سنوات', '🌟', 'قراءة وكتابة وحساب وإنجليزي مبسط'),
    ('g2', 'الصف الثاني', '٧–٨ سنوات', '🚀', 'قواعد وقراءة وحساب ومفردات إنجليزية'),
    ('g3', 'الصف الثالث', '٨–٩ سنوات', '🏆', 'قراءة متقدمة وقواعد وحساب وتحديات'),
  ];

  @override
  void initState() {
    super.initState();
    _loadChild();
  }

  Future<void> _loadChild() async {
    final kids = await AppStorage.getChildren();
    final active = await AppStorage.activeId();
    Child? selected;
    if (active != null) {
      for (final k in kids) {
        if (k.id == active) selected = k;
      }
    }
    selected ??= kids.isEmpty ? null : kids.first;
    if (selected != null) await AppStorage.setActive(selected.id);
    if (mounted) setState(() => child = selected);
  }

  Future<void> _openRegistration() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => const ChildRegistrationScreen()));
    await _loadChild();
  }

  Future<void> _openChildProfile() async {
    if (child == null) {
      await _openRegistration();
      return;
    }
    await Navigator.push(context, MaterialPageRoute(builder: (_) => const ChildProfileScreen()));
    await _loadChild();
    if (!mounted) return;
    setState(() => _backgroundRevision++);
  }

  Future<void> _openParents() async {
    final ok = await _parentGate();
    if (!ok || !mounted) return;
    await Navigator.push(context, MaterialPageRoute(builder: (_) => const ParentsScreen()));
    await _loadChild();
  }

  Future<bool> _parentGate() async {
    final a = 2 + DateTime.now().second % 5;
    final b = 1 + DateTime.now().millisecond % 4;
    final isAddition = DateTime.now().millisecond.isEven;
    final expected = isAddition ? a + b : (a > b ? a - b : b - a);
    final controller = TextEditingController();
    var error = false;
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialog) => AlertDialog(
          title: const Text('منطقة الوالدين 🔒'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('أجب عن السؤال حتى لا يدخل الطفل إلى المتابعة بالخطأ.'),
            const SizedBox(height: 16),
            Text('${a.toString()} ${isAddition ? '+' : '−'} ${b.toString()} = ؟', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(controller: controller, autofocus: true, keyboardType: TextInputType.number, textAlign: TextAlign.center, decoration: InputDecoration(labelText: 'الإجابة', errorText: error ? 'إجابة غير صحيحة، حاول مرة أخرى' : null), onSubmitted: (_) {
              if (int.tryParse(controller.text.trim()) == expected) Navigator.pop(dialogContext, true);
              else setDialog(() { error = true; controller.clear(); });
            }),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('إلغاء')),
            FilledButton(onPressed: () {
              if (int.tryParse(controller.text.trim()) == expected) Navigator.pop(dialogContext, true);
              else setDialog(() { error = true; controller.clear(); });
            }, child: const Text('دخول')),
          ],
        ),
      ),
    );
    controller.dispose();
    return result == true;
  }

  void _openStage(String id) {
    if (id == 'prep') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const PrepExamScreen()));
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => StageScreen(stageId: id)));
  }

  Widget _childAvatar({double size = 54}) {
    final current = child;
    if (current == null) return Center(child: Text('🧒', style: TextStyle(fontSize: size * .55)));
    if (current.avatarPath.isNotEmpty) {
      return ClipOval(child: Image.file(File(current.avatarPath), width: size, height: size, fit: BoxFit.cover, errorBuilder: (_, __, ___) => SvgPicture.asset(current.avatarAsset, width: size, height: size, fit: BoxFit.contain)));
    }
    return SvgPicture.asset(current.avatarAsset, width: size, height: size, fit: BoxFit.contain);
  }

  Future<void> _openStore() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopScreen()));
    if (!mounted) return;
    setState(() => _backgroundRevision++);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = prefs.themeMode == ThemeMode.dark;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
            decoration: BoxDecoration(color: const Color(0xFF0B6E8E).withValues(alpha: .72), borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0xFFFFD54F), width: 2), boxShadow: const [BoxShadow(color: Color(0x66000000), blurRadius: 8, offset: Offset(0, 3))]),
            child: const Text('مُعَلِّمِي', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, letterSpacing: .5, color: Color(0xFFFFF8E1), shadows: [Shadow(color: Color(0xCC000000), blurRadius: 4, offset: Offset(1, 2))]),
          ),
          leading: IconButton(color: Colors.white, tooltip: 'الإعدادات', icon: const Icon(Icons.settings_rounded), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()))),
          actions: [IconButton(color: Colors.white, tooltip: isDark ? 'الوضع النهاري' : 'الوضع الليلي', icon: Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded), onPressed: () => prefs.setDarkMode(!isDark))],
        ),
        body: Stack(children: [
          Positioned.fill(
            child: StoreBackground(
              key: ValueKey(_backgroundRevision),
              originalAsset: 'assets/images/games/home_bg.jpg',
              overlayColor: isDark ? Colors.black.withValues(alpha: .30) : Colors.white.withValues(alpha: .06),
              child: SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(16, 72, 16, 32), children: [
                _childButton(),
                const SizedBox(height: 14),
                _parentButton(),
                const SizedBox(height: 22),
                const Text('مراحل التعلم', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: Colors.white, shadows: [Shadow(blurRadius: 5)])),
                const SizedBox(height: 6),
                Text(child == null ? 'اختر المرحلة المناسبة لطفلك وابدأ الرحلة.' : 'اختر مرحلة ${child!.name} وابدأ التعلم.', style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white, shadows: [Shadow(blurRadius: 4)])),
                const SizedBox(height: 14),
                ..._stageButtons(),
                const SizedBox(height: 4),
                _storeButton(),
              ])),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _childButton() => Button3D(
        onTap: _openChildProfile,
        color: StageColors.registration,
        depth: 9,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(children: [
          Container(width: 54, height: 54, clipBehavior: Clip.antiAlias, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .3), shape: BoxShape.circle), child: _childAvatar()),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(child == null ? 'اكتب اسمك يا بطل ⭐' : 'أهلاً يا ${child!.name} 🌟', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
            const SizedBox(height: 4),
            Text(child == null ? 'سجّل اسمك ومرحلتك لنحفظ تقدمك.' : '${child!.stage} • اضغط لفتح بطاقة الطفل', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
          ])),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.white),
        ]),
      );

  Widget _parentButton() => Button3D(onTap: _openParents, color: StageColors.family, depth: 9, child: Row(children: [
    Container(width: 54, height: 54, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .3), borderRadius: BorderRadius.circular(16)), child: const Center(child: Text('👨‍👩‍👧', style: TextStyle(fontSize: 27)))),
    const SizedBox(width: 14),
    const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('متابعة الأسرة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)), SizedBox(height: 3), Text('نتائج الطفل، المهارات المتقنة، وما يحتاج مراجعة', style: TextStyle(color: Colors.white70, fontSize: 13))])),
    const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.white),
  ]));

  List<Widget> _stageButtons() => stages.map((s) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Button3D(
          onTap: () => _openStage(s.$1),
          color: s.$1 == 'prep' ? const Color(0xFFFFB300) : StageColors.of(s.$1),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(children: [
            Container(width: 54, height: 54, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .3), borderRadius: BorderRadius.circular(16)), child: Center(child: Text(s.$4, style: const TextStyle(fontSize: 29)))),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.$2, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: Colors.white)),
              const SizedBox(height: 3),
              Text('${s.$3} • ${s.$5}', style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
            ])),
            const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.white),
          ]),
        ),
      )).toList();

  Widget _storeButton() => Button3D(onTap: _openStore, color: StageColors.store, depth: 9, child: Row(children: [
    Container(width: 54, height: 54, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .32), shape: BoxShape.circle), child: const Center(child: Text('⭐', style: TextStyle(fontSize: 27)))),
    const SizedBox(width: 14),
    const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('المتجر', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)), SizedBox(height: 3), Text('جوائز وملصقات وشخصيات تشجيعية بالنجوم', style: TextStyle(color: Colors.white, fontSize: 13))])),
    const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.white),
  ]));
}
