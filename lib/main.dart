import 'dart:async';

import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/audio/voice_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(VoiceService.preloadWelcome());
  runApp(const DaleelChildApp());
}
