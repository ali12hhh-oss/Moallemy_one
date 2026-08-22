import 'package:flutter/material.dart';

import '../../core/store/store_service_v23.dart';

class ShopItem {
  final String id, name, desc, emoji;
  final int price;
  const ShopItem(this.id, this.name, this.desc, this.emoji, this.price);
}

const items = [
  ShopItem('sticker_star', 'ملصق النجمة', 'ملصق مميز لدفتر الإنجازات', '⭐', 10),
  ShopItem('sticker_rainbow', 'ملصق قوس قزح', 'زينة لصفحة الطفل', '🌈', 15),
  ShopItem('badge_reader', 'وسام القارئ', 'وسام عند جمع النجوم', '📚', 30),
  ShopItem('badge_artist', 'وسام الفنان', 'وسام الإبداع والرسم', '🎨', 30),
  ShopItem('avatar_bunny', 'شخصية الأرنب', 'افتح شخصية جديدة', '🐰', 40),
  ShopItem('avatar_lion', 'شخصية الأسد', 'افتح شخصية جديدة', '🦁', 50),
  ShopItem('theme_sky', 'خلفية السماء', 'خلفية تشجيعية', '☁️', 25),
  ShopItem('crown', 'تاج البطل', 'جائزة خاصة للإنجاز', '👑', 75),
];

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});
  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int stars = 0;
  Set<String> bought = <String>{};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final currentStars = await StoreServiceV23.stars();
    final owned = <String>{};
    for (final item in items) {
      if (await StoreServiceV23.owned(item.id)) owned.add(item.id);
    }
    if (!mounted) return;
    setState(() {
      stars = currentStars;
      bought = owned;
    });
  }

  Future<void> _buy(BuildContext context, ShopItem item) async {
    final ok = await StoreServiceV23.buy(item.id, item.price);
    if (ok) {
      await _load();
      return;
    }
    if (!mounted) return;
    final owned = await StoreServiceV23.owned(item.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(owned ? 'تم شراء هذا العنصر مسبقاً' : 'تحتاج إلى نجوم أكثر'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('متجر النجوم ⭐ $stars')),
        body: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: .82,
          ),
          itemCount: items.length,
          itemBuilder: (_, i) {
            final item = items[i];
            final owned = bought.contains(item.id);
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(item.emoji, style: const TextStyle(fontSize: 55)),
                    Text(item.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Expanded(
                        child: Text(item.desc, textAlign: TextAlign.center)),
                    Text('⭐ ${item.price}'),
                    const SizedBox(height: 6),
                    FilledButton(
                      onPressed: owned ? null : () => _buy(context, item),
                      child: Text(owned ? 'تم الشراء' : 'شراء'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
