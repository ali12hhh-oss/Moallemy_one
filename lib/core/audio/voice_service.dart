import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';

import '../offline/asset_catalog_v27.dart';
import '../settings/app_preferences_v10.dart';

/// Central audio service for the whole app.
class VoiceService {
  static final FlutterTts _tts = FlutterTts();
  static final AudioPlayer _player = AudioPlayer();
  static final AudioPlayer _feedbackPlayer = AudioPlayer();
  static final AudioPlayer _welcomePlayer = AudioPlayer();
  static Future<void>? _welcomePreload;
  static int _playRequest = 0;

  static bool get _enabled => AppPreferencesV10.instance.sounds;
  static bool get _feedbackEnabled =>
      AppPreferencesV10.instance.sounds &&
      AppPreferencesV10.instance.feedbackSounds;

  static const Map<String, String> _arabicLetterNames = {
    'أ': 'ألف', 'ب': 'باء', 'ت': 'تاء', 'ث': 'ثاء', 'ج': 'جيم',
    'ح': 'حاء', 'خ': 'خاء', 'د': 'دال', 'ذ': 'ذال', 'ر': 'راء',
    'ز': 'زاي', 'س': 'سين', 'ش': 'شين', 'ص': 'صاد', 'ض': 'ضاد',
    'ط': 'طاء', 'ظ': 'ظاء', 'ع': 'عين', 'غ': 'غين', 'ف': 'فاء',
    'ق': 'قاف', 'ك': 'كاف', 'ل': 'لام', 'م': 'ميم', 'ن': 'نون',
    'ه': 'هاء', 'و': 'واو', 'ي': 'ياء',
  };

  static bool _isArabicLetter(String text) {
    final value = text.trim();
    return value.runes.length == 1 && _arabicLetterNames.containsKey(value);
  }

  static bool _isEnglishLetter(String text) =>
      RegExp(r'^[A-Za-z]$').hasMatch(text.trim());

  static bool _containsArabic(String text) =>
      RegExp(r'[\u0600-\u06FF]').hasMatch(text);

  static Future<void> _prepareTts({required String language}) async {
    await _tts.setLanguage(language);
    await _tts.setSpeechRate(.42);
    await _tts.setPitch(language.startsWith('ar') ? 1.08 : 1.05);
    await _tts.awaitSpeakCompletion(true);
  }

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

  static Future<void> arabic(String text) async =>
      speak(text, language: 'ar-SA');

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

  static Future<void> arabicLetterName(String letter) async {
    if (!_enabled) return;
    final value = letter.trim();
    final name = _arabicLetterNames[value];
    if (name == null) return;
    await stop();
    await _prepareTts(language: 'ar-SA');
    await _tts.speak(name);
  }

  /// Stops all active educational audio, while leaving the startup welcome
  /// clip untouched when navigation happens away from the splash screen.
  static Future<void> stopEducational() async {
    _playRequest++;
    await _tts.stop();
    await _player.stop();
    await _feedbackPlayer.stop();
  }

  static Future<void> stop() async {
    await stopEducational();
    await _welcomePlayer.stop();
  }

  static Future<void> preloadWelcome() {
    return _welcomePreload ??= _welcomePlayer.setSource(
      AssetSource('audio/welcome.mp3', mimeType: 'audio/mpeg'),
    );
  }

  static Future<bool> _playAsset(String assetPath) async {
    if (!_enabled) return false;
    final request = ++_playRequest;
    try {
      await _tts.stop();
      await _player.stop();
      if (request != _playRequest) return false;
      await _player.setReleaseMode(ReleaseMode.stop);
      final relative = assetPath.startsWith('assets/')
          ? assetPath.substring('assets/'.length)
          : assetPath;
      final lowerPath = assetPath.toLowerCase();
      final mimeType = lowerPath.endsWith('.ogg')
          ? 'audio/ogg'
          : lowerPath.endsWith('.wav')
              ? 'audio/wav'
              : 'audio/mpeg';
      await _player.play(
        AssetSource(relative, mimeType: mimeType),
        volume: 1.0,
      );
      return request == _playRequest;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> _playFeedbackAsset(String assetPath) async {
    if (!_feedbackEnabled) return false;
    final request = ++_playRequest;
    try {
      await _tts.stop();
      await _feedbackPlayer.stop();
      if (request != _playRequest) return false;
      await _feedbackPlayer.setReleaseMode(ReleaseMode.stop);
      final relative = assetPath.startsWith('assets/')
          ? assetPath.substring('assets/'.length)
          : assetPath;
      await _feedbackPlayer.play(
        AssetSource(relative, mimeType: 'audio/mpeg'),
        volume: 1.0,
      );
      return request == _playRequest;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> playWelcome() async {
    if (!_feedbackEnabled) return false;
    final request = ++_playRequest;
    try {
      await preloadWelcome();
      await _tts.stop();
      await _player.stop();
      if (request != _playRequest) return false;
      await _welcomePlayer.stop();
      await _welcomePlayer.setReleaseMode(ReleaseMode.stop);
      await _welcomePlayer.seek(Duration.zero);
      if (request != _playRequest) return false;
      await _welcomePlayer.resume();
      return request == _playRequest;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> playCorrect() =>
      _playFeedbackAsset('assets/audio/correct.mp3');

  static Future<bool> playTryAgain() =>
      _playFeedbackAsset('assets/audio/try_again.mp3');

  static Future<bool> arabicLetterSound(
    String letter, {
    String? fallbackText,
  }) async {
    final value = letter.trim();
    if (!_isArabicLetter(value)) return false;
    final played = await _playAsset(AssetCatalogV27.arabicAudio(value));
    if (!played && fallbackText != null && fallbackText.trim().isNotEmpty) {
      await stop();
      await _prepareTts(language: 'ar-SA');
      await _tts.speak(fallbackText.trim());
    }
    return played;
  }

  static Future<void> englishLetterSound(
    String letter, {
    required String fallbackText,
  }) async {
    final value = letter.trim().toLowerCase();
    if (!_isEnglishLetter(value)) return;

    final played = await _playAsset(AssetCatalogV27.englishAudio(value));
    const replacementLetters = <String>{
      'e', 'f', 'i', 'l', 'm', 'n', 'q', 'r', 's', 'u', 'v', 'x', 'z',
    };
    if (replacementLetters.contains(value)) return;

    if (!played) {
      await stop();
      await _prepareTts(language: 'en-US');
      await _tts.speak(fallbackText.trim());
    }
  }
}
