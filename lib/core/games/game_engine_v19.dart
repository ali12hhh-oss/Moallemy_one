import 'dart:math';

import '../../data/games_v19.dart';
import '../storage/child_progress_repository.dart';

class GameEngineV19 {
  static final _r = Random();

  static GameRoundV19 letterHunter() {
    const letters = [
      'أ', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ', 'د', 'ذ', 'ر', 'ز', 'س', 'ش', 'ص',
      'ض', 'ط', 'ظ', 'ع', 'غ', 'ف', 'ق', 'ك', 'ل', 'م', 'ن', 'ه', 'و', 'ي',
    ];
    final a = letters[_r.nextInt(letters.length)];
    final opts = <String>{a};
    while (opts.length < 4) opts.add(letters[_r.nextInt(letters.length)]);
    final result = opts.toList()..shuffle(_r);
    return GameRoundV19('اعثر على الحرف: $a', a, result);
  }

  static GameRoundV19 math() {
    final a = _r.nextInt(9) + 1;
    final b = _r.nextInt(9) + 1;
    final ans = a + b;
    final opts = <int>{ans};
    for (var d = 1; opts.length < 4; d++) {
      if (ans - d >= 0) opts.add(ans - d);
      opts.add(ans + d);
    }
    final result = opts.toList()..shuffle(_r);
    return GameRoundV19('احسب: $a + $b', '$ans', result.map((e) => '$e').toList());
  }

  static GameRoundV19 multiplication(int maxTable) {
    final table = max(1, maxTable);
    final a = _r.nextInt(table) + 1;
    final b = _r.nextInt(10) + 1;
    final ans = a * b;
    final opts = <int>{ans};
    for (var d = 1; opts.length < 4; d++) {
      if (ans - d >= 0) opts.add(ans - d);
      opts.add(ans + d);
    }
    final result = opts.toList()..shuffle(_r);
    return GameRoundV19('احسب: $a × $b', '$ans', result.map((e) => '$e').toList());
  }

  static Future<void> finish(String gameId, int score) async {
    if (score <= 0) return;
    await ChildProgressRepository.recordGame(gameId, score);
  }

  static Future<int> best(String gameId) => ChildProgressRepository.gameBest(gameId);
}
