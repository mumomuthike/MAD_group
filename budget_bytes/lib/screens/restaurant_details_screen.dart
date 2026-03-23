import 'package:flutter/material.dart';
import 'package:budget_bytes/models/menu_item.dart';
import 'package:budget_bytes/models/restaurant.dart';
import 'package:budget_bytes/utils/constants.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final Restaurant restaurant;
  final List<MenuItem> menuItems;
  final bool isFavorite;

  const RestaurantDetailsScreen({
    super.key,
    required this.restaurant,
    required this.menuItems,
    this.isFavorite = false,
  });

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = widget.restaurant;

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
        actions: [
          IconButton(
            onPressed: () {
              setState(() => _isFavorite = !_isFavorite);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isFavorite
                        ? '${restaurant.name} added to favorites.'
                        : '${restaurant.name} removed from favorites.',
                  ),
                ),
              );
            },
            icon: Icon(
              _isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: _isFavorite ? AppColors.errorLight : AppColors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Image.asset(
              'assets/logo_red.png', // replace if needed
              width: 28,
              height: 28,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.storefront_rounded, color: AppColors.white),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppCuisine.accent(restaurant.cuisineType).withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.cardLarge),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppCuisine.emoji(restaurant.cuisineType),
                  style: const TextStyle(fontSize: 42),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  restaurant.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(restaurant.cuisineType, style: AppTypography.accentLarge),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    _DetailChip(
                      icon: Icons.payments_rounded,
                      label: restaurant.priceLabel,
                    ),
                    _DetailChip(
                      icon: Icons.location_on_outlined,
                      label:
                          '${restaurant.distanceFromCampus.toStringAsFixed(1)} mi',
                    ),
                    _DetailChip(
                      icon: Icons.access_time_rounded,
                      label: restaurant.openHours,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  restaurant.address,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          Text('Menu', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),

          if (widget.menuItems.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.cardInnerPadding),
                child: Text('No menu items available yet.'),
              ),
            )
          else
            ...widget.menuItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.cardInnerPadding),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: const Icon(Icons.restaurant_menu_rounded),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(item.category, style: AppTypography.caption),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                item.dietaryInfo,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: AppTypography.priceTag.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DetailChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16, color: AppColors.primary),
      label: Text(label),
    );
  }
}
