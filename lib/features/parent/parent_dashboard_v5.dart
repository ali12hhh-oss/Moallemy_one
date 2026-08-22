import 'package:flutter/material.dart';

import '../../core/storage/progress_v5.dart';
import '../../data/curriculum_v5.dart';

class ParentDashboardV5 extends StatefulWidget {
  const ParentDashboardV5({super.key});
  @override
  State<ParentDashboardV5> createState() => _S();
}

class _S extends State<ParentDashboardV5> {
  Map<String, dynamic> s = {};
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async =>
      setState(() => ProgressV5.load().then((x) => s = x) as dynamic);
  @override
  Widget build(BuildContext c) {
    final done = List<String>.from(s['done'] ?? []);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('لوحة الوالدين')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: ListTile(
                leading: const Text('⭐', style: TextStyle(fontSize: 40)),
                title: const Text('رصيد النجوم'),
                subtitle: Text('${s['stars'] ?? 0} نجمة'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.school),
                title: const Text('الدروس المكتملة'),
                subtitle: Text(
                  '${done.length} من ${curriculum.fold<int>(0, (a, b) => a + b.units.length)} درس',
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'المراحل التعليمية',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ...curriculum.map((x) {
              final n = x.units.where((u) => done.contains(u.id)).length;
              return ListTile(
                title: Text(x.title),
                subtitle: LinearProgressIndicator(
                  value: x.units.isEmpty ? 0 : n / x.units.length,
                ),
                trailing: Text('$n/${x.units.length}'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
