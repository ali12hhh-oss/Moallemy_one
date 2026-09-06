import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../data/store_v23.dart';
import 'app_storage.dart';

/// Single source of truth for per-child learning state.
class ChildProgressRepository {
  static const _prefix = 'child_progress_v1.';
  static const _legacyKey = 'daleel_v5_state';
  static const _legacyMigratedKey = 'child_progress_v1.legacy_migrated';
  static const _backgroundKey = 'selectedBackground';

  static Future<String?> _key() async {
    final id = await AppStorage.activeId();
    if (id == null || id.isEmpty) return null;
    return '$_prefix$id';
  }

  static Future<String?> _legacyTargetId() async {
    final children = await AppStorage.getChildren();
    if (children.isEmpty) return null;
    return children.first.id;
  }

  static Future<Map<String, dynamic>> load() async {
    final p = await SharedPreferences.getInstance();
    final id = await AppStorage.activeId();
    if (id == null || id.isEmpty) return {};
    final key = '$_prefix$id';
    final raw = p.getString(key);
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map) {
          final state = Map<String, dynamic>.from(decoded);
          if (_normalizeOwnedItems(state)) await save(state);
          await _syncChildSnapshot(state, id);
          return state;
        }
      } catch (_) {}
    }
    if (p.getBool(_legacyMigratedKey) != true) {
      final targetId = await _legacyTargetId();
      if (targetId == id) {
        final legacyRaw = p.getString(_legacyKey);
        if (legacyRaw != null && legacyRaw.isNotEmpty) {
          try {
            final decoded = jsonDecode(legacyRaw);
            if (decoded is Map) {
              final state = Map<String, dynamic>.from(decoded);
              _normalizeOwnedItems(state);
              await save(state);
              await p.setBool(_legacyMigratedKey, true);
              await _syncChildSnapshot(state, id);
              return state;
            }
          } catch (_) {}
        }
        await p.setBool(_legacyMigratedKey, true);
      }
    }
    return {};
  }

  static Future<void> save(Map<String, dynamic> state) async {
    final p = await SharedPreferences.getInstance();
    final key = await _key();
    if (key == null) return;
    await p.setString(key, jsonEncode(state));
    final id = await AppStorage.activeId();
    if (id != null && id.isNotEmpty) await _syncChildSnapshot(state, id);
  }

  /// Mirrors canonical progress into the Child model used by profile screens.
  static Future<void> _syncChildSnapshot(
    Map<String, dynamic> state,
    String childId,
  ) async {
    final children = await AppStorage.getChildren();
    final index = children.indexWhere((child) => child.id == childId);
    if (index < 0) return;

    final child = children[index];
    final adaptive = Map<String, dynamic>.from(state['adaptive'] ?? const {});
    var attempts = 0;
    var successes = 0;
    final weak = <String>[];

    for (final entry in adaptive.entries) {
      final item = Map<String, dynamic>.from(entry.value ?? const {});
      final itemAttempts = _int(item['attempts']);
      final itemSuccesses = _int(item['successes']);
      attempts += itemAttempts;
      successes += itemSuccesses;
      if (itemAttempts >= 5 && itemSuccesses / itemAttempts < .8) {
        weak.add(entry.key);
      }
    }

    child.stars = _int(state['stars'], child.stars);
    child.lessons = _int(state['lessons'], child.lessons);
    child.quizzes = _int(state['quizzes'], child.quizzes);
    child.correct = successes;
    child.total = attempts;
    child.minutes = _int(state['minutes'], child.minutes);
    child.streak = _int(state['streak'], child.streak);

    final storedWeak = state['weakItems'];
    if (storedWeak is List) {
      child.weakItems = storedWeak.map((e) => e.toString()).toList();
    } else {
      child.weakItems = weak;
    }

    final owned = state['ownedItems'];
    if (owned is List) {
      child.ownedItems = owned.map((e) => e.toString()).toList();
    }

    await AppStorage.saveChildren(children);
  }

  static Future<int> stars() async => _int((await load())['stars']);
  static Future<int> xp() async => _int((await load())['xp']);

  static Future<void> addRewards({required int stars, int xp = 0}) async {
    final safeStars = stars < 0 ? 0 : stars;
    final safeXp = xp < 0 ? 0 : xp;
    if (safeStars == 0 && safeXp == 0) return;
    final state = await load();
    state['stars'] = _int(state['stars']) + safeStars;
    state['xp'] = _int(state['xp']) + safeXp;
    await save(state);
  }

  static Future<int> skillMastery(String skillId) async {
    final state = await load();
    final skills = Map<String, dynamic>.from(state['skillMastery'] ?? const {});
    return _int(skills[skillId]);
  }

  static Future<void> recordSkill(String skillId, bool correct) async {
    final state = await load();
    final skills = Map<String, dynamic>.from(state['skillMastery'] ?? const {});
    skills[skillId] = (_int(skills[skillId]) + (correct ? 10 : -5)).clamp(0, 100);
    state['skillMastery'] = skills;
    final adaptive = Map<String, dynamic>.from(state['adaptive'] ?? const {});
    final item = Map<String, dynamic>.from(adaptive[skillId] ?? const {});
    item['attempts'] = _int(item['attempts']) + 1;
    item['successes'] = _int(item['successes']) + (correct ? 1 : 0);
    item['lastAt'] = DateTime.now().millisecondsSinceEpoch;
    adaptive[skillId] = item;
    state['adaptive'] = adaptive;
    if (correct) {
      state['stars'] = _int(state['stars']) + 1;
      state['xp'] = _int(state['xp']) + 5;
    }
    await save(state);
  }

  static Future<void> recordAdaptive(String skillId, bool correct) async {
    final state = await load();
    final adaptive = Map<String, dynamic>.from(state['adaptive'] ?? const {});
    final item = Map<String, dynamic>.from(adaptive[skillId] ?? const {});
    item['attempts'] = _int(item['attempts']) + 1;
    item['successes'] = _int(item['successes']) + (correct ? 1 : 0);
    item['lastAt'] = DateTime.now().millisecondsSinceEpoch;
    adaptive[skillId] = item;
    state['adaptive'] = adaptive;
    await save(state);
  }

  static Future<Map<String, Map<String, int>>> adaptiveData() async {
    final state = await load();
    final raw = Map<String, dynamic>.from(state['adaptive'] ?? const {});
    final result = <String, Map<String, int>>{};
    for (final entry in raw.entries) {
      final item = Map<String, dynamic>.from(entry.value ?? const {});
      result[entry.key] = {
        'attempts': _int(item['attempts']),
        'successes': _int(item['successes']),
        'lastAt': _int(item['lastAt']),
      };
    }
    return result;
  }

  static Future<void> recordGame(String gameId, int score) async {
    final safeScore = score < 0 ? 0 : score;
    final state = await load();
    final bests = Map<String, dynamic>.from(state['gameBests'] ?? const {});
    final oldBest = _int(bests[gameId]);
    final improvement = safeScore - oldBest;
    if (improvement <= 0) return;
    bests[gameId] = safeScore;
    state['gameBests'] = bests;
    state['stars'] = _int(state['stars']) + improvement ~/ 10;
    state['xp'] = _int(state['xp']) + improvement;
    await save(state);
  }

  static Future<int> gameBest(String gameId) async {
    final state = await load();
    final bests = Map<String, dynamic>.from(state['gameBests'] ?? const {});
    return _int(bests[gameId]);
  }

  static Future<void> completeStory(String id, int questionsCorrect) async {
    final state = await load();
    final stories = Map<String, dynamic>.from(state['stories'] ?? const {});
    final previous = stories[id];
    final oldBest = previous is Map ? _int(previous['bestScore']) : 0;
    final alreadyCompleted = previous is Map && previous['completed'] == true;
    stories[id] = {
      'completed': true,
      'score': questionsCorrect,
      'bestScore': _max(oldBest, questionsCorrect),
      'attempts': _int(previous is Map ? previous['attempts'] : null) + 1,
      'completedAt': DateTime.now().toIso8601String(),
    };
    state['stories'] = stories;
    if (!alreadyCompleted) {
      state['stars'] = _int(state['stars']) + questionsCorrect;
      state['xp'] = _int(state['xp']) + questionsCorrect * 5;
    }
    await save(state);
  }

  static Future<bool> storyCompleted(String id) async {
    final state = await load();
    final stories = Map<String, dynamic>.from(state['stories'] ?? const {});
    final raw = stories[id];
    return raw is Map && raw['completed'] == true;
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
      final safeStars = stars < 0 ? 0 : stars;
      state['stars'] = _int(state['stars']) + safeStars;
      state['xp'] = _int(state['xp']) + safeStars * 10;
      state['lessons'] = _int(state['lessons']) + 1;
    }
    state['done'] = done;
    await save(state);
  }

  static Future<void> recordFinalExam(String stageId, int score, int total, bool passed) async {
    final state = await load();
    final exams = Map<String, dynamic>.from(state['finalExams'] ?? const {});
    final previous = exams[stageId];
    final alreadyPassed = previous is Map && previous['passed'] == true;
    final safeTotal = total < 0 ? 0 : total;
    final safeScore = score.clamp(0, safeTotal).toInt();
    exams[stageId] = {
      'score': safeScore,
      'total': safeTotal,
      'passed': passed,
      'date': DateTime.now().toIso8601String(),
      'attempts': _int(previous is Map ? previous['attempts'] : null) + 1,
      'bestScore': _max(_int(previous is Map ? previous['bestScore'] : null), safeScore),
    };
    state['finalExams'] = exams;
    state['quizzes'] = _int(state['quizzes']) + 1;

    // Include final-exam answers in the same accuracy stream used by the
    // parent dashboard and child profile.
    final adaptive = Map<String, dynamic>.from(state['adaptive'] ?? const {});
    final skillId = 'final_exam:$stageId';
    final item = Map<String, dynamic>.from(adaptive[skillId] ?? const {});
    item['attempts'] = _int(item['attempts']) + safeTotal;
    item['successes'] = _int(item['successes']) + safeScore;
    item['lastAt'] = DateTime.now().millisecondsSinceEpoch;
    adaptive[skillId] = item;
    state['adaptive'] = adaptive;

    if (passed) {
      final badges = List<String>.from(state['badges'] ?? const <String>[]);
      final badge = 'ختم $stageId';
      if (!badges.contains(badge)) badges.add(badge);
      if (!alreadyPassed) {
        state['stars'] = _int(state['stars']) + 50;
        state['xp'] = _int(state['xp']) + 500;
      }
      state['badges'] = badges;
    }
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

  static Future<String?> selectedBackground() async {
    final state = await load();
    final value = state[_backgroundKey];
    return value is String && value.trim().isNotEmpty ? value : null;
  }

  static Future<void> setSelectedBackground(String? backgroundId) async {
    final state = await load();
    if (backgroundId == null || backgroundId.trim().isEmpty) {
      state.remove(_backgroundKey);
    } else {
      state[_backgroundKey] = backgroundId.trim();
    }
    await save(state);
  }

  static Future<bool> buy(String itemId, int price, {String? title}) async {
    final safePrice = price < 0 ? 0 : price;
    final state = await load();
    final owned = List<String>.from(state['ownedItems'] ?? const <String>[]);
    if (owned.contains(itemId) || _int(state['stars']) < safePrice) return false;

    state['stars'] = _int(state['stars']) - safePrice;
    owned.add(itemId);
    if (title != null && title.trim().isNotEmpty) {
      owned.removeWhere((item) => item.startsWith('title:'));
      owned.add('title:${title.trim()}');
    }
    state['ownedItems'] = owned;
    await save(state);
    return true;
  }

  static bool _normalizeOwnedItems(Map<String, dynamic> state) {
    final raw = state['ownedItems'];
    if (raw is! List) return false;

    final items = raw.map((e) => e.toString()).toList(growable: true);
    final normalized = <String>[];
    var changed = false;

    for (final item in items) {
      if (!item.startsWith('title:')) {
        if (!normalized.contains(item)) normalized.add(item);
        continue;
      }

      final title = item.substring(6).trim();
      final reward = rewardsV23.cast<RewardItemV23?>().firstWhere(
        (candidate) => candidate?.type == 'ألقاب' && candidate?.title == title,
        orElse: () => null,
      );

      if (reward != null) {
        if (!normalized.contains(reward.id)) normalized.add(reward.id);
        if (!normalized.contains(item)) normalized.add(item);
        if (!items.contains(reward.id)) changed = true;
      } else {
        if (!normalized.contains(item)) normalized.add(item);
      }
    }

    if (normalized.length != items.length ||
        normalized.asMap().entries.any((entry) => entry.value != items[entry.key])) {
      changed = true;
    }

    if (changed) state['ownedItems'] = normalized;
    return changed;
  }

  static int _int(dynamic value, [int fallback = 0]) =>
      value is num ? value.toInt() : (int.tryParse(value?.toString() ?? '') ?? fallback);
  static int _max(int a, int b) => a > b ? a : b;
}
