// lib/main.dart
//
// App entry point. Responsibilities:
//   1. Initialize SharedPreferences and read saved theme preference
//   2. Pass theme state down via ValueNotifier so any screen can toggle dark mode
//   3. Hand off to SplashScreen, which initializes the DB before showing Home

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/splash_screen.dart';
import 'utils/app_theme.dart';
import 'utils/constants.dart';

void main() async {
  // Required before any async work in main()
  WidgetsFlutterBinding.ensureInitialized();

  // Read saved dark mode preference — defaults to false (light mode)
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool(AppConstants.keyDarkMode) ?? false;

  runApp(BudgetBytesApp(isDark: isDark));
}

class BudgetBytesApp extends StatefulWidget {
  final bool isDark;

  const BudgetBytesApp({super.key, required this.isDark});

  @override
  State<BudgetBytesApp> createState() => _BudgetBytesAppState();
}

class _BudgetBytesAppState extends State<BudgetBytesApp> {
  // ValueNotifier lets the Settings screen toggle the theme without
  // needing a state management package — any screen can call
  // themeNotifier.value = true to switch to dark mode app-wide.
  late final ValueNotifier<bool> _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = ValueNotifier(widget.isDark);
  }

  @override
  void dispose() {
    _isDarkMode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder rebuilds only the MaterialApp when theme changes —
    // avoids rebuilding the entire widget tree unnecessarily.
    return ValueListenableBuilder<bool>(
      valueListenable: _isDarkMode,
      builder: (context, isDark, _) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,

          // Light and dark themes defined in app_theme.dart
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

          // SplashScreen runs first — it initializes the DB then navigates to Home
          home: SplashScreen(themeNotifier: _isDarkMode),
        );
      },
    );
  }
}