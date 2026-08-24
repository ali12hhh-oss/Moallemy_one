import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/child.dart';
import '../../core/storage/app_storage.dart';
import '../../core/localization/arabic_numbers.dart';

class ChildrenScreen extends StatefulWidget {
  const ChildrenScreen({super.key});
  @override
  State<ChildrenScreen> createState() => _S();
}

class _S extends State<ChildrenScreen> {
  static const maxChildren = 2;
  static const avatars = <String>[
    'assets/images/child_avatars/boy_1.svg',
    'assets/images/child_avatars/boy_2.svg',
    'assets/images/child_avatars/girl_1.svg',
    'assets/images/child_avatars/girl_2.svg',
  ];

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
    if (kids.length >= maxChildren) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يمكن تسجيل طفلين فقط في هذا الحساب')),
      );
      return;
    }

    final name = TextEditingController();
    int age = 6;
    String avatar = avatars[kids.length];
    String customPath = '';

    await showDialog<void>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (c, setD) => AlertDialog(
          title: const Text('تسجيل طفل جديد'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('اختر صورة للطفل'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: List.generate(avatars.length, (i) {
                    final selected = customPath.isEmpty && avatar == avatars[i];
                    return GestureDetector(
                      onTap: () => setD(() {
                        avatar = avatars[i];
                        customPath = '';
                      }),
                      child: Container(
                        width: 62,
                        height: 62,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected ? Theme.of(c).colorScheme.primary : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: SvgPicture.asset(avatars[i]),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 88,
                    );
                    if (picked != null) {
                      setD(() => customPath = picked.path);
                    }
                  },
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('اختيار صورة من المعرض'),
                ),
                if (customPath.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ClipOval(
                      child: Image.file(
                        File(customPath),
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                TextField(
                  controller: name,
                  decoration: const InputDecoration(labelText: 'اسم الطفل'),
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
                    avatarAsset: avatar,
                    avatarPath: customPath,
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

  Widget avatarView(Child k, {double size = 54}) {
    if (k.avatarPath.isNotEmpty) {
      return ClipOval(
        child: Image.file(
          File(k.avatarPath),
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => SvgPicture.asset(k.avatarAsset),
        ),
      );
    }
    return SvgPicture.asset(k.avatarAsset, width: size, height: size);
  }

  @override
  Widget build(BuildContext c) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('بطاقات الأطفال')),
        floatingActionButton: kids.length < maxChildren
            ? FloatingActionButton.extended(
                onPressed: add,
                label: const Text('إضافة طفل'),
                icon: const Icon(Icons.add),
              )
            : null,
        body: kids.isEmpty
            ? const Center(child: Text('أضف أول ملف لطفلك للبدء.'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: kids.length,
                itemBuilder: (_, index) {
                  final k = kids[index];
                  final title = k.activeTitle;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          avatarView(k, size: 72),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(k.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                                const SizedBox(height: 4),
                                Text('${arNum(k.age)} سنوات • ${k.stage}'),
                                Text('⭐ ${arNum(k.stars)} نجمة'),
                                if (title != null) ...[
                                  const SizedBox(height: 5),
                                  Chip(
                                    avatar: const Icon(Icons.emoji_events, size: 18),
                                    label: Text(title),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: 'تفعيل هذا الطفل',
                            onPressed: () async {
                              await AppStorage.setActive(k.id);
                              if (mounted) setState(() {});
                              if (c.mounted) {
                                ScaffoldMessenger.of(c).showSnackBar(
                                  SnackBar(content: Text('تم تفعيل ${k.name}')),
                                );
                              }
                            },
                            icon: const Icon(Icons.swap_horiz),
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
