// lib/models/saved_meal.dart
class SavedMeal {
  final int? id;
  final int userId;
  final int restaurantId;
  final String mealName;
  final double price;
  final double personalRating; // 1.0 – 5.0
  final String saveDate;       // "2026-03-17"

  SavedMeal({
    this.id,
    required this.userId,
    required this.restaurantId,
    required this.mealName,
    required this.price,
    required this.personalRating,
    required this.saveDate,
  });

  Map<String, dynamic> toMap() => {
    'save_id': id,
    'user_id': userId,
    'restaurant_id': restaurantId,
    'meal_name': mealName,
    'price': price,
    'personal_rating': personalRating,
    'save_date': saveDate,
  };

  factory SavedMeal.fromMap(Map<String, dynamic> map) => SavedMeal(
    id: map['save_id'],
    userId: map['user_id'],
    restaurantId: map['restaurant_id'],
    mealName: map['meal_name'],
    price: map['price'],
    personalRating: map['personal_rating'],
    saveDate: map['save_date'],
  );
}