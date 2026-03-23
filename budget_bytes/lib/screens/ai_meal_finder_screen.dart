import 'package:flutter/material.dart';
import 'package:budget_bytes/models/restaurant.dart';
import 'package:budget_bytes/utils/constants.dart';

class AiMealFinderScreen extends StatefulWidget {
  final List<Restaurant> restaurants;

  const AiMealFinderScreen({super.key, required this.restaurants});

  @override
  State<AiMealFinderScreen> createState() => _AiMealFinderScreenState();
}

class _AiMealFinderScreenState extends State<AiMealFinderScreen> {
  final TextEditingController _moodController = TextEditingController();

  double _budget = 15;
  double _timeAvailable = 30;
  Restaurant? _topPick;
  List<Restaurant> _suggestions = [];

  @override
  void dispose() {
    _moodController.dispose();
    super.dispose();
  }

  void _findMeal() {
    final filtered = widget.restaurants.where((restaurant) {
      final matchesBudget =
          restaurant.priceRange <= _budgetToPriceRange(_budget);
      final matchesTime =
          restaurant.distanceFromCampus <= _timeToMaxDistance(_timeAvailable);
      return matchesBudget && matchesTime;
    }).toList();

    filtered.sort((a, b) {
      final distanceCompare = a.distanceFromCampus.compareTo(
        b.distanceFromCampus,
      );
      if (distanceCompare != 0) return distanceCompare;
      return a.priceRange.compareTo(b.priceRange);
    });

    setState(() {
      _suggestions = filtered.take(5).toList();
      _topPick = _suggestions.isNotEmpty ? _suggestions.first : null;
    });

    if (_topPick == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No match found. Try increasing your budget or time.'),
        ),
      );
    }
  }

  int _budgetToPriceRange(double budget) {
    if (budget <= 10) return 1;
    if (budget <= 20) return 2;
    return 3;
  }

  double _timeToMaxDistance(double time) {
    if (time <= 15) return 0.5;
    if (time <= 30) return 1.5;
    if (time <= 45) return 3.0;
    return 5.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.aiTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: Image.asset(
              'assets/logo_yellow.png', // replace if needed
              width: 28,
              height: 28,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          Text(
            AppStrings.aiSubtitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Describe your vibe, then I’ll help you choose something near campus that fits your time and budget.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),

          TextField(
            controller: _moodController,
            decoration: const InputDecoration(
              labelText: 'Mood / craving',
              hintText: AppStrings.aiPromptHint,
              prefixIcon: Icon(Icons.edit_note_rounded),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.cardInnerPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Budget: \$${_budget.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Slider(
                    value: _budget,
                    min: 5,
                    max: 30,
                    divisions: 25,
                    label: _budget.toStringAsFixed(0),
                    onChanged: (value) => setState(() => _budget = value),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Time available: ${_timeAvailable.toStringAsFixed(0)} min',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Slider(
                    value: _timeAvailable,
                    min: 10,
                    max: 60,
                    divisions: 10,
                    label: _timeAvailable.toStringAsFixed(0),
                    onChanged: (value) =>
                        setState(() => _timeAvailable = value),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),
          ElevatedButton.icon(
            onPressed: _findMeal,
            icon: const Icon(Icons.auto_awesome_rounded),
            label: const Text('Find My Meal'),
          ),
          const SizedBox(height: AppSpacing.xl),

          if (_topPick != null) ...[
            Text('Top Pick', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            _TopPickCard(restaurant: _topPick!),
            const SizedBox(height: AppSpacing.lg),
          ],

          if (_suggestions.isNotEmpty) ...[
            Text(
              'More Matches',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            ..._suggestions.map(
              (restaurant) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _SuggestionTile(restaurant: restaurant),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TopPickCard extends StatelessWidget {
  final Restaurant restaurant;

  const _TopPickCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardInnerPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppCuisine.emoji(restaurant.cuisineType),
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              restaurant.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(restaurant.cuisineType, style: AppTypography.accentMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${restaurant.priceLabel} • ${restaurant.distanceFromCampus.toStringAsFixed(1)} mi away',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(restaurant.openHours, style: AppTypography.caption),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.restaurant,
                  arguments: restaurant,
                );
              },
              child: const Text('View Details'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  final Restaurant restaurant;

  const _SuggestionTile({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.restaurant,
          arguments: restaurant,
        );
      },
      leading: CircleAvatar(
        backgroundColor: AppCuisine.accent(
          restaurant.cuisineType,
        ).withOpacity(0.15),
        child: Text(AppCuisine.emoji(restaurant.cuisineType)),
      ),
      title: Text(restaurant.name),
      subtitle: Text(
        '${restaurant.cuisineType} • ${restaurant.distanceFromCampus.toStringAsFixed(1)} mi',
      ),
      trailing: Text(restaurant.priceLabel, style: AppTypography.priceTag),
    );
  }
} // ← Caveat handwritten for tags
