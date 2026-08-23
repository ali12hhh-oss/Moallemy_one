import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';

import '../offline/asset_catalog_v27.dart';
import '../settings/app_preferences_v10.dart';

/// Central audio service. The global sound preference is respected by every
/// speech/audio entry point.
class VoiceService {
  static final FlutterTts _tts = FlutterTts();
  static final AudioPlayer _player = AudioPlayer();

  static bool get _enabled => AppPreferencesV10.instance.sounds;

  static Future<void> arabic(String text) async {
    if (!_enabled) return;
    await _tts.setLanguage('ar-SA');
    await _tts.setSpeechRate(.42);
    await _tts.setPitch(1.08);
    await _tts.stop();
    await _tts.speak(text);
  }

  static Future<void> english(String text) async {
    if (!_enabled) return;
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(.42);
    await _tts.setPitch(1.05);
    await _tts.stop();
    await _tts.speak(text);
  }

  static Future<void> stop() async {
    await _tts.stop();
    await _player.stop();
  }

  static Future<bool> _assetExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> _playAsset(String assetPath) async {
    if (!_enabled || !await _assetExists(assetPath)) return false;
    try {
      await _player.stop();
      final relative = assetPath.startsWith('assets/')
          ? assetPath.substring('assets/'.length)
          : assetPath;
      await _player.play(AssetSource(relative));
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Plays only the real recorded Arabic phoneme. There is deliberately no
  /// TTS fallback because TTS may teach the letter name (باء، تاء...) instead
  /// of the reading sound.
  static Future<bool> arabicLetterSound(
    String letter, {
    String? fallbackText,
  }) => _playAsset(AssetCatalogV27.arabicAudio(letter));

  static Future<void> englishLetterSound(
    String letter, {
    required String fallbackText,
  }) async {
    final played = await _playAsset(AssetCatalogV27.englishAudio(letter));
    if (!played) await english(fallbackText);
  }
}
