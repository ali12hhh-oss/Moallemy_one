import 'package:flutter/material.dart';

import '../../core/store/store_background_service.dart';
import '../../core/store/store_service_v23.dart';
import '../../data/store_v23.dart';
import '../../widgets/button_3d.dart';
import 'shop_screen.dart';
import 'store_artwork.dart';

/// مقتنيات الطفل: تعرض ما تم شراؤه من المتجر لنفس الطفل النشط.
/// لا تنشئ رصيداً أو ملكية جديدة؛ تعتمد مباشرة على StoreServiceV23.
class MyCollectionScreen extends StatefulWidget {
  const MyCollectionScreen({super.key});

  @override
  State<MyCollectionScreen> createState() => _MyCollectionScreenState();
}

class _MyCollectionScreenState extends State<MyCollectionScreen> {
  Set<String> _owned = <String>{};
  String? _selectedBackground;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final owned = <String>{};
    for (final item in rewardsV23) {
      if (await StoreServiceV23.owned(item.id)) owned.add(item.id);
    }
    final selected = await StoreBackgroundService.selectedId();
    if (!mounted) return;
    setState(() {
      _owned = owned;
      _selectedBackground = selected;
      _loading = false;
    });
  }

  Future<void> _applyBackground(RewardItemV23 item) async {
    final success = await StoreBackgroundService.apply(item.id);
    if (!mounted) return;
    if (success) {
      setState(() => _selectedBackground = item.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تطبيق الخلفية من مقتنياتك ✅')),
      );
    }
  }

  Future<void> _openStore() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ShopScreen()),
    );
    await _refresh();
  }

  List<RewardItemV23> get _items => rewardsV23
      .where((item) => _owned.contains(item.id))
      .toList(growable: false);

  @override
  Widget build(BuildContext context) {
    final items = _items;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('مقتنياتي 🎁'),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: 'المتجر',
              icon: const Icon(Icons.storefront_rounded),
              onPressed: _openStore,
            ),
          ],
        ),
        body: StoreBackgroundServiceWidget(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
                      child: _summary(items.length),
                    ),
                    Expanded(
                      child: items.isEmpty
                          ? _emptyState()
                          : GridView.builder(
                              padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: .76,
                              ),
                              itemCount: items.length,
                              itemBuilder: (_, index) => _itemCard(items[index]),
                            ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _summary(int count) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFF3B0), Color(0xFFFFD54F)],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              offset: Offset(0, 4),
              color: Color(0x33000000),
            ),
          ],
        ),
        child: Row(
          children: [
            const Text('🎁', style: TextStyle(fontSize: 40)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'مجموعتي الخاصة',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$count مقتنى تم جمعه من متجر النجوم ⭐',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _itemCard(RewardItemV23 item) {
    final isBackground = item.type == 'خلفيات';
    final isApplied = isBackground && _selectedBackground == item.id;
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: StoreArtwork(art: item.art),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isApplied
                  ? const Color(0xFFC8E6C9)
                  : const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isApplied ? 'مطبقة الآن ✓' : item.type,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
            child: SizedBox(
              width: double.infinity,
              height: 44,
              child: Button3D(
                onTap: isBackground && !isApplied
                    ? () => _applyBackground(item)
                    : null,
                color: isBackground
                    ? (isApplied
                        ? const Color(0xFF78909C)
                        : const Color(0xFF00897B))
                    : const Color(0xFF6A1B9A),
                padding: EdgeInsets.zero,
                child: Center(
                  child: Text(
                    isBackground
                        ? (isApplied ? 'مطبقة' : 'تطبيق')
                        : 'من مقتنياتي ✓',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() => Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎁', style: TextStyle(fontSize: 72)),
              const SizedBox(height: 14),
              const Text(
                'مقتنياتك فارغة حالياً',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              const Text(
                'اذهب إلى متجر النجوم واشترِ أول مكافأة لك.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),
              Button3D(
                onTap: _openStore,
                color: const Color(0xFFFF8F00),
                child: const Text(
                  'الذهاب إلى المتجر ⭐',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

/// خلفية خاصة بالقسم دون المساس بخلفية الصفحة الرئيسية أو إعدادات المتجر.
class StoreBackgroundServiceWidget extends StatelessWidget {
  final Widget child;
  const StoreBackgroundServiceWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE3F2FD), Color(0xFFFFF8E1)],
        ),
      ),
      child: child,
    );
  }
}
