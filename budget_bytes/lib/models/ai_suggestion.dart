// lib/models/ai_suggestion.dart
class AiSuggestion {
  final int? id;
  final int userId;
  final int restaurantId;
  final int? itemId;          // nullable — suggestion may be restaurant-level
  final String mood;
  final double budget;
  final int timeAvailable;    // minutes available between classes
  final int rank;             // 1 = top pick

  AiSuggestion({
    this.id,
    required this.userId,
    required this.restaurantId,
    this.itemId,
    required this.mood,
    required this.budget,
    required this.timeAvailable,
    required this.rank,
  });

  Map<String, dynamic> toMap() => {
    'suggestion_id': id,
    'user_id': userId,
    'restaurant_id': restaurantId,
    'item_id': itemId,
    'mood': mood,
    'budget': budget,
    'time_available': timeAvailable,
    'rank': rank,
  };

  factory AiSuggestion.fromMap(Map<String, dynamic> map) => AiSuggestion(
    id: map['suggestion_id'],
    userId: map['user_id'],
    restaurantId: map['restaurant_id'],
    itemId: map['item_id'],
    mood: map['mood'],
    budget: map['budget'],
    timeAvailable: map['time_available'],
    rank: map['rank'],
  );
}