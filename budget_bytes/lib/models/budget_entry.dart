// lib/models/budget_entry.dart
class BudgetEntry {
  final int? id;
  final int userId;
  final String mealName;
  final double cost;
  final int? restaurantId;
  final String date;          // stored as: "2026-03-19"

  BudgetEntry({
    this.id,
    required this.userId,
    required this.mealName,
    required this.cost,
    this.restaurantId,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
    'entry_id': id,
    'user_id': userId,
    'meal_name': mealName,
    'cost': cost,
    'restaurant_id': restaurantId,
    'date': date,
  };

  factory BudgetEntry.fromMap(Map<String, dynamic> map) => BudgetEntry(
    id: map['entry_id'],
    userId: map['user_id'],
    mealName: map['meal_name'],
    cost: map['cost'],
    restaurantId: map['restaurant_id'],
    date: map['date'],
  );
}