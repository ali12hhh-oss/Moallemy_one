import 'package:flutter/material.dart';

import '../../core/store/store_background_service.dart';
import '../../core/store/store_service_v23.dart';
import '../../data/store_v23.dart';
import 'store_artwork.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int _stars = 0;
  final Set<String> _owned = <String>{};
  String _filter = 'الكل';
  String _selectedBackground = StoreBackgroundService.originalId;

  List<String> get _categories => <String>[
        'الكل',
        ...{
          for (final item in rewardsV23) item.type,
        },
      ];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final stars = await StoreServiceV23.stars();
    final owned = <String>{};
    for (final item in rewardsV23) {
      if (await StoreServiceV23.owned(item.id)) owned.add(item.id);
    }
    final selectedBackground = await StoreBackgroundService.selectedId();
    if (!mounted) return;
    setState(() {
      _stars = stars;
      _owned
        ..clear()
        ..addAll(owned);
      _selectedBackground = selectedBackground;
    });
  }

  Future<void> _buy(RewardItemV23 item) async {
    if (_owned.contains(item.id)) return;
    if (_stars < item.price) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تحتاج ${item.price - _stars} نجمة إضافية ⭐')),
      );
      return;
    }

    final success = await StoreServiceV23.buy(
      item.id,
      item.price,
      title: item.type == 'ألقاب' ? item.title : null,
    );
    if (!mounted) return;
    if (success) {
      await _refresh();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم شراء ${item.title} 🎉')),
      );
    }
  }

  Future<void> _applyBackground(String id) async {
    final success = await StoreBackgroundService.apply(id);
    if (!mounted) return;
    if (success) {
      setState(() => _selectedBackground = id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            id == StoreBackgroundService.originalId
                ? 'تمت استعادة الخلفية الأصلية ✅'
                : 'تم تطبيق الخلفية ✅',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _filter == 'الكل'
        ? rewardsV23
        : rewardsV23.where((item) => item.type == _filter).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('متجر النجوم ⭐'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: Text(
                  '$_stars ⭐',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFF3B0), Color(0xFFFFD54F)],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  const Text('⭐', style: TextStyle(fontSize: 38)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'رصيدك $_stars نجمة\nاجمع النجوم من التعلم واستبدلها بالمكافآت.',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
            if (_filter == 'الكل' || _filter == 'خلفيات')
              Container(
                margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'الخلفية الحالية',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                    Text(
                      _selectedBackground == StoreBackgroundService.originalId
                          ? 'الأصلية'
                          : 'مختارة ⭐',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: _selectedBackground == StoreBackgroundService.originalId
                          ? null
                          : () => _applyBackground(StoreBackgroundService.originalId),
                      icon: const Icon(Icons.restore_rounded, size: 18),
                      label: const Text('الأصلية'),
                    ),
                  ],
                ),
              ),
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return ChoiceChip(
                    label: Text(category),
                    selected: category == _filter,
                    onSelected: (_) => setState(() => _filter = category),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: .78,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final owned = _owned.contains(item.id);
                  final canBuy = _stars >= item.price && !owned;
                  final isBackground = item.type == 'خلفيات';
                  final isApplied = isBackground && _selectedBackground == item.id;

                  return Card(
                    elevation: 5,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
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
                        const SizedBox(height: 3),
                        Text(
                          '${item.price} ⭐',
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
                          child: SizedBox(
                            width: double.infinity,
                            child: isBackground && owned
                                ? ElevatedButton(
                                    onPressed: isApplied
                                        ? null
                                        : () => _applyBackground(item.id),
                                    child: Text(isApplied ? 'مطبقة ✓' : 'تطبيق'),
                                  )
                                : ElevatedButton(
                                    onPressed: canBuy ? () => _buy(item) : null,
                                    child: Text(owned ? 'تم الشراء ✓' : 'شراء'),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
