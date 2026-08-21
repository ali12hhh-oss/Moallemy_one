
import 'package:shared_preferences/shared_preferences.dart';

class ExamServiceV21 {
  static Future<void> saveResult({
    required int grade,
    required int score,
    required int total,
  }) async {
    final p = await SharedPreferences.getInstance();
    final percent = total == 0 ? 0 : ((score * 100) ~/ total);
    await p.setInt('exam.$grade.score', score);
    await p.setInt('exam.$grade.total', total);
    await p.setInt('exam.$grade.percent', percent);
    await p.setBool('exam.$grade.passed', percent >= 70);
  }
  static Future<Map<String,dynamic>> result(int grade) async {
    final p = await SharedPreferences.getInstance();
    return {
      'score': p.getInt('exam.$grade.score') ?? 0,
      'total': p.getInt('exam.$grade.total') ?? 0,
      'percent': p.getInt('exam.$grade.percent') ?? 0,
      'passed': p.getBool('exam.$grade.passed') ?? false,
    };
  }
}
