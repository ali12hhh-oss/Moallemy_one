
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineAudioServiceV18 {
  static const _volumeKey = 'audio_volume_v18';
  static double volume = 1.0;

  static Future<void> init() async {
    final p = await SharedPreferences.getInstance();
    volume = p.getDouble(_volumeKey) ?? 1.0;
  }

  static Future<void> setVolume(double value) async {
    volume = value.clamp(0.0, 1.0);
    final p = await SharedPreferences.getInstance();
    await p.setDouble(_volumeKey, volume);
  }

  // This method validates the local asset path before playback.
  // Connect it to the project's audio player implementation when its
  // dependency is present; no network URL is ever used.
  static Future<bool> assetExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (_) {
      return false;
    }
  }
}
