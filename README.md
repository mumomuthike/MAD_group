# MAD_group
budget_bytes/
├── pubspec.yaml
├── .gitignore
├── README.md
└── lib/
    ├── main.dart                    # App entry point & theme setup
    ├── database/
    │   └── database_helper.dart     # SQLite setup, all CRUD operations
    ├── models/
    │   ├── user.dart
    │   ├── restaurant.dart
    │   ├── menu_item.dart
    │   ├── budget_entry.dart
    │   ├── saved_meal.dart
    │   ├── class_schedule.dart
    │   └── ai_suggestion.dart
    ├── screens/
    │   ├── splash_screen.dart       # Screen 1 — Splash / onboarding
    │   ├── home_screen.dart         # Screen 2 — Home / Discover
    │   ├── restaurant_details_screen.dart  # Screen 3 — Restaurant details
    │   ├── budget_tracker_screen.dart      # Screen 4 — Budget tracker
    │   ├── ai_meal_finder_screen.dart      # Screen 5 — AI Meal Finder
    │   ├── favorites_screen.dart           # Screen 6 — Favorites & Reviews
    │   └── settings_screen.dart            # Screen 7 — Settings
    ├── widgets/
    │   ├── restaurant_card.dart     # Reusable restaurant card widget
    └── utils/
        ├── constants.dart           # App-wide constants (colors, strings)
        └── app_theme.dart           # Light & dark theme definitions