import 'package:shared_preferences/shared_preferences.dart';

class StoreServiceV23 {
  static Future<int> stars() async {
    final p = await SharedPreferences.getInstance();
    return p.getInt('child_stars_v15') ?? 0;
  }

  static Future<bool> buy(String id, int price) async {
    final p = await SharedPreferences.getInstance();
    final stars = p.getInt('child_stars_v15') ?? 0;
    if (stars < price || p.getBool('store.$id') == true) return false;
    await p.setInt('child_stars_v15', stars - price);
    await p.setBool('store.$id', true);
    return true;
  }

  static Future<bool> owned(String id) async {
    final p = await SharedPreferences.getInstance();
    return p.getBool('store.$id') ?? false;
  }
}
