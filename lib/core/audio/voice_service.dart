import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';

import '../offline/asset_catalog_v27.dart';

/// Central audio service.
///
/// Letter sounds are intentionally different from letter-name/TTS speech:
/// Arabic letter buttons play the bundled recorded sound only. If an asset is
/// missing, nothing is spoken rather than risking teaching the letter name.
class VoiceService {
  static final FlutterTts _tts = FlutterTts();
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> arabic(String text) async {
    await _tts.setLanguage('ar-SA');
    await _tts.setSpeechRate(.42);
    await _tts.setPitch(1.08);
    await _tts.stop();
    await _tts.speak(text);
  }

  static Future<void> english(String text) async {
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
    if (!await _assetExists(assetPath)) return false;
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

  /// Plays the real recorded phoneme for an Arabic letter.
  ///
  /// No TTS fallback is used here because TTS can pronounce the *name* of the
  /// letter (باء، تاء...) instead of its reading sound. The repository ships
  /// the 28 Arabic letter recordings, so a missing asset is treated as an
  /// asset-integrity error rather than silently teaching the wrong sound.
  static Future<bool> arabicLetterSound(String letter, {
    String? fallbackText,
  }) => _playAsset(AssetCatalogV27.arabicAudio(letter));

  /// English phonics may use the bundled sound and can still use TTS as a
  /// fallback for legacy callers.
  static Future<void> englishLetterSound(
    String letter, {
    required String fallbackText,
  }) async {
    final played = await _playAsset(AssetCatalogV27.englishAudio(letter));
    if (!played) await english(fallbackText);
  }
}
