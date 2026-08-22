import 'package:flutter/material.dart';

import '../../models/child.dart';
import '../../core/storage/app_storage.dart';
import '../../core/localization/arabic_numbers.dart';

class ChildrenScreen extends StatefulWidget {
  const ChildrenScreen({super.key});
  @override
  State<ChildrenScreen> createState() => _S();
}

class _S extends State<ChildrenScreen> {
  List<Child> kids = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    kids = await AppStorage.getChildren();
    if (mounted) setState(() {});
  }

  Future<void> add() async {
    final name = TextEditingController();
    int age = 6;
    await showDialog<void>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (c, setD) => AlertDialog(
          title: const Text('إضافة طفل'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                decoration: const InputDecoration(
                  labelText: 'اسم الطفل',
                ),
              ),
              const SizedBox(height: 10),
              DropdownButton<int>(
                value: age,
                isExpanded: true,
                items: [4, 5, 6, 7, 8, 9]
                    .map(
                      (x) => DropdownMenuItem<int>(
                        value: x,
                        child: Text('${arNum(x)} سنوات'),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) setD(() => age = v);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () {
                if (name.text.trim().isEmpty) return;
                final stage = age <= 4
                    ? 'الروضة الأولى'
                    : age == 5
                        ? 'الروضة الثانية'
                        : age == 6
                            ? 'التمهيدي'
                            : age == 7
                                ? 'الصف الأول'
                                : age == 8
                                    ? 'الصف الثاني'
                                    : 'الصف الثالث';
                kids.add(
                  Child(
                    id: DateTime.now().microsecondsSinceEpoch.toString(),
                    name: name.text.trim(),
                    age: age,
                    stage: stage,
                  ),
                );
                Navigator.pop(c);
              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
    await AppStorage.saveChildren(kids);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext c) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('ملفات الأطفال')),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: add,
          label: const Text('إضافة طفل'),
          icon: const Icon(Icons.add),
        ),
        body: kids.isEmpty
            ? const Center(
                child: Text(
                  'أضف أول ملف لطفلك للبدء.',
                  style: TextStyle(fontSize: 20),
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: kids
                    .map(
                      (k) => Card(
                        child: ListTile(
                          leading: const CircleAvatar(child: Text('👦')),
                          title: Text(k.name),
                          subtitle: Text(
                            '${arNum(k.age)} سنوات • ${k.stage} • ${arNum(k.stars)} نجمة',
                          ),
                          trailing: const Icon(
                            Icons.check_circle_outline,
                          ),
                          onTap: () async {
                            await AppStorage.setActive(k.id);
                            if (c.mounted)
                              ScaffoldMessenger.of(c).showSnackBar(
                                const SnackBar(
                                  content: Text('تم اختيار الطفل الحالي'),
                                ),
                              );
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }
}
