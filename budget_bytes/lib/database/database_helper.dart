// lib/database/database_helper.dart
//
// Single source for all SQLite operations
// All screens talk to the DB through this class
//
// Usage from any screen:
//   final db = DatabaseHelper.instance;
//   final restaurants = await db.getAllRestaurants();

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/user.dart';
import '../models/restaurant.dart';
import '../models/menu_item.dart';
import '../models/budget_entry.dart';
import '../models/saved_meal.dart';
import '../models/class_schedule.dart';
import '../models/ai_suggestion.dart';

class DatabaseHelper {
  // Only one DatabaseHelper ever exists, every screen shares it
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  // Returns the open database, opening it first if needed
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  // Initialise db
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'budget_bytes.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate, // runs on first install
      onOpen: (db) async {
        // Enforce foreign keys every time the DB opens
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  // db schema
  // Called once when the database file does not yet exist on the device
  Future<void> _onCreate(Database db, int version) async {
    // 1. users table
    await db.execute('''
      CREATE TABLE users (
        user_id             INTEGER PRIMARY KEY AUTOINCREMENT,
        name                TEXT    NOT NULL,
        weekly_budget       REAL    NOT NULL DEFAULT 50.0,
        dietary_preferences TEXT    NOT NULL DEFAULT 'No preference'
      )
    ''');

    // 2. restaurants table
    await db.execute('''
      CREATE TABLE restaurants (
        restaurant_id         INTEGER PRIMARY KEY AUTOINCREMENT,
        name                  TEXT    NOT NULL,
        cuisine_type          TEXT    NOT NULL,
        address               TEXT    NOT NULL,
        price_range           INTEGER NOT NULL CHECK(price_range BETWEEN 1 AND 3),
        open_hours            TEXT    NOT NULL,
        distance_from_campus  REAL    NOT NULL
      )
    ''');

    // 3. menu_items table
    await db.execute('''
      CREATE TABLE menu_items (
        item_id       INTEGER PRIMARY KEY AUTOINCREMENT,
        restaurant_id INTEGER NOT NULL REFERENCES restaurants(restaurant_id)
                              ON DELETE CASCADE,
        name          TEXT    NOT NULL,
        price         REAL    NOT NULL,
        category      TEXT    NOT NULL,
        dietary_info  TEXT    NOT NULL DEFAULT 'None'
      )
    ''');

    // 4. budget_tracker table
    await db.execute('''
      CREATE TABLE budget_tracker (
        entry_id      INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id       INTEGER NOT NULL REFERENCES users(user_id)
                              ON DELETE CASCADE,
        meal_name     TEXT    NOT NULL,
        cost          REAL    NOT NULL,
        restaurant_id INTEGER REFERENCES restaurants(restaurant_id)
                              ON DELETE SET NULL,
        date          TEXT    NOT NULL
      )
    ''');

    // 5. saved_meals table
    await db.execute('''
      CREATE TABLE saved_meals (
        save_id         INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id         INTEGER NOT NULL REFERENCES users(user_id)
                                ON DELETE CASCADE,
        restaurant_id   INTEGER NOT NULL REFERENCES restaurants(restaurant_id)
                                ON DELETE CASCADE,
        meal_name       TEXT    NOT NULL,
        price           REAL    NOT NULL,
        personal_rating REAL    NOT NULL DEFAULT 0.0
                                CHECK(personal_rating BETWEEN 0 AND 5),
        save_date       TEXT    NOT NULL
      )
    ''');

    // 6. class_schedule table  (used by AI matcher)
    await db.execute('''
      CREATE TABLE class_schedule (
        class_id    INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id     INTEGER NOT NULL REFERENCES users(user_id)
                            ON DELETE CASCADE,
        class_name  TEXT    NOT NULL,
        location    TEXT    NOT NULL,
        days_of_week TEXT   NOT NULL,
        start_time  TEXT    NOT NULL,
        end_time    TEXT    NOT NULL
      )
    ''');

    // 7. ai_meal_suggestions table
    await db.execute('''
      CREATE TABLE ai_meal_suggestions (
        suggestion_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id       INTEGER NOT NULL REFERENCES users(user_id)
                              ON DELETE CASCADE,
        restaurant_id INTEGER NOT NULL REFERENCES restaurants(restaurant_id)
                              ON DELETE CASCADE,
        item_id       INTEGER REFERENCES menu_items(item_id)
                              ON DELETE SET NULL,
        mood          TEXT    NOT NULL,
        budget        REAL    NOT NULL,
        time_available INTEGER NOT NULL,
        rank          INTEGER NOT NULL
      )
    ''');

    // Seed data so the app has content on first launch
    await _seedData(db);
  }

  // Seed data with restaurants and menu items
  Future<void> _seedData(Database db) async {
    // restaurants
    final restaurants = [
      // id 1 — American $$
      {
        'name': 'The Campus Grill',
        'cuisine_type': 'American',
        'address': '101 University Ave',
        'price_range': 2,
        'open_hours': '7:00 AM – 9:00 PM',
        'distance_from_campus': 0.1,
      },
      // id 2 — Mexican $
      {
        'name': 'Taco Loco',
        'cuisine_type': 'Mexican',
        'address': '204 College Blvd',
        'price_range': 1,
        'open_hours': '10:00 AM – 10:00 PM',
        'distance_from_campus': 0.3,
      },
      // id 3 — Asian $
      {
        'name': 'Panda Bowl',
        'cuisine_type': 'Asian',
        'address': '88 East Street',
        'price_range': 1,
        'open_hours': '11:00 AM – 8:00 PM',
        'distance_from_campus': 0.5,
      },
      // id 4 — Pizza $$
      {
        'name': 'Slice & Dice',
        'cuisine_type': 'Pizza',
        'address': '310 Main Street',
        'price_range': 2,
        'open_hours': '11:00 AM – 11:00 PM',
        'distance_from_campus': 0.4,
      },
      // id 5 — Healthy $$
      {
        'name': 'Green Garden Cafe',
        'cuisine_type': 'Healthy',
        'address': '55 Wellness Way',
        'price_range': 2,
        'open_hours': '8:00 AM – 6:00 PM',
        'distance_from_campus': 0.2,
      },
      // id 6 — Fast Food $
      {
        'name': 'Burger Barn',
        'cuisine_type': 'Fast Food',
        'address': '9 Drive-Through Lane',
        'price_range': 1,
        'open_hours': '9:00 AM – 12:00 AM',
        'distance_from_campus': 0.6,
      },
      // id 7 — Italian $$$
      {
        'name': 'Pasta Palace',
        'cuisine_type': 'Italian',
        'address': '77 Roma Road',
        'price_range': 3,
        'open_hours': '12:00 PM – 9:00 PM',
        'distance_from_campus': 0.8,
      },
      // id 8 — Breakfast $
      {
        'name': 'Morning Rush Diner',
        'cuisine_type': 'Breakfast',
        'address': '15 Sunrise Blvd',
        'price_range': 1,
        'open_hours': '6:00 AM – 2:00 PM',
        'distance_from_campus': 0.3,
      },
      // id 9 — American $$$
      {
        'name': 'The Ivory Fork',
        'cuisine_type': 'American',
        'address': '200 Faculty Drive',
        'price_range': 3,
        'open_hours': '11:00 AM – 10:00 PM',
        'distance_from_campus': 0.9,
      },
    ];

    for (final r in restaurants) {
      await db.insert('restaurants', r);
    }

    // Menu items — restaurant IDs 1–9 (foreign keys)
    final menuItems = [
      // The Campus Grill (1)
      {
        'restaurant_id': 1,
        'name': 'Classic Burger',
        'price': 8.99,
        'category': 'Lunch',
        'dietary_info': 'None',
      },
      {
        'restaurant_id': 1,
        'name': 'Grilled Chicken Wrap',
        'price': 7.49,
        'category': 'Lunch',
        'dietary_info': 'None',
      },
      {
        'restaurant_id': 1,
        'name': 'Breakfast Burrito',
        'price': 5.99,
        'category': 'Breakfast',
        'dietary_info': 'None',
      },
      // Taco Loco (2)
      {
        'restaurant_id': 2,
        'name': 'Street Tacos (3)',
        'price': 6.50,
        'category': 'Lunch',
        'dietary_info': 'None',
      },
      {
        'restaurant_id': 2,
        'name': 'Veggie Burrito',
        'price': 5.75,
        'category': 'Lunch',
        'dietary_info': 'Vegetarian',
      },
      {
        'restaurant_id': 2,
        'name': 'Chips & Guac',
        'price': 3.00,
        'category': 'Snack',
        'dietary_info': 'Vegan',
      },
      // Panda Bowl (3)
      {
        'restaurant_id': 3,
        'name': 'Orange Chicken Bowl',
        'price': 7.25,
        'category': 'Lunch',
        'dietary_info': 'None',
      },
      {
        'restaurant_id': 3,
        'name': 'Fried Rice',
        'price': 4.50,
        'category': 'Lunch',
        'dietary_info': 'Vegetarian',
      },
      {
        'restaurant_id': 3,
        'name': 'Spring Rolls',
        'price': 3.50,
        'category': 'Snack',
        'dietary_info': 'Vegetarian',
      },
      // Slice & Dice (4)
      {
        'restaurant_id': 4,
        'name': 'Cheese Slice',
        'price': 2.99,
        'category': 'Lunch',
        'dietary_info': 'Vegetarian',
      },
      {
        'restaurant_id': 4,
        'name': 'Pepperoni Slice',
        'price': 3.49,
        'category': 'Lunch',
        'dietary_info': 'None',
      },
      {
        'restaurant_id': 4,
        'name': 'Whole Margherita Pizza',
        'price': 12.99,
        'category': 'Dinner',
        'dietary_info': 'Vegetarian',
      },
      // Green Garden Cafe
      {
        'restaurant_id': 5,
        'name': 'Acai Bowl',
        'price': 8.50,
        'category': 'Breakfast',
        'dietary_info': 'Vegan',
      },
      {
        'restaurant_id': 5,
        'name': 'Kale Caesar Salad',
        'price': 9.00,
        'category': 'Lunch',
        'dietary_info': 'Vegetarian',
      },
      {
        'restaurant_id': 5,
        'name': 'Green Smoothie',
        'price': 5.50,
        'category': 'Drinks',
        'dietary_info': 'Vegan',
      },
      // Burger Barn (6)
      {
        'restaurant_id': 6,
        'name': 'Value Burger',
        'price': 4.99,
        'category': 'Lunch',
        'dietary_info': 'None',
      },
      {
        'restaurant_id': 6,
        'name': 'Combo Meal',
        'price': 7.99,
        'category': 'Lunch',
        'dietary_info': 'None',
      },
      {
        'restaurant_id': 6,
        'name': 'Chicken Nuggets (6)',
        'price': 4.49,
        'category': 'Snack',
        'dietary_info': 'None',
      },
      // Pasta Palace (7)
      {
        'restaurant_id': 7,
        'name': 'Spaghetti Bolognese',
        'price': 15.99,
        'category': 'Dinner',
        'dietary_info': 'None',
      },
      {
        'restaurant_id': 7,
        'name': 'Fettuccine Alfredo',
        'price': 14.99,
        'category': 'Dinner',
        'dietary_info': 'Vegetarian',
      },
      {
        'restaurant_id': 7,
        'name': 'Garlic Bread',
        'price': 5.00,
        'category': 'Snack',
        'dietary_info': 'Vegetarian',
      },
      // Morning Rush Diner (8)
      {
        'restaurant_id': 8,
        'name': 'Pancake Stack',
        'price': 5.49,
        'category': 'Breakfast',
        'dietary_info': 'Vegetarian',
      },
      {
        'restaurant_id': 8,
        'name': 'Eggs & Toast',
        'price': 4.99,
        'category': 'Breakfast',
        'dietary_info': 'Vegetarian',
      },
      {
        'restaurant_id': 8,
        'name': 'Bacon Egg & Cheese',
        'price': 5.99,
        'category': 'Breakfast',
        'dietary_info': 'None',
      },
      {
        'restaurant_id': 8,
        'name': 'Fresh OJ',
        'price': 2.99,
        'category': 'Drinks',
        'dietary_info': 'Vegan',
      },
      // The Ivory Fork (9)
      {
        'restaurant_id': 9,
        'name': 'Wagyu Smash Burger',
        'price': 18.99,
        'category': 'Lunch',
        'dietary_info': 'None',
      },
      {
        'restaurant_id': 9,
        'name': 'Truffle Mac & Cheese',
        'price': 16.99,
        'category': 'Dinner',
        'dietary_info': 'Vegetarian',
      },
      {
        'restaurant_id': 9,
        'name': 'Lobster Bisque',
        'price': 12.99,
        'category': 'Lunch',
        'dietary_info': 'None',
      },
    ];

    for (final item in menuItems) {
      await db.insert('menu_items', item);
    }
  }

  //---------------------
  // User CRUD operations
  //---------------------

  Future<int> insertUser(User user) async {
    final db = await database;
    return db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User?> getUser(int userId) async {
    final db = await database;
    final rows = await db.query(
      'users',
      where: 'user_id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return User.fromMap(rows.first);
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return db.update(
      'users',
      user.toMap(),
      where: 'user_id = ?',
      whereArgs: [user.id],
    );
  }

  //---------------------------
  // Restaurant CRUD operations
  //---------------------------
  Future<List<Restaurant>> getAllRestaurants() async {
    final db = await database;
    final rows = await db.query(
      'restaurants',
      orderBy: 'distance_from_campus ASC',
    );
    return rows.map(Restaurant.fromMap).toList();
  }

  // Filter restaurants by cuisine, max price, and max distance
  Future<List<Restaurant>> filterRestaurants({
    String? cuisine, // null = all cuisines
    int? maxPrice, // 1, 2, or 3 — null = any
    double? maxDistance, // miles — null = any
    String? searchQuery, // partial name match — null = no filter
  }) async {
    final db = await database;

    final conditions = <String>[];
    final args = <dynamic>[];

    if (cuisine != null && cuisine != 'All') {
      conditions.add('cuisine_type = ?');
      args.add(cuisine);
    }
    if (maxPrice != null) {
      conditions.add('price_range <= ?');
      args.add(maxPrice);
    }
    if (maxDistance != null) {
      conditions.add('distance_from_campus <= ?');
      args.add(maxDistance);
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      conditions.add('name LIKE ?');
      args.add('%$searchQuery%');
    }

    final where = conditions.isEmpty ? null : conditions.join(' AND ');

    final rows = await db.query(
      'restaurants',
      where: where,
      whereArgs: args.isEmpty ? null : args,
      orderBy: 'distance_from_campus ASC',
    );
    return rows.map(Restaurant.fromMap).toList();
  }

  Future<Restaurant?> getRestaurant(int restaurantId) async {
    final db = await database;
    final rows = await db.query(
      'restaurants',
      where: 'restaurant_id = ?',
      whereArgs: [restaurantId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Restaurant.fromMap(rows.first);
  }

  //---------------------------
  // Menu items CRUD operations
  //---------------------------
  Future<List<MenuItem>> getMenuItems(int restaurantId) async {
    final db = await database;
    final rows = await db.query(
      'menu_items',
      where: 'restaurant_id = ?',
      whereArgs: [restaurantId],
      orderBy: 'category ASC, price ASC',
    );
    return rows.map(MenuItem.fromMap).toList();
  }

  //-------------------------------
  // Budget tracker CRUD operations
  //-------------------------------
  Future<int> insertBudgetEntry(BudgetEntry entry) async {
    final db = await database;
    return db.insert(
      'budget_tracker',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // All entries for a user in the current week (Mon–Sun)
  Future<List<BudgetEntry>> getWeeklyEntries(int userId) async {
    final db = await database;
    final now = DateTime.now();
    // Find Monday of current week
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));

    final startDate = monday.toIso8601String().substring(0, 10);
    final endDate = sunday.toIso8601String().substring(0, 10);

    final rows = await db.query(
      'budget_tracker',
      where: 'user_id = ? AND date BETWEEN ? AND ?',
      whereArgs: [userId, startDate, endDate],
      orderBy: 'date DESC',
    );
    return rows.map(BudgetEntry.fromMap).toList();
  }

  // Sum of spending this week for a user
  Future<double> getWeeklySpending(int userId) async {
    final entries = await getWeeklyEntries(userId) ?? [];
    return entries.fold<double>(
      0.0,
      (sum, e) => sum + (e.cost?.toDouble() ?? 0.0),
    );
  }

  Future<int> deleteBudgetEntry(int entryId) async {
    final db = await database;
    return db.delete(
      'budget_tracker',
      where: 'entry_id = ?',
      whereArgs: [entryId],
    );
  }

  //----------------------------
  // Saved meals crud operations
  //----------------------------
  Future<int> insertSavedMeal(SavedMeal meal) async {
    final db = await database;
    return db.insert(
      'saved_meals',
      meal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SavedMeal>> getSavedMeals(int userId) async {
    final db = await database;
    final rows = await db.query(
      'saved_meals',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'save_date DESC',
    );
    return rows.map(SavedMeal.fromMap).toList();
  }

  // Check if a restaurant is already saved (for favorite toggle)
  Future<bool> isRestaurantSaved(int userId, int restaurantId) async {
    final db = await database;
    final rows = await db.query(
      'saved_meals',
      where: 'user_id = ? AND restaurant_id = ?',
      whereArgs: [userId, restaurantId],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  Future<int> deleteSavedMeal(int saveId) async {
    final db = await database;
    return db.delete('saved_meals', where: 'save_id = ?', whereArgs: [saveId]);
  }

  // Remove all saved meals for a restaurant (un-favorite)
  Future<int> unsaveRestaurant(int userId, int restaurantId) async {
    final db = await database;
    return db.delete(
      'saved_meals',
      where: 'user_id = ? AND restaurant_id = ?',
      whereArgs: [userId, restaurantId],
    );
  }

  //----------------------------
  // Class schedule CRUD operations
  //----------------------------
  Future<int> insertClassSchedule(ClassSchedule schedule) async {
    final db = await database;
    return db.insert(
      'class_schedule',
      schedule.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ClassSchedule>> getClassSchedule(int userId) async {
    final db = await database;
    final rows = await db.query(
      'class_schedule',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'start_time ASC',
    );
    return rows.map(ClassSchedule.fromMap).toList();
  }

  Future<int> deleteClassSchedule(int classId) async {
    final db = await database;
    return db.delete(
      'class_schedule',
      where: 'class_id = ?',
      whereArgs: [classId],
    );
  }

  //------------------------------------
  // AI meal suggestions CRUD operations
  //------------------------------------
  Future<void> saveAiSuggestions(List<AiSuggestion> suggestions) async {
    final db = await database;
    final batch = db.batch();
    for (final s in suggestions) {
      batch.insert(
        'ai_meal_suggestions',
        s.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<AiSuggestion>> getLatestSuggestions(int userId) async {
    final db = await database;
    final rows = await db.query(
      'ai_meal_suggestions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'rank ASC',
      limit: 5,
    );
    return rows.map(AiSuggestion.fromMap).toList();
  }

  //------------------------
  // Utility crud operations
  //------------------------
  // Wipe all user-generated data (budget entries, saved meals, suggestions)
  // Keeps restaurants and menu items — only clears personal data
  Future<void> clearUserData(int userId) async {
    final db = await database;
    final batch = db.batch();
    batch.delete('budget_tracker', where: 'user_id = ?', whereArgs: [userId]);
    batch.delete('saved_meals', where: 'user_id = ?', whereArgs: [userId]);
    batch.delete('class_schedule', where: 'user_id = ?', whereArgs: [userId]);
    batch.delete(
      'ai_meal_suggestions',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    await batch.commit(noResult: true);
  }

  // Close the database connection (good practice on app exit)
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
