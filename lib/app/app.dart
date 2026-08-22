import 'package:flutter/material.dart';

import '../core/settings/app_preferences_v10.dart';
import '../core/theme/app_theme_v25.dart';
import '../features/home/home_screen.dart';

class DaleelChildApp extends StatefulWidget {
  const DaleelChildApp({super.key});
  @override
  State<DaleelChildApp> createState() => _DaleelChildAppState();
}

class _DaleelChildAppState extends State<DaleelChildApp> {
  final prefs = AppPreferencesV10.instance;
  @override
  void initState() {
    super.initState();
    prefs.load();
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
          home: const HomeScreen(),
        ),
      );
  ThemeData _theme(Brightness brightness) =>
      brightness == Brightness.dark ? AppThemeV25.dark() : AppThemeV25.light();
}
