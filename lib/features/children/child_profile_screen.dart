import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/storage/app_storage.dart';
import '../../core/store/store_service_v23.dart';
import '../../core/store/store_background_service.dart';
import '../../data/store_v23.dart';
import '../../models/child.dart';
import '../../widgets/button_3d.dart';
import '../registration/child_registration_screen.dart';
import '../shop/shop_screen.dart';
import '../shop/store_artwork.dart';

/// بطاقة الطفل الكاملة: البيانات الشخصية + التقدم + المقتنيات.
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
    for (final item in kids) {
      if (item.id == activeId) {
        selected = item;
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

  Future<void> _editChild() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ChildRegistrationScreen()),
    );
    await _load();
  }

  Future<void> _openStore() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ShopScreen()),
    );
    await _load();
  }

  Widget _avatar(Child child, {double size = 96}) {
    if (child.avatarPath.isNotEmpty) {
      return ClipOval(
        child: Image.file(
          File(child.avatarPath),
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => SvgPicture.asset(
            child.avatarAsset,
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        ),
      );
    }
    return SvgPicture.asset(
      child.avatarAsset,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('بطاقة الطفل 🌟'),
          centerTitle: true,
        ),
        body: StoreBackgroundServiceWidget(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _child == null
                  ? _empty()
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(14, 14, 14, 30),
                        children: [
                          _profileCard(_child!),
                          const SizedBox(height: 14),
                          _progressCard(_child!),
                          const SizedBox(height: 14),
                          _collectionSection(),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  Widget _profileCard(Child child) {
    final title = child.activeTitle;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF6A1B9A), Color(0xFF3949AB)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(color: Color(0x44000000), blurRadius: 10, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 106,
                height: 106,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .25),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: .8), width: 3),
                ),
                child: _avatar(child),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      child.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      '${child.age} سنوات • ${child.stage}',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white70),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      '⭐ ${child.stars} نجمة',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFFFFE082)),
                    ),
                    if (title != null) ...[
                      const SizedBox(height: 5),
                      Text(
                        '🏅 $title',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Button3D(
              onTap: _editChild,
              color: const Color(0xFFFF8F00),
              depth: 6,
              padding: EdgeInsets.zero,
              child: const Center(
                child: Text('تعديل بيانات الطفل ✏️', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressCard(Child child) {
    final accuracy = (child.accuracy * 100).round();
    return _sectionCard(
      title: 'تقدم الطفل 📚',
      icon: Icons.auto_graph_rounded,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _stat('الدروس', '${child.lessons}', Icons.menu_book_rounded)),
              Expanded(child: _stat('الاختبارات', '${child.quizzes}', Icons.quiz_rounded)),
              Expanded(child: _stat('الدقة', '$accuracy%', Icons.verified_rounded)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _stat('الإجابات الصحيحة', '${child.correct}', Icons.check_circle_rounded)),
              Expanded(child: _stat('الدقائق', '${child.minutes}', Icons.timer_rounded)),
              Expanded(child: _stat('المواظبة', '${child.streak}', Icons.local_fire_department_rounded)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .72),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 23, color: const Color(0xFF3949AB)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
          const SizedBox(height: 2),
          Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _collectionSection() {
    final items = rewardsV23.where((item) => _owned.contains(item.id)).toList(growable: false);
    return _sectionCard(
      title: 'مقتنياتي 🎁',
      icon: Icons.inventory_2_rounded,
      trailing: Text('${items.length} مقتنى', style: const TextStyle(fontWeight: FontWeight.w900)),
      child: Column(
        children: [
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Column(
                children: [
                  const Text('🎁', style: TextStyle(fontSize: 54)),
                  const SizedBox(height: 6),
                  const Text('لم تجمع مقتنيات بعد', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 12),
                  Button3D(
                    onTap: _openStore,
                    color: const Color(0xFFFF8F00),
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                    child: const Text('اذهب إلى المتجر ⭐', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                  ),
                ],
              ),
            )
          else
            SizedBox(
              height: 176,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(vertical: 2),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, index) => _collectionItem(items[index]),
              ),
            ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Button3D(
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => const MyCollectionScreen()));
                await _load();
              },
              color: const Color(0xFF6A1B9A),
              padding: EdgeInsets.zero,
              child: const Center(child: Text('عرض كل مقتنياتي 🎁', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _collectionItem(RewardItemV23 item) {
    return Container(
      width: 128,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .78),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE1BEE7), width: 1.5),
      ),
      child: Column(
        children: [
          Expanded(child: StoreArtwork(art: item.art)),
          const SizedBox(height: 5),
          Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .78),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withValues(alpha: .9), width: 1.5),
        boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF6A1B9A), size: 26),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900))),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _empty() => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🧒', style: TextStyle(fontSize: 70)),
              const SizedBox(height: 12),
              const Text('لا توجد بطاقة طفل حالياً', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Button3D(
                onTap: _editChild,
                color: const Color(0xFF6A1B9A),
                child: const Text('تسجيل الطفل', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
              ),
            ],
          ),
        ),
      );
}
