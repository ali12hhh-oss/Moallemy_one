import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/child.dart';

class AppStorage {
  static const childrenKey = 'daleel_children_v3';
  static const activeKey = 'daleel_active_v3';

  static Future<List<Child>> getChildren() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(childrenKey);
    if (raw == null || raw.isEmpty) return <Child>[];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return <Child>[];
      return decoded
          .whereType<Map>()
          .map((e) => Child.fromMap(Map<String, dynamic>.from(e)))
          .where((child) => child.id.isNotEmpty)
          .toList();
    } catch (_) {
      // Corrupt local data must never crash the child-facing app.
      return <Child>[];
    }
  }

  static Future<void> saveChildren(List<Child> children) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(
      childrenKey,
      jsonEncode(children.map((e) => e.toMap()).toList()),
    );
  }

  static Future<String?> activeId() async =>
      (await SharedPreferences.getInstance()).getString(activeKey);

  static Future<void> setActive(String id) async {
    if (id.trim().isEmpty) return;
    await (await SharedPreferences.getInstance()).setString(activeKey, id);
  }

  static Future<void> clearAll() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(childrenKey);
    await p.remove(activeKey);
  }
}
