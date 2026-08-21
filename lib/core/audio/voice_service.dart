import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../offline/asset_catalog_v27.dart';

/// Speech/audio service.
///
/// [arabic]/[english]/[stop] behave exactly as before (device TTS for
/// arbitrary text) so every existing call site keeps working unchanged.
///
/// [arabicLetterSound]/[englishLetterSound] are additive: they play the
/// real recorded offline WAV asset for a single letter/pattern when one
/// exists in the bundle (via [AssetCatalogV27]), and only fall back to
/// TTS when no matching asset is shipped. This makes the previously
/// unused offline audio assets actually audible in the app.
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

  /// Returns true if [assetPath] actually exists in the app bundle.
  static Future<bool> _assetExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Plays a bundled offline WAV for [assetPath] and reports success.
  static Future<bool> _playAsset(String assetPath) async {
    if (!await _assetExists(assetPath)) return false;
    try {
      await _player.stop();
      // AssetSource paths are relative to the `assets/` folder declared
      // in pubspec.yaml, so strip the leading "assets/".
      final relative = assetPath.startsWith('assets/')
          ? assetPath.substring('assets/'.length)
          : assetPath;
      await _player.play(AssetSource(relative));
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Plays the real recorded sound for an Arabic letter offline when the
  /// asset is available; otherwise falls back to TTS speaking [fallbackText].
  static Future<void> arabicLetterSound(String letter, {required String fallbackText}) async {
    final played = await _playAsset(AssetCatalogV27.arabicAudio(letter));
    if (!played) await arabic(fallbackText);
  }

  /// Plays the real recorded sound for an English letter/phonics pattern
  /// offline when the asset is available; otherwise falls back to TTS
  /// speaking [fallbackText].
  static Future<void> englishLetterSound(String letter, {required String fallbackText}) async {
    final played = await _playAsset(AssetCatalogV27.englishAudio(letter));
    if (!played) await english(fallbackText);
  }
}
