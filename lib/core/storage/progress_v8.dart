import 'child_progress_repository.dart';

/// Backward-compatible facade kept for existing screens.
/// All state is now stored per active child by ChildProgressRepository.
class ProgressV8 {
  static Future<Map<String, dynamic>> load() => ChildProgressRepository.load();

  static Future<void> save(Map<String, dynamic> state) =>
      ChildProgressRepository.save(state);

  static Future<bool> lessonDone(String id) =>
      ChildProgressRepository.lessonDone(id);

  static Future<void> finishLesson(String id, int stars) =>
      ChildProgressRepository.finishLesson(id, stars);

  static Future<int> stars() => ChildProgressRepository.stars();

  static Future<int> xp() => ChildProgressRepository.xp();

  static Future<void> addRewards({required int stars, int xp = 0}) =>
      ChildProgressRepository.addRewards(stars: stars, xp: xp);

  static Future<void> recordFinalExam(
    String stageId,
    int score,
    int total,
    bool passed,
  ) =>
      ChildProgressRepository.recordFinalExam(stageId, score, total, passed);

  static Future<Map<String, dynamic>?> finalExam(String stageId) =>
      ChildProgressRepository.finalExam(stageId);
}
