import '../storage/child_progress_repository.dart';

class StoreServiceV23 {
  static Future<int> stars() => ChildProgressRepository.stars();

  static Future<bool> buy(String id, int price, {String? title}) =>
      ChildProgressRepository.buy(id, price, title: title);

  static Future<bool> owned(String id) => ChildProgressRepository.owned(id);
}
