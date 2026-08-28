import 'package:flutter/material.dart';

import '../core/audio/voice_service.dart';
import '../core/settings/app_preferences_v10.dart';
import '../core/theme/app_theme_v25.dart';
import '../features/home/home_screen.dart';
import '../features/splash/splash_screen.dart';

/// Stops any active page audio when navigation leaves one page for another.
/// Dialogs are intentionally ignored so opening/closing a dialog does not
/// interrupt educational audio on the page underneath it.
class _PageAudioNavigatorObserver extends NavigatorObserver {
  void _stopPageAudio(Route<dynamic>? route) {
    if (route is PageRoute<dynamic>) {
      VoiceService.stop();
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute<dynamic> && previousRoute is PageRoute<dynamic>) {
      VoiceService.stop();
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _stopPageAudio(route);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _stopPageAudio(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _stopPageAudio(oldRoute);
  }
}

class DaleelChildApp extends StatefulWidget {
  const DaleelChildApp({super.key});
  @override
  State<DaleelChildApp> createState() => _DaleelChildAppState();
}

class _DaleelChildAppState extends State<DaleelChildApp> {
  final prefs = AppPreferencesV10.instance;
  final _audioNavigatorObserver = _PageAudioNavigatorObserver();

  @override
  void initState() {
    super.initState();
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    await prefs.load();
    if (!mounted) return;
    await VoiceService.playWelcome();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: prefs,
    builder: (context, _) => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'معلمي',
      themeMode: prefs.themeMode,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      locale: const Locale('ar'),
      navigatorObservers: [_audioNavigatorObserver],
      home: const SplashScreen(),
      routes: {'/home': (_) => const HomeScreen()},
    ),
  );

  ThemeData _theme(Brightness brightness) =>
      brightness == Brightness.dark ? AppThemeV25.dark() : AppThemeV25.light();
}
