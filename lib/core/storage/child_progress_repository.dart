import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'app_storage.dart';

/// Single source of truth for per-child learning state.
///
/// Every educational feature uses the currently active child. State is kept
/// in a separate namespace for each child so siblings never share progress,
/// rewards, purchases, badges, or exam results.
class ChildProgressRepository {
  static const _prefix = 'child_progress_v1.';
  static const _legacyKey = 'daleel_v5_state';

  static Future<String?> _childId() => AppStorage.activeId();

  static Future<String?> _key() async {
    final id = await _childId();
    if (id == null || id.isEmpty) return null;
    return '$_prefix$id';
  }

  static Future<Map<String, dynamic>> load() async {
    final p = await SharedPreferences.getInstance();
    final key = await _key();
    if (key == null) return {};
    final raw = p.getString(key);
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } catch (_) {
        // Recover below with an empty state rather than crashing the app.
      }
    }

    // One-time migration of the old global V5 state to the currently active
    // child. Existing data is preserved for the first active child.
    final legacyRaw = p.getString(_legacyKey);
    if (legacyRaw != null && legacyRaw.isNotEmpty) {
      try {
        final decoded = jsonDecode(legacyRaw);
        if (decoded is Map) {
          final state = Map<String, dynamic>.from(decoded);
          await save(state);
          return state;
        }
      } catch (_) {}
    }
    return {};
  }

  static Future<void> save(Map<String, dynamic> state) async {
    final p = await SharedPreferences.getInstance();
    final key = await _key();
    if (key == null) return;
    await p.setString(key, jsonEncode(state));
  }

  static Future<int> stars() async => _int((await load())['stars']);

  static Future<int> xp() async => _int((await load())['xp']);

  static Future<void> addRewards({required int stars, int xp = 0}) async {
    if (stars == 0 && xp == 0) return;
    final state = await load();
    state['stars'] = _int(state['stars']) + stars;
    state['xp'] = _int(state['xp']) + xp;
    await save(state);
  }

  static Future<bool> lessonDone(String id) async {
    final state = await load();
    final done = List<String>.from(state['done'] ?? const <String>[]);
    return done.contains(id);
  }

  static Future<void> finishLesson(String id, int stars) async {
    final state = await load();
    final done = List<String>.from(state['done'] ?? const <String>[]);
    if (!done.contains(id)) {
      done.add(id);
      state['stars'] = _int(state['stars']) + stars;
      state['xp'] = _int(state['xp']) + stars * 10;
    }
    state['done'] = done;
    await save(state);
  }

  static Future<void> recordFinalExam(
    String stageId,
    int score,
    int total,
    bool passed,
  ) async {
    final state = await load();
    final exams = Map<String, dynamic>.from(state['finalExams'] ?? const {});
    final previous = exams[stageId];
    final alreadyPassed = previous is Map && previous['passed'] == true;
    exams[stageId] = {
      'score': score,
      'total': total,
      'passed': passed,
      'date': DateTime.now().toIso8601String(),
      'attempts': _int(previous is Map ? previous['attempts'] : null) + 1,
      'bestScore': _bestScore(previous, score),
    };
    state['finalExams'] = exams;

    final badges = List<String>.from(state['badges'] ?? const <String>[]);
    if (passed) {
      final badge = 'ختم $stageId';
      if (!badges.contains(badge)) badges.add(badge);
      // The completion reward is granted only on the first successful pass.
      if (!alreadyPassed) {
        state['stars'] = _int(state['stars']) + 50;
        state['xp'] = _int(state['xp']) + 500;
      }
    }
    state['badges'] = badges;
    await save(state);
  }

  static Future<Map<String, dynamic>?> finalExam(String stageId) async {
    final state = await load();
    final exams = Map<String, dynamic>.from(state['finalExams'] ?? const {});
    final raw = exams[stageId];
    return raw is Map ? Map<String, dynamic>.from(raw) : null;
  }

  static Future<bool> owned(String itemId) async {
    final state = await load();
    final owned = List<String>.from(state['ownedItems'] ?? const <String>[]);
    return owned.contains(itemId);
  }

  static Future<bool> buy(String itemId, int price) async {
    final state = await load();
    final owned = List<String>.from(state['ownedItems'] ?? const <String>[]);
    if (owned.contains(itemId) || _int(state['stars']) < price) return false;
    state['stars'] = _int(state['stars']) - price;
    owned.add(itemId);
    state['ownedItems'] = owned;
    await save(state);
    return true;
  }

  static int _int(dynamic value) => value is num ? value.toInt() : 0;

  static int _bestScore(dynamic previous, int score) {
    final old = previous is Map ? _int(previous['bestScore']) : 0;
    return score > old ? score : old;
  }
}
