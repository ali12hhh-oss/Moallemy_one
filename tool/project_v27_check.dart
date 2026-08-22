import 'dart:io';

void main() {
  final required = [
    'lib/data/english_curriculum_v17.dart',
    'lib/core/audio/offline_audio_service_v18.dart',
    'lib/core/games/game_engine_v19.dart',
    'lib/data/stories_v20.dart',
    'lib/core/exams/exam_service_v21.dart',
    'lib/core/parent/parent_service_v22.dart',
    'lib/core/store/store_service_v23.dart',
    'lib/core/adaptive/adaptive_learning_engine_v24.dart',
    'lib/core/theme/app_theme_v25.dart',
    'lib/core/offline/offline_content_registry_v26.dart',
  ];
  final missing = required.where((p) => !File(p).existsSync()).toList();
  if (missing.isNotEmpty) {
    stderr.writeln('Missing project components: $missing');
    exitCode = 1;
    return;
  }
  stdout.writeln('V17-V27 project component check: OK');
}
