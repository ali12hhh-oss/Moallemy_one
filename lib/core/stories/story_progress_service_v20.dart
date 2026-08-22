import '../storage/child_progress_repository.dart';

class StoryProgressServiceV20 {
  static Future<void> complete(
    String id, {
    required int questionsCorrect,
  }) =>
      ChildProgressRepository.completeStory(id, questionsCorrect);

  static Future<bool> completed(String id) =>
      ChildProgressRepository.storyCompleted(id);
}
