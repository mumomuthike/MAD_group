// lib/widgets/restaurant_card.dart
//
// Reusable card widget displayed on:
//   - Home/Discover screen (full list)
//   - AI Meal Finder screen (suggestion results)
//   - Favorites screen (saved restaurants)
//
// Usage:
//   RestaurantCard(
//     restaurant: restaurant,
//     isFavorited: true,
//     onTap: () => Navigator.push(...),
//     onFavoriteTap: () => db.unsaveRestaurant(...),
//   )

import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  // Whether the heart icon shows as filled or outline.
  final bool isFavorited;

  // Called when the user taps the card body and navigates to restaurant details
  final VoidCallback onTap;

  // Called when the user taps the heart icon and parent handles DB save/unsave
  final VoidCallback onFavoriteTap;

  // Optional rank badge: used by AI Meal Finder to show "# Pick"
  final int? rank;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.isFavorited,
    required this.onTap,
    required this.onFavoriteTap,
    this.rank,
  });

  // Cuisine icon
  // Returns an emoji that represents the cuisine type.
  // Shown in the colored circle on the left side of the card.
  String _cuisineEmoji(String cuisine) {
    switch (cuisine) {
      case 'American':    return '🍔';
      case 'Mexican':     return '🌮';
      case 'Asian':       return '🍜';
      case 'Italian':     return '🍝';
      case 'Fast Food':   return '🍟';
      case 'Healthy':     return '🥗';
      case 'Pizza':       return '🍕';
      case 'Breakfast':   return '🍳';
      case 'Coffee Shop': return '☕';
      default:            return '🍽️';
    }
  }

  // Cuisine color
  // Each cuisine gets a distinct background color for the emoji circle.
  // Keeps the home screen visually varied without needing images.
  Color _cuisineColor(String cuisine) {
    switch (cuisine) {
      case 'American':    return const Color(0xFFFFECB3); // warm yellow
      case 'Mexican':     return const Color(0xFFFFCCBC); // warm orange
      case 'Asian':       return const Color(0xFFE1F5FE); // light blue
      case 'Italian':     return const Color(0xFFFFE0E0); // soft red
      case 'Fast Food':   return const Color(0xFFFFF9C4); // light yellow
      case 'Healthy':     return const Color(0xFFDCEDC8); // light green
      case 'Pizza':       return const Color(0xFFFFCCBC); // orange
      case 'Breakfast':   return const Color(0xFFFFF3E0); // cream
      case 'Coffee Shop': return const Color(0xFFD7CCC8); // warm brown
      default:            return const Color(0xFFEEEEEE); // grey
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pull colors from the active theme so dark mode works automatically
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: onTap, // tap anywhere on the card to open restaurant details
      child: Card(
        // Card styling (elevation, shape, margin) comes from CardThemeData in app_theme.dart
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Left: cuisine emoji circle
              Stack(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _cuisineColor(restaurant.cuisineType),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        _cuisineEmoji(restaurant.cuisineType),
                        style: const TextStyle(fontSize: 26),
                      ),
                    ),
                  ),

                  // Rank badge (#1, #2 etc.) — only shown on AI Finder screen
                  if (rank != null)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '#$rank',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 12),

              // Middle: restaurant info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Restaurant name
                    Text(
                      restaurant.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, // long names don't break layout
                    ),

                    const SizedBox(height: 4),

                    // Cuisine type and price range on one row
                    Row(
                      children: [
                        Text(
                          restaurant.cuisineType,
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Dot separator
                        Text(
                          '·',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        const SizedBox(width: 6),
                        // Price label from Restaurant.priceLabel getter (e.g. "$$")
                        Text(
                          restaurant.priceLabel,
                          style: textTheme.bodySmall?.copyWith(
                            color: AppTheme.primaryGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Distance and open hours on one row
                    Row(
                      children: [
                        // Distance chip
                        _InfoChip(
                          icon: Icons.near_me,
                          label:
                          '${restaurant.distanceFromCampus.toStringAsFixed(1)} mi',
                        ),
                        const SizedBox(width: 8),
                        // Open hours chip
                        Flexible(
                          child: _InfoChip(
                            icon: Icons.access_time,
                            label: restaurant.openHours,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Right: favorite (heart) button
              // IconButton handles the tap target size (min 48x48) automatically
              IconButton(
                onPressed: onFavoriteTap,
                icon: Icon(
                  // filled heart if saved, outline if not
                  isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: isFavorited ? Colors.red : Colors.grey,
                ),
                tooltip: isFavorited ? 'Remove from favorites' : 'Add to favorites',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Info chip
// Small icon + label pill used for distance and open hours.
// Private to this file — only RestaurantCard uses it.
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        // Adapts automatically to light/dark mode via theme surface variant
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // shrink to content, don't stretch
        children: [
          Icon(icon, size: 12, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}