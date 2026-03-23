// lib/utils/constants.dart
// App-wide constants for Budget Bytes
// Two layers:
//   AppConstants — SharedPreferences keys and AI matcher input lists
//   AppColors, AppTypography, AppSpacing, etc.

import 'package:flutter/material.dart';

// SharedPreferences keys & AI matcher config
class AppConstants {
  // SharedPreferences keys
  static const String keyWeeklyBudget     = 'weekly_budget';
  static const String keyDarkMode         = 'dark_mode';
  static const String keyDietaryPreference = 'dietary_preference';
  static const String keyMaxDistance      = 'max_distance';
  static const String keyUserId           = 'user_id';
  static const String keyOnboardingDone   = 'onboarding_done';

  // App branding (also in AppStrings — keep in sync)
  static const String appName    = 'Budget Bytes';
  static const String appTagline = 'Eat well. Spend smart.';

  // Dietary preference options (shown in Settings and Onboarding dropdowns)
  static const List<String> dietaryOptions = [
    'None',
    'Vegetarian',
    'Vegan',
    'Gluten-free',
  ];

  // AI Meal Finder inputs

  // 1. Mood: drives which cuisine types are prioritized in results
  static const List<String> moodOptions = [
    '😴 Tired',
    '😤 Stressed',
    '🎉 Celebrating',
    '🥗 Healthy',
  ];

  // Mood: cuisine priority list used by the matcher query
  static const Map<String, List<String>> moodToCuisines = {
    '😴 Tired':       ['American', 'Pizza', 'Breakfast', 'Coffee Shop'],
    '😤 Stressed':    ['Fast Food', 'Mexican', 'Asian', 'Coffee Shop'],
    '🎉 Celebrating': ['Italian', 'American'],
    '🥗 Healthy':     ['Healthy', 'Asian'],
  };

  // 2. Meal budget: maps label to a max price in dollars (null = no limit)
  static const List<String> mealBudgetOptions = [
    '💵 Under \$5',
    '💵 Under \$10',
    '💵 Under \$15',
    '💵 No limit',
  ];

  static const Map<String, double?> mealBudgetValues = {
    '💵 Under \$5':  5.0,
    '💵 Under \$10': 10.0,
    '💵 Under \$15': 15.0,
    '💵 No limit':   null,
  };

  // 3. Time available: maps label to max distance in miles
  // Less time = only nearby restaurants are realistic
  static const List<String> timeOptions = [
    '⏱ 15 min',
    '⏱ 30 min',
    '⏱ 45 min',
    '⏱ 1 hour+',
  ];

  static const Map<String, double> timeToMaxDistance = {
    '⏱ 15 min':  0.3,
    '⏱ 30 min':  0.6,
    '⏱ 45 min':  0.9,
    '⏱ 1 hour+': 5.0,
  };

  // Defaults
  static const double defaultMaxDistance  = 1.0;
  static const double defaultWeeklyBudget = 50.0;
}

// Design tokens

abstract final class AppColors {
  // Primary palette
  static const Color primary      = Color(0xFF057EE6);
  static const Color primaryDark  = Color(0xFF0462B8);
  static const Color primaryLight = Color(0xFF4AABFF);
  static const Color primaryFaint = Color(0xFFD6EAFF);

  static const Color error      = Color(0xFFBC1823);
  static const Color errorLight = Color(0xFFFFDAD9);

  static const Color gold      = Color(0xFFEEBA2B);
  static const Color goldLight = Color(0xFFFFF3C4);

  static const Color dark           = Color(0xFF111111);
  static const Color white          = Color(0xFFFFFFFF);
  static const Color background     = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  static const Color border         = Color(0xFFEEEEEE);

  static const Color textPrimary   = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF555555);
  static const Color textTertiary  = Color(0xFF888888);
  static const Color textDisabled  = Color(0xFFBBBBBB);

  // Budget indicator colors
  static const Color budgetSafe    = primary;
  static const Color budgetWarning = gold;
  static const Color budgetOver    = error;

  // Cuisine accent colors — used in home screen cards and chips
  static const Map<String, Color> cuisineAccents = {
    'American':    Color(0xFFBC1823),
    'Mexican':     Color(0xFFEEBA2B),
    'Asian':       Color(0xFF057EE6),
    'Pizza':       Color(0xFFE65C00),
    'Healthy':     Color(0xFF2E7D32),
    'Fast Food':   Color(0xFFEEBA2B),
    'Italian':     Color(0xFF8B0000),
    'Breakfast':   Color(0xFFE65C00),
    'Coffee Shop': Color(0xFF6D4C41),
  };

  // Price range dot colors
  static const Color priceOneDollar    = Color(0xFF2E7D32);
  static const Color priceTwoDollars   = Color(0xFF057EE6);
  static const Color priceThreeDollars = Color(0xFFBC1823);

  static Color cuisineAccent(String cuisine) =>
      cuisineAccents[cuisine] ?? primary;

  // Returns green/gold/red based on what % of budget is spent
  static Color budgetProgress(double spent, double budget) {
    if (budget <= 0) return primary;
    final pct = spent / budget;
    if (pct >= 1.0) return budgetOver;
    if (pct >= 0.75) return budgetWarning;
    return budgetSafe;
  }
}

abstract final class AppTypography {
  static const String fontDisplay = 'Fredoka'; // chunky display font
  static const String fontBody    = 'Nunito';  // rounded sans-serif
  static const String fontAccent  = 'Caveat';  // handwritten accent

  // Display
  static const TextStyle displayLarge = TextStyle(fontFamily: fontDisplay, fontSize: 52, fontWeight: FontWeight.w700, letterSpacing: -0.5, color: AppColors.textPrimary, height: 1.05);
  static const TextStyle displayMedium = TextStyle(fontFamily: fontDisplay, fontSize: 42, fontWeight: FontWeight.w700, letterSpacing: -0.3, color: AppColors.textPrimary, height: 1.08);
  static const TextStyle displaySmall = TextStyle(fontFamily: fontDisplay, fontSize: 34, fontWeight: FontWeight.w600, letterSpacing: -0.2, color: AppColors.textPrimary, height: 1.1);

  // Headline — Fredoka, used for screen titles and section headers
  static const TextStyle headlineLarge  = TextStyle(fontFamily: fontDisplay, fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.3, color: AppColors.textPrimary, height: 1.15);
  static const TextStyle headlineMedium = TextStyle(fontFamily: fontDisplay, fontSize: 24, fontWeight: FontWeight.w600, letterSpacing: -0.2, color: AppColors.textPrimary, height: 1.2);
  static const TextStyle headlineSmall  = TextStyle(fontFamily: fontDisplay, fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.1, color: AppColors.textPrimary, height: 1.25);

  // Title — Nunito, used for card titles and list items
  static const TextStyle titleLarge  = TextStyle(fontFamily: fontBody, fontSize: 17, fontWeight: FontWeight.w800, letterSpacing: -0.1, color: AppColors.textPrimary, height: 1.3);
  static const TextStyle titleMedium = TextStyle(fontFamily: fontBody, fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0, color: AppColors.textPrimary, height: 1.35);
  static const TextStyle titleSmall  = TextStyle(fontFamily: fontBody, fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0, color: AppColors.textPrimary, height: 1.4);

  // Body — Nunito
  static const TextStyle bodyLarge = TextStyle(fontFamily: fontBody, fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimary, height: 1.55);
  static const TextStyle body      = TextStyle(fontFamily: fontBody, fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textPrimary, height: 1.55);
  static const TextStyle bodySmall = TextStyle(fontFamily: fontBody, fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textSecondary, height: 1.5);

  // Labels & utility
  static const TextStyle buttonLabel      = TextStyle(fontFamily: fontBody, fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 0.2);
  static const TextStyle caption          = TextStyle(fontFamily: fontBody, fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.1, color: AppColors.textTertiary, height: 1.4);
  static const TextStyle chipLabel        = TextStyle(fontFamily: fontBody, fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static const TextStyle tabLabel         = TextStyle(fontFamily: fontBody, fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.1);
  static const TextStyle navLabelSelected = TextStyle(fontFamily: fontBody, fontSize: 11, fontWeight: FontWeight.w800);
  static const TextStyle navLabel         = TextStyle(fontFamily: fontBody, fontSize: 11, fontWeight: FontWeight.w500);
  static const TextStyle listTitle        = TextStyle(fontFamily: fontBody, fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static const TextStyle inputHint        = TextStyle(fontFamily: fontBody, fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textDisabled);
  static const TextStyle inputLabel       = TextStyle(fontFamily: fontBody, fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary);
  static const TextStyle inputError       = TextStyle(fontFamily: fontBody, fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.error);
  static const TextStyle appBarTitle      = TextStyle(fontFamily: fontDisplay, fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.2, color: AppColors.white);
  static const TextStyle dialogTitle      = TextStyle(fontFamily: fontDisplay, fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.1, color: AppColors.textPrimary);

  // Accent — Caveat handwritten font
  static const TextStyle accentLarge  = TextStyle(fontFamily: fontAccent, fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: AppColors.textPrimary);
  static const TextStyle accentMedium = TextStyle(fontFamily: fontAccent, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.3, color: AppColors.textSecondary);
  static const TextStyle accentSmall  = TextStyle(fontFamily: fontAccent, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.2, color: AppColors.textTertiary);

  // Eyebrow — "NEAR YOU", "THIS WEEK", section sub-labels
  static const TextStyle eyebrow  = TextStyle(fontFamily: fontAccent, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: AppColors.textTertiary);
  static const TextStyle priceTag = TextStyle(fontFamily: fontAccent, fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0.8, color: AppColors.gold);
  static const TextStyle overline = TextStyle(fontFamily: fontAccent, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.6, color: AppColors.textTertiary);

  // Splash screen specific
  static const TextStyle splashTitle    = TextStyle(fontFamily: fontDisplay, fontSize: 36, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: AppColors.white);
  static const TextStyle splashSubtitle = TextStyle(fontFamily: fontAccent, fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 0.3, color: AppColors.gold);
}

abstract final class AppSpacing {
  static const double xxs = 2.0;
  static const double xs  = 4.0;
  static const double sm  = 8.0;
  static const double md  = 16.0;
  static const double lg  = 24.0;
  static const double xl  = 32.0;
  static const double xxl = 48.0;

  static const double screenPadding       = 20.0;
  static const double sectionGap          = 28.0;
  static const double cardInnerPadding    = 16.0;
  static const double listItemSpacing     = 12.0;
  static const double horizontalCardWidth  = 168.0;
  static const double horizontalCardHeight = 210.0;
}

abstract final class AppRadius {
  static const double xs           = 6.0;
  static const double sm           = 10.0;
  static const double card         = 16.0;
  static const double cardLarge    = 20.0;
  static const double chip         = 28.0;
  static const double button       = 14.0;
  static const double input        = 14.0;
  static const double fab          = 18.0;
  static const double bottomSheet  = 28.0;
  static const double dialog       = 24.0;
  static const double snackBar     = 14.0;
  static const double badge        = 24.0;
  static const double emojiSquare  = 14.0;
}

abstract final class AppSizing {
  static const double buttonHeight      = 54.0;
  static const double inputHeight       = 50.0;
  static const double appBarHeight      = 56.0;
  static const double heroHeight        = 220.0;
  static const double bottomNavHeight   = 64.0;
  static const double emojiSquare       = 62.0;
  static const double emojiSquareSm     = 46.0;
  static const double iconSm            = 16.0;
  static const double iconMd            = 22.0;
  static const double iconLg            = 28.0;
  static const double avatarSm          = 36.0;
  static const double avatarMd          = 48.0;
  static const double avatarLg          = 72.0;
  static const double budgetBannerHeight = 138.0;
  static const double progressBarHeight  = 6.0;
}

abstract final class AppDurations {
  static const Duration instant  = Duration(milliseconds: 100);
  static const Duration fast     = Duration(milliseconds: 200);
  static const Duration normal   = Duration(milliseconds: 300);
  static const Duration medium   = Duration(milliseconds: 500);
  static const Duration slow     = Duration(milliseconds: 700);
  static const Duration heroAnim = Duration(milliseconds: 900);
  static const Duration splash   = Duration(seconds: 2);
}

abstract final class AppRoutes {
  static const String splash     = '/';
  static const String home       = '/home';
  static const String restaurant = '/restaurant';
  static const String budget     = '/budget';
  static const String saved      = '/saved';
  static const String ai         = '/ai';
  static const String settings   = '/settings';
  static const String onboarding = '/onboarding';
}

abstract final class AppStrings {
  static const String appName  = 'Budget Bytes';
  static const String tagline  = 'Eat well. Spend smart.';

  static const String homeHero        = 'What are you\ncraving?';
  static const String nearYou         = 'Near You';
  static const String browseVibe      = 'Browse by Vibe';
  static const String allRestaurants  = 'All Restaurants';

  static const String budgetTitle  = 'My Budget';
  static const String weeklyBudget = 'Weekly Budget';
  static const String thisWeek     = 'THIS WEEK';
  static const String spent        = 'spent';
  static const String left         = 'left';
  static const String addMeal      = 'Add Meal';

  static const String savedTitle = 'Saved Places';
  static const String noSaved    = 'Nothing saved yet.\nTap ♥ on any restaurant.';

  static const String aiTitle      = 'AI Pick';
  static const String aiSubtitle   = 'Tell me your mood and budget.';
  static const String aiLoading    = 'Finding your perfect meal…';

  static const String settingsTitle  = 'Settings';
  static const String editProfile    = 'Edit Profile';
  static const String clearData      = 'Clear My Data';

  static const String genericError = 'Something went wrong. Please try again.';

  static const String cancel  = 'Cancel';
  static const String confirm = 'Confirm';
  static const String save    = 'Save';
  static const String delete  = 'Delete';
  static const String done    = 'Done';
  static const String edit    = 'Edit';
  static const String close   = 'Close';
  static const String seeAll  = 'See all';
}

// Cuisine helpers — emoji and accent color lookup used by home + AI screens
abstract final class AppCuisine {
  // Full list including Coffee Shop
  static const List<String> all = [
    'All',
    'American',
    'Mexican',
    'Asian',
    'Pizza',
    'Healthy',
    'Fast Food',
    'Italian',
    'Breakfast',
    'Coffee Shop',
  ];

  static const Map<String, String> emojis = {
    'American':    '🍔',
    'Mexican':     '🌮',
    'Asian':       '🍜',
    'Pizza':       '🍕',
    'Healthy':     '🥗',
    'Fast Food':   '🍟',
    'Italian':     '🍝',
    'Breakfast':   '🥞',
    'Coffee Shop': '☕',
  };

  static String emoji(String cuisine) => emojis[cuisine] ?? '🍽️';
  static Color accent(String cuisine) => AppColors.cuisineAccent(cuisine);
}

// Price range display helpers
abstract final class AppPrice {
  // Returns $, $$, or $$$
  static String symbol(int range) => '\$' * range.clamp(1, 3);

  // Color-codes price: green = budget, blue = mid, red = splurge
  static Color color(int range) {
    switch (range) {
      case 1:  return AppColors.priceOneDollar;
      case 2:  return AppColors.priceTwoDollars;
      case 3:  return AppColors.priceThreeDollars;
      default: return AppColors.textTertiary;
    }
  }

  static String label(int range) {
    switch (range) {
      case 1:  return 'Budget-friendly';
      case 2:  return 'Mid-range';
      case 3:  return 'Splurge';
      default: return '';
    }
  }
}