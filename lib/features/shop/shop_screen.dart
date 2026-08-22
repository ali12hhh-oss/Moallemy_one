import 'package:flutter/material.dart';

import '../../core/shop/store_service_v23.dart';

class ShopItem {
  final String id;
  final String name;
  final int price;

  const ShopItem({
    required this.id,
    required this.name,
    required this.price,
  });
}

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  List<ShopItem> _items = const <ShopItem>[];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final items = await StoreServiceV23.items();
    if (!mounted) return;
    setState(() => _items = items);
  }

  Future<void> _buy(BuildContext context, ShopItem item) async {
    final ok = await StoreServiceV23.buy(item.id, item.price);
    if (ok) {
      await _load();
      return;
    }
    if (!context.mounted) return;
    final owned = await StoreServiceV23.owned(item.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(owned ? 'تم شراء هذا العنصر مسبقاً' : 'تحتاج إلى نجوم أكثر'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المتجر')),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return ListTile(
            title: Text(item.name),
            trailing: FilledButton(
              onPressed: () => _buy(context, item),
              child: Text('${item.price} ⭐'),
            ),
          );
        },
      ),
    );
  }
}
