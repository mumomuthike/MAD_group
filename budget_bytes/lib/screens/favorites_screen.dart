import 'package:flutter/material.dart';
import 'package:budget_bytes/models/restaurant.dart';
import 'package:budget_bytes/models/saved_meal.dart';
import 'package:budget_bytes/utils/constants.dart';

class FavoritesScreen extends StatelessWidget {
  final List<SavedMeal> savedMeals;
  final Map<int, Restaurant> restaurantsById;

  const FavoritesScreen({
    super.key,
    required this.savedMeals,
    required this.restaurantsById,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.savedTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: Image.asset(
              'assets/logo_blue.png', // replace if needed
              width: 28,
              height: 28,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.favorite_rounded, color: AppColors.white),
            ),
          ),
        ],
      ),
      body: savedMeals.isEmpty
          ? _EmptyFavoritesState()
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              itemCount: savedMeals.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final saved = savedMeals[index];
                final restaurant = restaurantsById[saved.restaurantId];

                return Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    onTap: restaurant == null
                        ? null
                        : () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.restaurant,
                              arguments: restaurant,
                            );
                          },
                    child: Padding(
                      padding: const EdgeInsets.all(
                        AppSpacing.cardInnerPadding,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: restaurant == null
                                  ? AppColors.surfaceVariant
                                  : AppCuisine.accent(
                                      restaurant.cuisineType,
                                    ).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                            ),
                            child: Center(
                              child: Text(
                                restaurant == null
                                    ? '🍽️'
                                    : AppCuisine.emoji(restaurant.cuisineType),
                                style: const TextStyle(fontSize: 28),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  saved.mealName,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  restaurant?.name ?? 'Unknown restaurant',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Wrap(
                                  spacing: AppSpacing.sm,
                                  runSpacing: AppSpacing.xs,
                                  children: [
                                    _InfoChip(
                                      label:
                                          '\$${saved.price.toStringAsFixed(2)}',
                                      icon: Icons.attach_money_rounded,
                                    ),
                                    _InfoChip(
                                      label:
                                          '${saved.personalRating.toStringAsFixed(1)} ★',
                                      icon: Icons.star_rounded,
                                    ),
                                    if (restaurant != null)
                                      _InfoChip(
                                        label: restaurant.priceLabel,
                                        icon: Icons.payments_rounded,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  'Saved on ${saved.saveDate}',
                                  style: AppTypography.caption,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Connect this to delete-from-favorites logic.',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.favorite_rounded,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _EmptyFavoritesState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite_border_rounded,
              size: 72,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              AppStrings.noSaved,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _InfoChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16, color: AppColors.primary),
      label: Text(label),
      backgroundColor: AppColors.surfaceVariant,
    );
  }
}
