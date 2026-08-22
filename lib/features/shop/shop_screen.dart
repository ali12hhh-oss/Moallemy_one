import 'package:flutter/material.dart';

import '../../core/storage/progress_v5.dart';

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
  State<ShopScreen> createState() => _S();
}

class _S extends State<ShopScreen> {
  int stars = 0;
  Set<String> bought = {};

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final s = await ProgressV5.load();
    if (!mounted) return;
    setState(() {
      stars = s['stars'] ?? 0;
      bought = Set<String>.from(s['bought'] ?? []);
    });
  }

  @override
  Widget build(BuildContext c) {
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
            final x = items[i];
            final owned = bought.contains(x.id);
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(x.emoji, style: const TextStyle(fontSize: 55)),
                    Text(
                      x.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Expanded(child: Text(x.desc, textAlign: TextAlign.center)),
                    Text('⭐ ${x.price}'),
                    const SizedBox(height: 6),
                    FilledButton(
                      onPressed: owned
                          ? null
                          : () async {
                              final ok = await ProgressV5.buy(x.id, x.price);
                              if (ok) {
                                await load();
                              } else if (c.mounted) {
                                ScaffoldMessenger.of(c).showSnackBar(
                                  const SnackBar(
                                    content: Text('تحتاج إلى نجوم أكثر'),
                                  ),
                                );
                              }
                            },
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
