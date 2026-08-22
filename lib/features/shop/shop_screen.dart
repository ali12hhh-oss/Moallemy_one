import 'package:flutter/material.dart';

import 'package:daleel_child/core/storage/child_progress_repository.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int _stars = 0;

  @override
  void initState() {
    super.initState();
    _loadStars();
  }

  Future<void> _loadStars() async {
    final stars = await ChildProgressRepository.stars();
    if (!mounted) return;
    setState(() => _stars = stars);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المتجر')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.storefront_outlined, size: 64),
              const SizedBox(height: 16),
              const Text(
                'المتجر غير مفعّل بعد',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'لا توجد عناصر قابلة للشراء حالياً. تم إخفاء أزرار الشراء حتى لا تظهر وظيفة غير مكتملة للطفل.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Chip(label: Text('الرصيد: $_stars ⭐')),
            ],
          ),
        ),
      ),
    );
  }
}
