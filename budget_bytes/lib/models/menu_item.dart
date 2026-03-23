// lib/models/menu_item.dart
class MenuItem {
  final int? id;
  final int restaurantId;
  final String name;
  final double price;
  final String category;      // e.g. "Breakfast", "Lunch", "Drinks"
  final String dietaryInfo;   // e.g. "Vegetarian", "Vegetarian", "None"

  MenuItem({
    this.id,
    required this.restaurantId,
    required this.name,
    required this.price,
    required this.category,
    required this.dietaryInfo,
  });

  Map<String, dynamic> toMap() => {
    'item_id': id,
    'restaurant_id': restaurantId,
    'name': name,
    'price': price,
    'category': category,
    'dietary_info': dietaryInfo,
  };

  factory MenuItem.fromMap(Map<String, dynamic> map) => MenuItem(
    id: map['item_id'],
    restaurantId: map['restaurant_id'],
    name: map['name'],
    price: map['price'],
    category: map['category'],
    dietaryInfo: map['dietary_info'],
  );
}