import 'package:flutter/material.dart';
import '../models/restaurant.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback? onTap;
  final bool compact;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    this.onTap,
    this.compact = false,
  });

  static const Color _blue = Color(0xFF057EE6);
  static const Color _red = Color(0xFFBC1823);
  static const Color _gold = Color(0xFFEEBA2B);
  static const Color _dark = Color(0xFF111111);
  static const Color _grey = Color(0xFF888888);

  Color _cuisineAccent(String cuisine) {
    const map = {
      'American': Color(0xFFBC1823),
      'Mexican': Color(0xFFEEBA2B),
      'Asian': Color(0xFF057EE6),
      'Pizza': Color(0xFFE65C00),
      'Healthy': Color(0xFF2E7D32),
      'Fast Food': Color(0xFFEEBA2B),
      'Italian': Color(0xFF8B0000),
      'Breakfast': Color(0xFFE65C00),
    };
    return map[cuisine] ?? _blue;
  }

  String _cuisineEmoji(String cuisine) {
    const map = {
      'American': '🍔',
      'Mexican': '🌮',
      'Asian': '🍜',
      'Pizza': '🍕',
      'Healthy': '🥗',
      'Fast Food': '🍟',
      'Italian': '🍝',
      'Breakfast': '🥞',
    };
    return map[cuisine] ?? '🍽️';
  }

  String _priceSymbol(int range) => '\$' * range;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = _cuisineAccent(restaurant.cuisineType);
    final emoji = _cuisineEmoji(restaurant.cuisineType);

    final cardColor = isDark ? const Color(0xFF181818) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFE7E7E7);
    final textColor = isDark ? Colors.white : _dark;
    final subTextColor = isDark ? Colors.white70 : _grey;
    final chipBg = isDark ? Colors.white10 : accent.withOpacity(0.12);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(compact ? 12 : 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: compact ? 52 : 60,
              height: compact ? 52 : 60,
              decoration: BoxDecoration(
                color: chipBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: TextStyle(fontSize: compact ? 24 : 28),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: compact ? 14 : 15,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                      letterSpacing: -0.2,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant.cuisineType,
                    style: TextStyle(
                      fontSize: 12,
                      color: accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        _priceSymbol(restaurant.priceRange),
                        style: TextStyle(
                          color: isDark ? _gold : _grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.location_on_outlined,
                        size: 12,
                        color: subTextColor,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${restaurant.distanceFromCampus.toStringAsFixed(1)} mi',
                        style: TextStyle(color: subTextColor, fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.access_time_rounded,
                        size: 12,
                        color: subTextColor,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          restaurant.openHours,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: subTextColor, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: subTextColor, size: 22),
          ],
        ),
      ),
    );
  }
}
