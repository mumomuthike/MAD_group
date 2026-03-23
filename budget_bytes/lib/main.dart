import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/budget_tracker_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/ai_meal_finder_screen.dart';

void main() {
  runApp(const BudgetBytesApp());
}

class BudgetBytesApp extends StatelessWidget {
  const BudgetBytesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Budget Bytes',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F9FC),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D47A1)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/home': (_) => const HomeScreen(),
        '/favorites': (_) => const FavoritesScreen(),
        '/budget': (_) => const BudgetTrackerScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/ai': (_) => const AiMealFinderScreen(),
      },
    );
  }
}
