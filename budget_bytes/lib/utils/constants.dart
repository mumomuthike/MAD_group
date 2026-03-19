// lib/utils/constants.dart
// App-wide constants for Budget Bytes

class AppConstants {
  // App info
  static const String appName = 'Budget Bytes';
  static const String appTagline = 'Eat smart. Spend less.';

  // SharedPreferences keys
  static const String keyWeeklyBudget = 'weekly_budget';
  static const String keyDarkMode = 'dark_mode';
  static const String keyDietaryPreference = 'dietary_preference';
  static const String keyMaxDistance = 'max_distance';
  static const String keyUserId = 'user_id';
  static const String keyOnboardingDone = 'onboarding_done';

  // Dietary preference options
  static const List<String> dietaryOptions = [
    'None',
    'Vegetarian',
    'Vegan',
    'Gluten-free',
  ];

  // Cuisine types for filters
  static const List<String> cuisineTypes = [
    'All',
    'American',
    'Mexican',
    'Asian',
    'Italian',
    'Fast Food',
    'Healthy',
    'Pizza',
    'Breakfast',
  ];

  // Price range labels (maps to 1–3 in DB)
  static const Map<int, String> priceRanges = {
    1: '\$',
    2: '\$\$',
    3: '\$\$\$',
  };

  // Mood options for AI Meal Finder (empty for now)
  static const List<String> moodOptions = [];

  // Default max distance (miles)
  static const double defaultMaxDistance = 1.0;

  // Default weekly budget
  static const double defaultWeeklyBudget = 50.0;
}