
import 'package:shared_preferences/shared_preferences.dart';

class ParentServiceV22 {
  static Future<void> saveChild({required String id,required String name,required int grade}) async {
    final p = await SharedPreferences.getInstance();
    await p.setString('child.$id.name', name);
    await p.setInt('child.$id.grade', grade);
  }

  static Future<Map<String,dynamic>> report(int grade) async {
    final p = await SharedPreferences.getInstance();
    return {
      'grade': grade,
      'stars': p.getInt('child_stars_v15') ?? 0,
      'xp': p.getInt('child_xp_v15') ?? 0,
      'arabicExam': p.getInt('exam.$grade.percent') ?? 0,
      'examPassed': p.getBool('exam.$grade.passed') ?? false,
    };
  }
}
