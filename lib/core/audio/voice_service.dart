import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';

import '../offline/asset_catalog_v27.dart';
import '../settings/app_preferences_v10.dart';

/// Central audio service for the whole app.
///
/// Rules:
/// - A single Arabic letter is ALWAYS played as its reading sound from the
///   local phoneme asset. It must never fall back to Arabic TTS, because TTS
///   normally says the letter name (باء، تاء...) instead of its sound.
/// - A word, sentence, number or maths expression is spoken with Arabic/English
///   TTS according to its content.
/// - English letters use the local phoneme asset first, then TTS only if the
///   local asset is unavailable.
class VoiceService {
  static final FlutterTts _tts = FlutterTts();
  static final AudioPlayer _player = AudioPlayer();

  static bool get _enabled => AppPreferencesV10.instance.sounds;

  static const Map<String, String> _arabicLetterNames = {
    'أ': 'ألف',
    'ب': 'باء',
    'ت': 'تاء',
    'ث': 'ثاء',
    'ج': 'جيم',
    'ح': 'حاء',
    'خ': 'خاء',
    'د': 'دال',
    'ذ': 'ذال',
    'ر': 'راء',
    'ز': 'زاي',
    'س': 'سين',
    'ش': 'شين',
    'ص': 'صاد',
    'ض': 'ضاد',
    'ط': 'طاء',
    'ظ': 'ظاء',
    'ع': 'عين',
    'غ': 'غين',
    'ف': 'فاء',
    'ق': 'قاف',
    'ك': 'كاف',
    'ل': 'لام',
    'م': 'ميم',
    'ن': 'نون',
    'ه': 'هاء',
    'و': 'واو',
    'ي': 'ياء',
  };

  static bool _isArabicLetter(String text) {
    final value = text.trim();
    return value.runes.length == 1 && _arabicLetterNames.containsKey(value);
  }

  static bool _isEnglishLetter(String text) {
    final value = text.trim();
    return RegExp(r'^[A-Za-z]$').hasMatch(value);
  }

  static bool _containsArabic(String text) => RegExp(r'[\u0600-\u06FF]').hasMatch(text);

  static Future<void> _prepareTts({required String language}) async {
    await _tts.setLanguage(language);
    await _tts.setSpeechRate(.42);
    await _tts.setPitch(language.startsWith('ar') ? 1.08 : 1.05);
    await _tts.awaitSpeakCompletion(true);
  }

  /// Speaks normal educational content: words, sentences, numbers and maths.
  /// A lone letter is routed to the phoneme system instead of TTS.
  static Future<void> speak(String text, {String? language}) async {
    if (!_enabled) return;
    final value = text.trim();
    if (value.isEmpty) return;

    if (_isArabicLetter(value)) {
      await arabicLetterSound(value);
      return;
    }
    if (_isEnglishLetter(value)) {
      await englishLetterSound(value, fallbackText: value);
      return;
    }

    await stop();
    final lang = language ?? (_containsArabic(value) ? 'ar-SA' : 'en-US');
    await _prepareTts(language: lang);
    await _tts.speak(value);
  }

  static Future<void> arabic(String text) async {
    await speak(text, language: 'ar-SA');
  }

  static Future<void> english(String text) async {
    if (!_enabled) return;
    final value = text.trim();
    if (value.isEmpty) return;
    if (_isEnglishLetter(value)) {
      await englishLetterSound(value, fallbackText: value);
      return;
    }
    await stop();
    await _prepareTts(language: 'en-US');
    await _tts.speak(value);
  }

  /// Speaks the Arabic letter's NAME intentionally.
  /// This is reserved for UI such as the separate "اسم الحرف" control.
  static Future<void> arabicLetterName(String letter) async {
    if (!_enabled) return;
    final value = letter.trim();
    final name = _arabicLetterNames[value];
    if (name == null) return;
    await stop();
    await _prepareTts(language: 'ar-SA');
    await _tts.speak(name);
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
      await _tts.stop();
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

  /// Plays only the local Arabic phoneme. There is deliberately no TTS
  /// fallback, so the app can never teach the letter NAME here.
  static Future<bool> arabicLetterSound(String letter, {String? fallbackText}) async {
    final value = letter.trim();
    if (!_isArabicLetter(value)) return false;
    return _playAsset(AssetCatalogV27.arabicAudio(value));
  }

  static Future<void> englishLetterSound(
    String letter, {
    required String fallbackText,
  }) async {
    final value = letter.trim();
    final played = await _playAsset(AssetCatalogV27.englishAudio(value));
    if (!played) {
      await stop();
      await _prepareTts(language: 'en-US');
      await _tts.speak(fallbackText);
    }
  }
}
