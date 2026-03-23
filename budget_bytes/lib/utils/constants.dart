import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppColors {
  // The  palette
  static const Color primary = Color(0xFF057EE6);
  static const Color primaryDark = Color(0xFF0462B8);
  static const Color primaryLight = Color(0xFF4AABFF);
  static const Color primaryFaint = Color(0xFFD6EAFF);

  static const Color error = Color(0xFFBC1823);
  static const Color errorLight = Color(0xFFFFDAD9);

  static const Color gold = Color(0xFFEEBA2B);
  static const Color goldLight = Color(0xFFFFF3C4);

  static const Color dark = Color(0xFF111111);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  static const Color border = Color(0xFFEEEEEE);

  static const Color textPrimary = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF555555);
  static const Color textTertiary = Color(0xFF888888);
  static const Color textDisabled = Color(0xFFBBBBBB);

  static const Color budgetSafe = primary;
  static const Color budgetWarning = gold;
  static const Color budgetOver = error;

  static const Map<String, Color> cuisineAccents = {
    'American': Color(0xFFBC1823),
    'Mexican': Color(0xFFEEBA2B),
    'Asian': Color(0xFF057EE6),
    'Pizza': Color(0xFFE65C00),
    'Healthy': Color(0xFF2E7D32),
    'Fast Food': Color(0xFFEEBA2B),
    'Italian': Color(0xFF8B0000),
    'Breakfast': Color(0xFFE65C00),
  };

  static const Color priceOneDollar = Color(0xFF2E7D32);
  static const Color priceTwoDollars = Color(0xFF057EE6);
  static const Color priceThreeDollars = Color(0xFFBC1823);

  static Color cuisineAccent(String cuisine) =>
      cuisineAccents[cuisine] ?? primary;

  static Color budgetProgress(double spent, double budget) {
    if (budget <= 0) return primary;
    final pct = spent / budget;
    if (pct >= 1.0) return budgetOver;
    if (pct >= 0.75) return budgetWarning;
    return budgetSafe;
  }
}

abstract final class AppTypography {
  // Base Getters
  static TextStyle get fontDisplay => GoogleFonts.sourGummy();
  static TextStyle get fontBody => GoogleFonts.fresca();
  static TextStyle get fontAccent => GoogleFonts.caveat();

  // --- Display Styles (SOur Gummy) ---
  static final TextStyle displayLarge = fontDisplay.copyWith(
    fontSize: 52,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
    height: 1.05,
  );
  static final TextStyle displayMedium = fontDisplay.copyWith(
    fontSize: 42,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    color: AppColors.textPrimary,
    height: 1.08,
  );
  static final TextStyle displaySmall = fontDisplay.copyWith(
    fontSize: 34,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
    height: 1.1,
  );

  // --- Headline Styles (Fredoka) ---
  static final TextStyle headlineLarge = fontDisplay.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    color: AppColors.textPrimary,
    height: 1.15,
  );
  static final TextStyle headlineMedium = fontDisplay.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  static final TextStyle headlineSmall = fontDisplay.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    color: AppColors.textPrimary,
    height: 1.25,
  );

  // --- Title Styles (Nunito) ---
  static final TextStyle titleLarge = fontBody.copyWith(
    fontSize: 17,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.1,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  static final TextStyle titleMedium = fontBody.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: AppColors.textPrimary,
    height: 1.35,
  );
  static final TextStyle titleSmall = fontBody.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // --- Body Styles (Nunito) ---
  static final TextStyle bodyLarge = fontBody.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.textPrimary,
    height: 1.55,
  );
  static final TextStyle body = fontBody.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.textPrimary,
    height: 1.55,
  );
  static final TextStyle bodySmall = fontBody.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // --- Label Styles (Nunito) ---
  static final TextStyle buttonLabel = fontBody.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.2,
  );
  static final TextStyle caption = fontBody.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: AppColors.textTertiary,
    height: 1.4,
  );
  static final TextStyle chipLabel = fontBody.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );
  static final TextStyle tabLabel = fontBody.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
  );
  static final TextStyle navLabelSelected = fontBody.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w800,
  );
  static final TextStyle navLabel = fontBody.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle listTitle = fontBody.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static final TextStyle inputHint = fontBody.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textDisabled,
  );
  static final TextStyle inputLabel = fontBody.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );
  static final TextStyle inputError = fontBody.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.error,
  );

  // --- Specific Component Styles (Fredoka) ---
  static final TextStyle appBarTitle = fontDisplay.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    color: AppColors.white,
  );
  static final TextStyle dialogTitle = fontDisplay.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.1,
    color: AppColors.textPrimary,
  );
  static final TextStyle splashTitle = fontDisplay.copyWith(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: AppColors.white,
  );

  // --- Accent Styles (Caveat) ---
  static final TextStyle accentLarge = fontAccent.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );
  static final TextStyle accentMedium = fontAccent.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    color: AppColors.textSecondary,
  );
  static final TextStyle accentSmall = fontAccent.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: AppColors.textTertiary,
  );
  static final TextStyle eyebrow = fontAccent.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    color: AppColors.textTertiary,
  );
  static final TextStyle priceTag = fontAccent.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    color: AppColors.gold,
  );
  static final TextStyle overline = fontAccent.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.6,
    color: AppColors.textTertiary,
  );
  static final TextStyle splashSubtitle = fontAccent.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    color: AppColors.gold,
  );
}

abstract final class AppSpacing {
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  static const double screenPadding = 20.0;
  static const double sectionGap = 28.0;
  static const double cardInnerPadding = 16.0;
  static const double listItemSpacing = 12.0;
  static const double horizontalCardWidth = 168.0;
  static const double horizontalCardHeight = 210.0;
}

abstract final class AppRadius {
  static const double xs = 6.0;
  static const double sm = 10.0;
  static const double card = 16.0;
  static const double cardLarge = 20.0;
  static const double chip = 28.0; // pill-shaped
  static const double button = 14.0;
  static const double input = 14.0;
  static const double fab = 18.0;
  static const double bottomSheet = 28.0;
  static const double dialog = 24.0;
  static const double snackBar = 14.0;
  static const double badge = 24.0;
  static const double emojiSquare = 14.0;
}

abstract final class AppSizing {
  static const double buttonHeight = 54.0;
  static const double inputHeight = 50.0;
  static const double appBarHeight = 56.0;
  static const double heroHeight = 220.0;
  static const double bottomNavHeight = 64.0;
  static const double emojiSquare = 62.0;
  static const double emojiSquareSm = 46.0;
  static const double iconSm = 16.0;
  static const double iconMd = 22.0;
  static const double iconLg = 28.0;
  static const double avatarSm = 36.0;
  static const double avatarMd = 48.0;
  static const double avatarLg = 72.0;
  static const double budgetBannerHeight = 138.0;
  static const double progressBarHeight = 6.0;
}

abstract final class AppDurations {
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration medium = Duration(milliseconds: 500);
  static const Duration slow = Duration(milliseconds: 700);
  static const Duration heroAnim = Duration(milliseconds: 900);
  static const Duration splash = Duration(seconds: 2);
}

abstract final class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String restaurant = '/restaurant';
  static const String menuItem = '/menu-item';
  static const String budget = '/budget';
  static const String saved = '/saved';
  static const String ai = '/ai';
  static const String profile = '/profile';
  static const String schedule = '/schedule';
  static const String onboarding = '/onboarding';
}

abstract final class AppAssets {
  static const String logo = 'assets/logo.png';
  static const String placeholder = 'assets/placeholder.png';
  static const String loadingAnim = 'assets/animations/loading.json';
  static const String successAnim = 'assets/animations/success.json';
  static const String emptyAnim = 'assets/animations/empty.json';
}

abstract final class AppStrings {
  static const String appName = 'Budget Bytes';
  static const String tagline = 'Eat well. Spend smart.';

  static const String homeHero = 'What are you\ncraving?';
  static const String nearYou = 'Near You';
  static const String browseVibe = 'Browse by Vibe';
  static const String allRestaurants = 'All Restaurants';

  static const String budgetTitle = 'My Budget';
  static const String weeklyBudget = 'Weekly Budget';
  static const String thisWeek = 'THIS WEEK';
  static const String spent = 'spent';
  static const String left = 'left';
  static const String addMeal = 'Add Meal';

  static const String savedTitle = 'Saved Places';
  static const String noSaved = 'Nothing saved yet.\nTap ♥ on any restaurant.';

  static const String aiTitle = 'AI Pick';
  static const String aiSubtitle = 'Tell me your mood and budget.';
  static const String aiPromptHint =
      'e.g. "cheap and filling for 30 min break"';
  static const String aiLoading = 'Finding your perfect meal…';

  static const String scheduleTitle = 'My Classes';
  static const String addClass = 'Add Class';

  static const String profileTitle = 'Profile';
  static const String editProfile = 'Edit Profile';
  static const String clearData = 'Clear My Data';

  static const String genericError = 'Something went wrong. Please try again.';
  static const String noInternet = 'No internet connection.';
  static const String notFound = 'Not found.';

  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String done = 'Done';
  static const String edit = 'Edit';
  static const String close = 'Close';
  static const String seeAll = 'See all';
}

abstract final class AppCuisine {
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
  ];

  static const Map<String, String> emojis = {
    'American': '🍔',
    'Mexican': '🌮',
    'Asian': '🍜',
    'Pizza': '🍕',
    'Healthy': '🥗',
    'Fast Food': '🍟',
    'Italian': '🍝',
    'Breakfast': '🥞',
  };

  static String emoji(String cuisine) => emojis[cuisine] ?? '🍽️';
  static Color accent(String cuisine) => AppColors.cuisineAccent(cuisine);
}

abstract final class AppPrice {
  static String symbol(int range) => '\$' * range.clamp(1, 3);

  static Color color(int range) {
    switch (range) {
      case 1:
        return AppColors.priceOneDollar;
      case 2:
        return AppColors.priceTwoDollars;
      case 3:
        return AppColors.priceThreeDollars;
      default:
        return AppColors.textTertiary;
    }
  }

  static String label(int range) {
    switch (range) {
      case 1:
        return 'Budget-friendly';
      case 2:
        return 'Mid-range';
      case 3:
        return 'Splurge';
      default:
        return '';
    }
  }
}
