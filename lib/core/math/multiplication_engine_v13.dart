import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../adaptive/adaptive_learning_engine_v24.dart';

class MultiplicationSkillV13 {
  final int table;
  final int multiplier;
  final int attempts;
  final int correct;
  const MultiplicationSkillV13(
    this.table,
    this.multiplier,
    this.attempts,
    this.correct,
  );
  double get mastery => attempts == 0 ? 0 : correct / attempts;
  String get id => 'mul_${table}_$multiplier';
}

class MultiplicationEngineV13 {
  static const _key = 'multiplication_progress_v13';

  static Future<Map<String, int>> _load() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getStringList(_key) ?? <String>[];
    final result = <String, int>{};
    for (final item in raw) {
      final parts = item.split(':');
      if (parts.length == 2) result[parts[0]] = int.tryParse(parts[1]) ?? 0;
    }
    return result;
  }

  static Future<void> _save(Map<String, int> data) async {
    final p = await SharedPreferences.getInstance();
    final values = data.entries.map((e) => '${e.key}:${e.value}').toList();
    await p.setStringList(_key, values);
  }

  static Future<void> record({
    required int table,
    required int multiplier,
    required bool correct,
  }) async {
    final data = await _load();
    final key = '${table}_$multiplier';
    data[key] = (data[key] ?? 0) + (correct ? 100 : -40);
    if (data[key]! < 0) data[key] = 0;
    if (data[key]! > 1000) data[key] = 1000;
    await _save(data);
    await AdaptiveLearningEngineV24.record('multiplication_$table', correct);
  }

  static Future<int> mastery(int table) async {
    final data = await _load();
    var total = 0;
    for (var i = 1; i <= 10; i++) {
      total += data['${table}_$i'] ?? 0;
    }
    return min(100, (total / 100).round());
  }

  static Future<bool> isMastered(int table) async =>
      (await mastery(table)) >= 80;

  static Future<List<int>> weakMultipliers(int table) async {
    final data = await _load();
    final weak = <int>[];
    for (var i = 1; i <= 10; i++) {
      if ((data['${table}_$i'] ?? 0) < 80) weak.add(i);
    }
    return weak;
  }

  static Future<void> reset() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_key);
  }
}
