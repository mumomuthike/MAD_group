// lib/screens/splash_screen.dart
//
// Screen 1 — Splash / Onboarding
//
// Purpose:
//   Shows the app logo and tagline while the SQLite database initializes.
//   Once the DB is ready, automatically navigates to HomeScreen.
//   If the user has never set up a profile, navigates to onboarding instead.

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  // Passed down from main.dart so Settings screen can toggle theme app-wide
  final ValueNotifier<bool> themeNotifier;

  const SplashScreen({super.key, required this.themeNotifier});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Animation
  // Logo fades in and slides up on launch
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  String? _errorMessage; // non-null if DB init fails

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  // ─── Build ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 120),
            const SizedBox(height: 20),
            const Text(
              'Budget Bytes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Eat well. Spend smart.',
              style: TextStyle(color: Color(0xFFFFD54F), fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // Error state — shown if DB fails to initialize
  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 56),
          const SizedBox(height: 16),
          Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 24),
          // Retry button re-runs initialization
          ElevatedButton(
            onPressed: () {
              setState(() => _errorMessage = null);
              _initializeApp();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primaryGreen,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
