import 'package:flutter/material.dart';

import '../core/audio/voice_service.dart';
import '../core/settings/app_preferences_v10.dart';
import '../core/theme/app_theme_v25.dart';
import '../features/home/home_screen.dart';
import '../features/splash/splash_screen.dart';

/// Stops active educational page audio when navigating between pages.
/// The startup welcome player is kept independent so the greeting can finish
/// while the splash screen transitions into the home screen.
class _PageAudioNavigatorObserver extends NavigatorObserver {
  void _stopPageAudio() {
    VoiceService.stopEducational();
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (previousRoute is PageRoute<dynamic>) {
      _stopPageAudio();
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _stopPageAudio();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _stopPageAudio();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _stopPageAudio();
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
    final welcome = VoiceService.playWelcome();
    await prefs.load();
    if (!mounted) return;
    await welcome;
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
