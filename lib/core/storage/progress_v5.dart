import 'child_progress_repository.dart';

/// Legacy facade. Kept so older imports compile while all writes are routed to
/// the active child's current progress store.
class ProgressV5 {
  static Future<Map<String, dynamic>> load() => ChildProgressRepository.load();

  static Future<void> save(Map<String, dynamic> state) =>
      ChildProgressRepository.save(state);

  static Future<int> stars() => ChildProgressRepository.stars();

  static Future<bool> lessonDone(String id) =>
      ChildProgressRepository.lessonDone(id);

  static Future<void> finishLesson(String id, int reward) =>
      ChildProgressRepository.finishLesson(id, reward);

  static Future<bool> buy(String id, int price) =>
      ChildProgressRepository.buy(id, price);
}
