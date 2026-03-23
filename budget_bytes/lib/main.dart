import 'package:flutter/material.dart';
import 'package:budget_bytes/models/menu_item.dart';
import 'package:budget_bytes/models/restaurant.dart';
import 'package:budget_bytes/models/saved_meal.dart';
import 'package:budget_bytes/models/user.dart';
import 'package:budget_bytes/screens/ai_meal_finder_screen.dart';
import 'package:budget_bytes/screens/favorites_screen.dart';
import 'package:budget_bytes/screens/restaurant_details_screen.dart';
import 'package:budget_bytes/screens/settings_screen.dart';
import 'package:budget_bytes/screens/splash_screen.dart';
import 'package:budget_bytes/screens/home_screen.dart';
import 'package:budget_bytes/utils/app_theme.dart';
import 'package:budget_bytes/utils/constants.dart';
import 'package:budget_bytes/screens/budget_tracker_screen.dart';
import 'package:budget_bytes/models/budget_entry.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final double weeklyBudget = 60.0; // Matches your sampleUser budget
    final List<BudgetEntry> entries = [];
    final sampleRestaurants = <Restaurant>[
      Restaurant(
        id: 1,
        name: 'Blue Plate Cafe',
        cuisineType: 'Breakfast',
        address: '123 Campus Dr',
        priceRange: 1,
        openHours: '8:00 AM - 3:00 PM',
        distanceFromCampus: 0.4,
      ),
      Restaurant(
        id: 2,
        name: 'Taco Spot',
        cuisineType: 'Mexican',
        address: '456 College Ave',
        priceRange: 2,
        openHours: '10:00 AM - 10:00 PM',
        distanceFromCampus: 1.1,
      ),
    ];

    final sampleMenu = <MenuItem>[
      MenuItem(
        id: 1,
        restaurantId: 1,
        name: 'Pancake Combo',
        price: 8.99,
        category: 'Breakfast',
        dietaryInfo: 'Vegetarian',
      ),
      MenuItem(
        id: 2,
        restaurantId: 1,
        name: 'Iced Coffee',
        price: 3.50,
        category: 'Drinks',
        dietaryInfo: 'None',
      ),
    ];

    final sampleSaved = <SavedMeal>[
      SavedMeal(
        id: 1,
        userId: 1,
        restaurantId: 1,
        mealName: 'Pancake Combo',
        price: 8.99,
        personalRating: 4.5,
        saveDate: '2026-03-22',
      ),
    ];

    final sampleUser = User(
      id: 1,
      name: 'Mumo',
      weeklyBudget: 60,
      dietaryPreferences: 'Vegetarian',
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: AppTheme.light,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.home: (_) => const HomeScreen(userId: 1),
        AppRoutes.ai: (_) => AiMealFinderScreen(restaurants: sampleRestaurants),
        AppRoutes.saved: (_) => FavoritesScreen(
          savedMeals: sampleSaved,
          restaurantsById: {for (final r in sampleRestaurants) r.id!: r},
        ),
        AppRoutes.profile: (_) => SettingsScreen(user: sampleUser),
        AppRoutes.budget: (_) =>
            BudgetScreen(weeklyBudget: weeklyBudget, entries: entries),
      },
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.restaurant) {
          final restaurant = settings.arguments as Restaurant;
          final menuItems = sampleMenu
              .where((item) => item.restaurantId == restaurant.id)
              .toList();

          return MaterialPageRoute(
            builder: (_) => RestaurantDetailsScreen(
              restaurant: restaurant,
              menuItems: menuItems,
            ),
          );
        }

        return null;
      },
    );
  }
}
