import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/storage/app_storage.dart';
import '../../core/store/store_service_v23.dart';
import '../../data/store_v23.dart';
import '../../models/child.dart';
import '../../widgets/button_3d.dart';
import '../registration/child_registration_screen.dart';
import '../shop/my_collection_screen.dart';
import '../shop/shop_screen.dart';
import '../shop/store_artwork.dart';

class ChildProfileScreen extends StatefulWidget {
  const ChildProfileScreen({super.key});
  @override
  State<ChildProfileScreen> createState() => _ChildProfileScreenState();
}

class _ChildProfileScreenState extends State<ChildProfileScreen> {
  Child? _child;
  Set<String> _owned = <String>{};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final kids = await AppStorage.getChildren();
    final activeId = await AppStorage.activeId();
    Child? selected;
    for (final k in kids) {
      if (k.id == activeId) {
        selected = k;
        break;
      }
    }
    selected ??= kids.isEmpty ? null : kids.first;
    final owned = <String>{};
    if (selected != null) {
      for (final item in rewardsV23) {
        if (await StoreServiceV23.owned(item.id)) owned.add(item.id);
      }
    }
    if (!mounted) return;
    setState(() {
      _child = selected;
      _owned = owned;
      _loading = false;
    });
  }

  Future<void> _edit() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => const ChildRegistrationScreen()));
    await _load();
  }

  Future<void> _store() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopScreen()));
    await _load();
  }

  Widget _avatar(Child c) {
    if (c.avatarPath.isNotEmpty) {
      return ClipOval(child: Image.file(File(c.avatarPath), fit: BoxFit.cover, errorBuilder: (_, __, ___) => SvgPicture.asset(c.avatarAsset)));
    }
    return SvgPicture.asset(c.avatarAsset, fit: BoxFit.contain);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('بطاقة الطفل 🌟'), centerTitle: true),
        body: StoreBackgroundServiceWidget(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _child == null
                  ? _empty()
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(14),
                        children: [_profileCard(_child!), const SizedBox(height: 14), _progressCard(_child!), const SizedBox(height: 14), _collectionCard()],
                      ),
                    ),
        ),
      ),
    );
  }

  Widget _profileCard(Child c) {
    final title = c.activeTitle;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF6A1B9A), Color(0xFF3949AB)], begin: Alignment.topRight, end: Alignment.bottomLeft),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [BoxShadow(color: Color(0x44000000), blurRadius: 10, offset: Offset(0, 5))],
      ),
      child: Column(children: [
        Row(children: [
          Container(width: 100, height: 100, padding: const EdgeInsets.all(5), decoration: BoxDecoration(color: Colors.white.withValues(alpha: .25), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), child: _avatar(c)),
          const SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w900, color: Colors.white)),
            const SizedBox(height: 6),
            Text('${c.age} سنوات • ${c.stage}', style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text('⭐ ${c.stars} نجمة', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFFFFE082))),
            if (title != null) Text('🏅 $title', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          ])),
        ]),
        const SizedBox(height: 14),
        SizedBox(width: double.infinity, height: 50, child: Button3D(onTap: _edit, color: const Color(0xFFFF8F00), depth: 6, padding: EdgeInsets.zero, child: const Center(child: Text('تعديل بيانات الطفل ✏️', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900))))),
      ]),
    );
  }

  Widget _progressCard(Child c) {
    final accuracy = (c.accuracy * 100).round();
    return _section('تقدم الطفل 📚', Icons.auto_graph_rounded, Column(children: [
      Row(children: [_stat('الدروس', '${c.lessons}', Icons.menu_book_rounded), _stat('الاختبارات', '${c.quizzes}', Icons.quiz_rounded), _stat('الدقة', '$accuracy%', Icons.verified_rounded)]),
      const SizedBox(height: 9),
      Row(children: [_stat('الصحيحة', '${c.correct}', Icons.check_circle_rounded), _stat('الدقائق', '${c.minutes}', Icons.timer_rounded), _stat('المواظبة', '${c.streak}', Icons.local_fire_department_rounded)]),
    ]));
  }

  Widget _stat(String label, String value, IconData icon) => Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal: 3), padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 3), decoration: BoxDecoration(color: Colors.white.withValues(alpha: .72), borderRadius: BorderRadius.circular(15)), child: Column(children: [Icon(icon, size: 22, color: const Color(0xFF3949AB)), const SizedBox(height: 3), Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)), Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700))])));

  Widget _collectionCard() {
    final items = rewardsV23.where((i) => _owned.contains(i.id)).toList(growable: false);
    return _section('مقتنياتي 🎁', Icons.inventory_2_rounded, Column(children: [
      if (items.isEmpty) ...[
        const Text('🎁', style: TextStyle(fontSize: 55)),
        const SizedBox(height: 5),
        const Text('لم تجمع مقتنيات بعد', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        Button3D(onTap: _store, color: const Color(0xFFFF8F00), child: const Text('اذهب إلى المتجر ⭐', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900))),
      ] else ...[
        SizedBox(height: 170, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: items.length, separatorBuilder: (_, __) => const SizedBox(width: 10), itemBuilder: (_, i) => _ownedItem(items[i]))),
        const SizedBox(height: 10),
        SizedBox(width: double.infinity, height: 50, child: Button3D(onTap: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => const MyCollectionScreen())); await _load(); }, color: const Color(0xFF6A1B9A), padding: EdgeInsets.zero, child: const Center(child: Text('عرض كل مقتنياتي 🎁', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16))))),
      ],
    ]));
  }

  Widget _ownedItem(RewardItemV23 item) => Container(width: 125, padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withValues(alpha: .78), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE1BEE7))), child: Column(children: [Expanded(child: StoreArtwork(art: item.art)), const SizedBox(height: 5), Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900))]));

  Widget _section(String title, IconData icon, Widget child) => Container(padding: const EdgeInsets.fromLTRB(12, 12, 12, 14), decoration: BoxDecoration(color: Colors.white.withValues(alpha: .80), borderRadius: BorderRadius.circular(25), boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 8, offset: Offset(0, 4))]), child: Column(children: [Row(children: [Icon(icon, color: const Color(0xFF6A1B9A), size: 26), const SizedBox(width: 8), Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900))]), const SizedBox(height: 10), child]));

  Widget _empty() => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [const Text('🧒', style: TextStyle(fontSize: 70)), const SizedBox(height: 10), const Text('لا توجد بطاقة طفل حالياً', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)), const SizedBox(height: 12), Button3D(onTap: _edit, color: const Color(0xFF6A1B9A), child: const Text('تسجيل الطفل', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)))]));
}
