// lib/models/user.dart
class User {
  final int? id;
  final String name;
  final double weeklyBudget;
  final String dietaryPreferences;

  User({
    this.id,
    required this.name,
    required this.weeklyBudget,
    required this.dietaryPreferences,
  });

  // Convert a User into a Map (key-value pairs) for SQLite insertion
  Map<String, dynamic> toMap() => {
    'user_id': id,
    'name': name,
    'weekly_budget': weeklyBudget,
    'dietary_preferences': dietaryPreferences,
  };

  // Build a User from a SQLite row (Map)
  factory User.fromMap(Map<String, dynamic> map) => User(
    id: map['user_id'],
    name: map['name'],
    weeklyBudget: map['weekly_budget'],
    dietaryPreferences: map['dietary_preferences'],
  );
}