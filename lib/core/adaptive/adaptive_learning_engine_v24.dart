import '../storage/child_progress_repository.dart';

/// Adaptive learning state scoped to the active child.
class AdaptiveLearningEngineV24 {
  static Future<void> record(String skill, bool correct) =>
      ChildProgressRepository.recordAdaptive(skill, correct);

  static Future<Map<String, int>> summary() async {
    final data = await ChildProgressRepository.adaptiveData();
    var attempts = 0;
    var successes = 0;
    for (final item in data.values) {
      attempts += item['attempts'] ?? 0;
      successes += item['successes'] ?? 0;
    }
    return {'attempts': attempts, 'successes': successes};
  }

  static Future<List<String>> weakSkills() async {
    final data = await ChildProgressRepository.adaptiveData();
    final weak = <String>[];
    for (final entry in data.entries) {
      final attempts = entry.value['attempts'] ?? 0;
      final successes = entry.value['successes'] ?? 0;
      // Do not classify a skill from a single answer. Five attempts provide
      // a minimally useful signal for this local adaptive engine.
      if (attempts >= 5 && successes / attempts < .8) weak.add(entry.key);
    }
    return weak;
  }

  static Future<String> recommendation(List<String> skills) async {
    if (skills.isEmpty) return '';
    final data = await ChildProgressRepository.adaptiveData();
    String? weakest;
    double bestScore = double.infinity;
    var bestAttempts = -1;

    for (final skill in skills) {
      final item = data[skill];
      final attempts = item?['attempts'] ?? 0;
      final successes = item?['successes'] ?? 0;
      final rate = attempts == 0 ? 0.0 : successes / attempts;
      // Prefer genuinely measured weak skills; if tied, prefer the one with
      // more evidence. Unseen skills are recommended only when nothing has
      // enough evidence yet.
      final score = attempts < 5 ? 1.01 + attempts * .001 : rate;
      if (score < bestScore || (score == bestScore && attempts > bestAttempts)) {
        bestScore = score;
        bestAttempts = attempts;
        weakest = skill;
      }
    }
    return weakest ?? skills.first;
  }
}
