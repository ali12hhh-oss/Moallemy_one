import 'package:flutter/material.dart';
import '../../core/settings/app_preferences_v10.dart';
import '../../core/storage/app_storage.dart';
import '../../core/theme/stage_colors.dart';
import '../../models/child.dart';
import '../../widgets/button_3d.dart';
import '../parents/parents_screen.dart';
import '../settings/settings_screen.dart';
import '../shop/shop_screen.dart';
import '../stages/stage_screen.dart';
import '../registration/child_registration_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Child? child;
  final prefs = AppPreferencesV10.instance;

  static const List<(String id, String title, String age, String emoji, String desc)> stages = [
    ('kg1', 'الروضة الأولى', '٣–٤ سنوات', '🎨', 'ألوان وأشكال واستماع وأعداد أولى'),
    ('kg2', 'الروضة الثانية', '٤–٥ سنوات', '🔤', 'حروف وأرقام وكتابة وكلمات قصيرة'),
    ('prep', 'التمهيدي', '٥–٦ سنوات', '📝', 'اختبار شامل يراجع الروضة الأولى والثانية'),
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
            TextField(
              controller: controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(labelText: 'الإجابة', errorText: error ? 'إجابة غير صحيحة، حاول مرة أخرى' : null),
              onSubmitted: (_) {
                if (int.tryParse(controller.text.trim()) == expected) {
                  Navigator.pop(dialogContext, true);
                } else {
                  setDialog(() { error = true; controller.clear(); });
                }
              },
            ),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('إلغاء')),
            FilledButton(onPressed: () {
              if (int.tryParse(controller.text.trim()) == expected) {
                Navigator.pop(dialogContext, true);
              } else {
                setDialog(() { error = true; controller.clear(); });
              }
            }, child: const Text('دخول')),
          ],
        ),
      ),
    );
    controller.dispose();
    return result == true;
  }

  void _openStage(String id) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => StageScreen(stageId: id)));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = prefs.themeMode == ThemeMode.dark;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF14162A) : const Color(0xFFF3F1FF),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: const Text('معلمي', style: TextStyle(fontWeight: FontWeight.w900)),
          leading: IconButton(tooltip: 'الإعدادات', icon: const Icon(Icons.settings_rounded), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()))),
          actions: [IconButton(tooltip: isDark ? 'الوضع النهاري' : 'الوضع الليلي', icon: Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded), onPressed: () => prefs.setDarkMode(!isDark))],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            _childButton(),
            const SizedBox(height: 16),
            _parentButton(),
            const SizedBox(height: 26),
            const Text('مراحل التعلم', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text(child == null ? 'اختر المرحلة المناسبة لطفلك وابدأ الرحلة.' : 'اختر مرحلة ${child!.name} وابدأ التعلم.', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 14),
            ..._stageButtons(),
            const SizedBox(height: 12),
            _storeButton(),
          ],
        ),
      ),
    );
  }

  Widget _childButton() {
    return Button3D(
      onTap: _openRegistration,
      color: StageColors.registration,
      depth: 9,
      child: Row(children: [
        Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: .3), shape: BoxShape.circle),
          child: const Center(child: Text('🧒', style: TextStyle(fontSize: 34))),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              child == null ? 'اكتب اسمك يا بطل ⭐' : 'أهلاً يا ${child!.name} 🌟',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
            ),
            const SizedBox(height: 5),
            Text(
              child == null ? 'سجّل اسمك ومرحلتك لنحفظ تقدمك.' : 'المرحلة: ${child!.stage}  •  اضغط لتعديل البيانات',
              style: const TextStyle(color: Colors.white),
            ),
          ]),
        ),
        const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.white),
      ]),
    );
  }

  Widget _parentButton() => Button3D(
    onTap: _openParents,
    color: StageColors.family,
    depth: 9,
    child: Row(children: [
      Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: .3), borderRadius: BorderRadius.circular(16)),
        child: const Center(child: Text('👨‍👩‍👧', style: TextStyle(fontSize: 27))),
      ),
      const SizedBox(width: 14),
      const Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('متابعة الأسرة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
          SizedBox(height: 3),
          Text('نتائج الطفل، المهارات المتقنة، وما يحتاج مراجعة', style: TextStyle(color: Colors.white70, fontSize: 13)),
        ]),
      ),
      const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.white),
    ]),
  );

  List<Widget> _stageButtons() {
    return stages.map((s) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Button3D(
          onTap: () => _openStage(s.$1),
          color: StageColors.of(s.$1),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: .3), borderRadius: BorderRadius.circular(16)),
              child: Center(child: Text(s.$4, style: const TextStyle(fontSize: 29))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.$2, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: Colors.white)),
                const SizedBox(height: 3),
                Text('${s.$3} • ${s.$5}', style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
              ]),
            ),
            const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.white),
          ]),
        ),
      );
    }).toList();
  }

  Widget _storeButton() => Button3D(
    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopScreen())),
    color: StageColors.store,
    depth: 9,
    child: Row(children: [
      Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: .32), shape: BoxShape.circle),
        child: const Center(child: Text('⭐', style: TextStyle(fontSize: 27))),
      ),
      const SizedBox(width: 14),
      const Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('المتجر', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
          SizedBox(height: 3),
          Text('جوائز وملصقات وشخصيات تشجيعية بالنجوم', style: TextStyle(color: Colors.white, fontSize: 13)),
        ]),
      ),
      const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.white),
    ]),
  );
}
