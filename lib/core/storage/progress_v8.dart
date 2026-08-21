import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressV8 {
  static const key = 'daleel_v5_state';

  static Future<Map<String, dynamic>> load() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(key);
    if (raw == null || raw.isEmpty) return {};
    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  }

  static Future<void> save(Map<String, dynamic> state) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(key, jsonEncode(state));
  }

  static Future<bool> lessonDone(String id) async {
    final s = await load();
    return List<String>.from(s['done'] ?? const <String>[]).contains(id);
  }

  static Future<void> finishLesson(String id, int stars) async {
    final s = await load();
    final done = List<String>.from(s['done'] ?? const <String>[]);
    if (!done.contains(id)) {
      done.add(id);
      s['stars'] = (s['stars'] ?? 0) + stars;
      s['xp'] = (s['xp'] ?? 0) + stars * 10;
    }
    s['done'] = done;
    await save(s);
  }

  static Future<int> stars() async => (await load())['stars'] ?? 0;

  static Future<int> xp() async => (await load())['xp'] ?? 0;

  /// Adds [stars] and [xp] to the single shared reward pool used across the
  /// whole app (shop, parent dashboard, and every practice engine), so
  /// rewards earned anywhere always show up everywhere.
  static Future<void> addRewards({required int stars, int xp = 0}) async {
    final s = await load();
    s['stars'] = (s['stars'] ?? 0) + stars;
    s['xp'] = (s['xp'] ?? 0) + xp;
    await save(s);
  }

  static Future<void> recordFinalExam(String stageId, int score, int total, bool passed) async {
    final s = await load();
    final exams = Map<String, dynamic>.from(s['finalExams'] ?? const {});
    exams[stageId] = {'score': score, 'total': total, 'passed': passed, 'date': DateTime.now().toIso8601String()};
    s['finalExams'] = exams;
    if (passed) {
      final badges = List<String>.from(s['badges'] ?? const <String>[]);
      final badge = 'ختم $stageId';
      if (!badges.contains(badge)) badges.add(badge);
      s['badges'] = badges;
      s['stars'] = (s['stars'] ?? 0) + 50;
      s['xp'] = (s['xp'] ?? 0) + 500;
    }
    await save(s);
  }

  static Future<Map<String, dynamic>?> finalExam(String stageId) async {
    final s = await load();
    final exams = Map<String, dynamic>.from(s['finalExams'] ?? const {});
    final raw = exams[stageId];
    return raw == null ? null : Map<String, dynamic>.from(raw);
  }
}
