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
    'No preference',
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
    'Coffee Shop',
  ];

  // Price range labels (maps to 1–3 in DB)
  static const Map<int, String> priceRanges = {
    1: '\$',
    2: '\$\$',
    3: '\$\$\$',
  };

  // Mood options for AI Meal Finder
  static const List<String> moodOptions = [
    'Tired',
    'Stressed',
    'Celebrating',
    'Healthy',
  ];

  // Map mood options to cuisine type for AI Meal Finder
  static const Map<String, List<String>> moodToCuisines = {
    '😴 Tired':       ['Breakfast', 'Coffee Shop'],
    '😤 Stressed':    ['Fast Food', 'American'],
    '🎉 Celebrating': ['Italian', 'Pizza', 'Mexican'],
    '🥗 Healthy':     ['Healthy', 'Asian'],
  };

  // Maps meal budget label to a max price value in dollars
  static const List<String> mealBudgetOptions = [
    'Under \$5',
    'Under \$10',
    'Under \$15',
    'No limit',
  ];

  // Maps meal budget label to max dollar amount (null = no limit)
  static const Map<String, double?> mealBudgetValues = {
    'Under \$5':  5.0,
    'Under \$10': 10.0,
    'Under \$15': 15.0,
    'No limit':   null,
  };

  // 3. Time available → maps label to a max distance in miles
  static const List<String> timeOptions = [
    '15 min',
    '30 min',
    '45 min',
    '1 hour+',
  ];

  // Time label → max distance in miles
  static const Map<String, double> timeToMaxDistance = {
    '15 min':  0.25,
    '30 min':  0.5,
    '45 min':  0.75,
    '1 hour+': 1,
  };

  // Default max distance (miles)
  static const double defaultMaxDistance = 1.0;

  // Default weekly budget
  static const double defaultWeeklyBudget = 50.0;
}