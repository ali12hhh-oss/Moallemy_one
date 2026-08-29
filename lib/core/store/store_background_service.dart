import '../storage/child_progress_repository.dart';

class StoreBackgroundService {
  static const originalId = 'original';

  static Future<String> selectedId() async =>
      await ChildProgressRepository.selectedBackground() ?? originalId;

  static Future<bool> isOwned(String backgroundId) =>
      ChildProgressRepository.owned(backgroundId);

  static Future<bool> apply(String backgroundId) async {
    if (backgroundId != originalId &&
        !await ChildProgressRepository.owned(backgroundId)) {
      return false;
    }
    await ChildProgressRepository.setSelectedBackground(
      backgroundId == originalId ? null : backgroundId,
    );
    return true;
  }

  static Future<void> restoreOriginal() async {
    await ChildProgressRepository.setSelectedBackground(null);
  }
}
