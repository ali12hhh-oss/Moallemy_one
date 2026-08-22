import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../../data/games_v19.dart';

class GameEngineV19 {
  static final _r = Random();

  static GameRoundV19 letterHunter() {
    const letters = [
      'ب',
      'ت',
      'ث',
      'ج',
      'ح',
      'د',
      'ر',
      'س',
      'ش',
      'ص',
      'ك',
      'ل',
      'م',
      'ن',
    ];
    final a = letters[_r.nextInt(letters.length)];
    final opts = {...letters..shuffle(_r)}.take(4).toList();
    if (!opts.contains(a)) opts[0] = a;
    opts.shuffle(_r);
    return GameRoundV19('اعثر على الحرف: $a', a, opts);
  }

  static GameRoundV19 math() {
    final a = _r.nextInt(9) + 1, b = _r.nextInt(9) + 1;
    final ans = a + b;
    final opts = <int>{
      ans,
      ans + 1,
      ans - 1,
      ans + 2,
    }.where((x) => x >= 0).toList()..shuffle(_r);
    return GameRoundV19(
      'احسب: $a + $b',
      '$ans',
      opts.map((e) => '$e').toList(),
    );
  }

  static GameRoundV19 multiplication(int maxTable) {
    final a = _r.nextInt(maxTable) + 1, b = _r.nextInt(10) + 1;
    final ans = a * b;
    final opts = <int>{
      ans,
      ans + a,
      ans - a,
      ans + 1,
    }.where((x) => x >= 0).toList()..shuffle(_r);
    return GameRoundV19(
      'احسب: $a × $b',
      '$ans',
      opts.map((e) => '$e').toList(),
    );
  }

  static Future<void> finish(String gameId, int score) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(
      'game.$gameId.best',
      max(score, p.getInt('game.$gameId.best') ?? 0),
    );
    await p.setInt('child_xp_v15', (p.getInt('child_xp_v15') ?? 0) + score);
    await p.setInt(
      'child_stars_v15',
      (p.getInt('child_stars_v15') ?? 0) + (score ~/ 10),
    );
  }
}
