import 'dart:io';

void main() {
  final requiredFiles = <String>[
    'assets/content_manifest_v27.json',
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
    'lib/core/offline/asset_catalog_v27.dart',
  ];
  final missing = requiredFiles.where((p) => !File(p).existsSync()).toList();
  if (missing.isNotEmpty) {
    stderr.writeln('Missing: $missing');
    exit(1);
  }

  final dirs = [
    Directory('assets/images/arabic'),
    Directory('assets/images/english'),
    Directory('assets/images/stories'),
    Directory('assets/images/games'),
    Directory('assets/images/store'),
    Directory('assets/audio/arabic'),
    Directory('assets/audio/english'),
  ];
  for (final d in dirs) {
    if (!d.existsSync()) {
      stderr.writeln('Missing directory: ${d.path}');
      exit(1);
    }
  }
  print('V27.1 integrity: OK');
}
