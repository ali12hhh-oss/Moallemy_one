import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferencesV10 extends ChangeNotifier {
  static final AppPreferencesV10 instance = AppPreferencesV10._();
  AppPreferencesV10._();
  ThemeMode themeMode = ThemeMode.light;
  bool sounds = true;
  bool effects = true;
  int sessionMinutes = 20;
  bool _loaded = false;
  Future<void> load() async {
    if (_loaded) return;
    final p = await SharedPreferences.getInstance();
    themeMode = (p.getBool('dark_mode_v10') ?? false)
        ? ThemeMode.dark
        : ThemeMode.light;
    sounds = p.getBool('sounds_v10') ?? true;
    effects = p.getBool('effects_v10') ?? true;
    sessionMinutes = p.getInt('session_minutes_v10') ?? 20;
    _loaded = true;
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    themeMode = value ? ThemeMode.dark : ThemeMode.light;
    final p = await SharedPreferences.getInstance();
    await p.setBool('dark_mode_v10', value);
    notifyListeners();
  }

  Future<void> setSounds(bool value) async {
    sounds = value;
    final p = await SharedPreferences.getInstance();
    await p.setBool('sounds_v10', value);
    notifyListeners();
  }

  Future<void> setEffects(bool value) async {
    effects = value;
    final p = await SharedPreferences.getInstance();
    await p.setBool('effects_v10', value);
    notifyListeners();
  }

  Future<void> setSessionMinutes(int value) async {
    sessionMinutes = value;
    final p = await SharedPreferences.getInstance();
    await p.setInt('session_minutes_v10', value);
    notifyListeners();
  }
}
