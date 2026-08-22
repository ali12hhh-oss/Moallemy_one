import 'package:shared_preferences/shared_preferences.dart';

import '../storage/child_progress_repository.dart';

class ParentServiceV22 {
  static Future<void> saveChild({
    required String id,
    required String name,
    required int grade,
  }) async {
    final p = await SharedPreferences.getInstance();
    await p.setString('child.$id.name', name);
    await p.setInt('child.$id.grade', grade);
  }

  /// Returns the report for the currently active child.
  static Future<Map<String, dynamic>> report(int grade) async {
    final exam = await ChildProgressRepository.finalExam(grade.toString());
    final progress = await ChildProgressRepository.load();
    return {
      'grade': grade,
      'stars': _int(progress['stars']),
      'xp': _int(progress['xp']),
      'arabicExam': exam == null ? 0 : _percent(exam['score'], exam['total']),
      'examPassed': exam?['passed'] == true,
      'examAttempts': exam?['attempts'] ?? 0,
    };
  }

  static int _int(dynamic value) => value is num ? value.toInt() : 0;

  static int _percent(dynamic score, dynamic total) {
    final s = score is num ? score.toDouble() : 0;
    final t = total is num ? total.toDouble() : 0;
    if (t <= 0) return 0;
    return (s / t * 100).round().clamp(0, 100);
  }
}
