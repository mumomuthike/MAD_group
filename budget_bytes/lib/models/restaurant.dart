// lib/models/restaurant.dart
class Restaurant {
  final int? id;
  final String name;
  final String cuisineType;
  final String address;
  final int priceRange;       // 1 = $, 2 = $$, 3 = $$$
  final String openHours;     // e.g. "8:00 AM - 10:00 PM"
  final double distanceFromCampus; // in miles

  Restaurant({
    this.id,
    required this.name,
    required this.cuisineType,
    required this.address,
    required this.priceRange,
    required this.openHours,
    required this.distanceFromCampus,
  });

  Map<String, dynamic> toMap() => {
    'restaurant_id': id,
    'name': name,
    'cuisine_type': cuisineType,
    'address': address,
    'price_range': priceRange,
    'open_hours': openHours,
    'distance_from_campus': distanceFromCampus,
  };

  factory Restaurant.fromMap(Map<String, dynamic> map) => Restaurant(
    id: map['restaurant_id'],
    name: map['name'],
    cuisineType: map['cuisine_type'],
    address: map['address'],
    priceRange: map['price_range'],
    openHours: map['open_hours'],
    distanceFromCampus: map['distance_from_campus'],
  );

  // Helper: price range as dollar signs
  String get priceLabel => '\$' * priceRange;
}