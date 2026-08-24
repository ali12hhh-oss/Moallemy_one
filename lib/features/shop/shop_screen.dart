import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:daleel_child/core/store/store_service_v23.dart';
import 'package:daleel_child/data/store_v23.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int _stars = 0;
  final Set<String> _owned = <String>{};
  String _filter = 'الكل';

  List<String> get _categories => <String>['الكل', ...{
        for (final item in rewardsV23) item.type,
      }];

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
    if (!mounted) return;
    setState(() {
      _stars = stars;
      _owned
        ..clear()
        ..addAll(owned);
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
                            child: SvgPicture.asset(
                              item.image,
                              fit: BoxFit.contain,
                              width: double.infinity,
                            ),
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
                            child: ElevatedButton(
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
