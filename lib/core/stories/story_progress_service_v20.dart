
import 'package:shared_preferences/shared_preferences.dart';

class StoryProgressServiceV20 {
  static Future<void> complete(String id, {required int questionsCorrect}) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('story.$id.completed', true);
    await p.setInt('story.$id.score', questionsCorrect);
    await p.setInt('child_stars_v15',
      (p.getInt('child_stars_v15') ?? 0) + questionsCorrect);
    await p.setInt('child_xp_v15',
      (p.getInt('child_xp_v15') ?? 0) + questionsCorrect * 5);
  }
}
