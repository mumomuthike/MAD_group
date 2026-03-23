// lib/screens/splash_screen.dart
//
// Screen 1 — Splash / Onboarding
//
// Purpose:
//   Shows the app logo and tagline while the SQLite database initializes.
//   Once the DB is ready, automatically navigates to HomeScreen.
//   If the user has never set up a profile, navigates to onboarding instead.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/database_helper.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';

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
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // Fade: 0 to 1 opacity over the full animation duration
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Slide: starts 30px below final position, rises into place
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        );

    _controller.forward(); // start animation immediately
  }

  // ─── App initialization ──────────────────────────────────────────────────────
  Future<void> _initializeApp() async {
    try {
      // Open (or create) the SQLite database.
      // If this is first launch, _onCreate runs and seeds all restaurant data.
      await DatabaseHelper.instance.database;

      // Wait for the animation to finish before navigating — feels more polished
      await Future.wait([
        Future.delayed(const Duration(milliseconds: 1800)),
        _controller.forward(), // no-op if already done
      ]);

      if (!mounted) return; // widget may have been disposed during await
      _navigateNext();
    } catch (e) {
      // DB failed — show error so the user isn't stuck on a blank splash
      if (mounted) {
        setState(() => _errorMessage = 'Failed to load app data. Please restart.');
      }
    }
  }

  // ─── Navigation ──────────────────────────────────────────────────────────────
  Future<void> _navigateNext() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(AppConstants.keyUserId);

    if (!mounted) return;

    if (userId == null) {
      // First launch — no user record exists yet, go to onboarding
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => OnboardingScreen(themeNotifier: widget.themeNotifier),
        ),
      );
    } else {
      // Returning user — go straight to home
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            userId: userId,
            themeNotifier: widget.themeNotifier,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ─── Build ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Solid green background — matches brand color
      backgroundColor: AppTheme.primaryGreen,
      body: SafeArea(
        child: Center(
          child: _errorMessage != null
              ? _buildErrorState()
              : _buildSplashContent(),
        ),
      ),
    );
  }

  // Normal splash — animated logo + tagline + loading indicator
  Widget _buildSplashContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App icon container
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Center(
                child: Text(
                  '🍽️',
                  style: TextStyle(fontSize: 52),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // App name
            Text(
              AppConstants.appName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 8),

            // Tagline
            Text(
              AppConstants.appTagline,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.3,
              ),
            ),

            const SizedBox(height: 60),

            // Loading indicator — white to stay visible on green background
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2.5,
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