import 'package:flutter/material.dart';
import 'package:budget_bytes/models/budget_entry.dart';
import 'package:budget_bytes/utils/constants.dart';
import 'package:budget_bytes/utils/app_theme.dart';

class BudgetScreen extends StatefulWidget {
  final double weeklyBudget;
  final List<BudgetEntry> entries;
  final ValueChanged<BudgetEntry>? onAddEntry;
  final ValueChanged<BudgetEntry>? onDeleteEntry;

  const BudgetScreen({
    super.key,
    required this.weeklyBudget,
    required this.entries,
    this.onAddEntry,
    this.onDeleteEntry,
  });

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  late List<BudgetEntry> _entries;

  @override
  void initState() {
    super.initState();
    _entries = List<BudgetEntry>.from(widget.entries);
  }

  double get _spent => _entries.fold(0.0, (sum, entry) => sum + entry.cost);

  double get _left => widget.weeklyBudget - _spent;

  double get _progress {
    if (widget.weeklyBudget <= 0) return 0;
    final value = _spent / widget.weeklyBudget;
    return value.clamp(0.0, 1.0);
  }

  Color get _progressColor =>
      AppColors.budgetProgress(_spent, widget.weeklyBudget);

  Future<void> _showAddMealDialog() async {
    final mealController = TextEditingController();
    final costController = TextEditingController();
    final dateController = TextEditingController(
      text: DateTime.now().toIso8601String().split('T').first,
    );

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppStrings.addMeal),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: mealController,
                  decoration: const InputDecoration(
                    labelText: 'Meal name',
                    hintText: 'Chicken bowl, tacos...',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: costController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Cost',
                    hintText: '12.50',
                    prefixText: '\$',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    hintText: '2026-03-23',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(AppStrings.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                final mealName = mealController.text.trim();
                final cost = double.tryParse(costController.text.trim());
                final date = dateController.text.trim();

                if (mealName.isEmpty || cost == null || date.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields correctly.'),
                    ),
                  );
                  return;
                }

                final entry = BudgetEntry(
                  userId: 1,
                  mealName: mealName,
                  cost: cost,
                  date: date,
                );

                setState(() {
                  _entries.insert(0, entry);
                });

                widget.onAddEntry?.call(entry);
                Navigator.pop(context);
              },
              child: const Text(AppStrings.save),
            ),
          ],
        );
      },
    );
  }

  void _deleteEntry(BudgetEntry entry) {
    setState(() {
      _entries.remove(entry);
    });
    widget.onDeleteEntry?.call(entry);
  }

  @override
  Widget build(BuildContext context) {
    final bool isOverBudget = _left < 0;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.budgetTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMealDialog,
        child: const Icon(Icons.add_rounded),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          Container(
            constraints: const BoxConstraints(minHeight: 180),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.primaryFaint,
              borderRadius: BorderRadius.circular(AppRadius.cardLarge),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.thisWeek, style: AppTypography.overline),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  AppStrings.weeklyBudget,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${_spent.toStringAsFixed(2)} ',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        AppStrings.spent,
                        style: AppTypography.caption,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.chip),
                  child: LinearProgressIndicator(
                    value: _progress,
                    minHeight: AppSizing.progressBarHeight,
                    backgroundColor: AppColors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(_progressColor),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          Row(
            children: [
              Expanded(
                child: _BudgetStatCard(
                  label: 'Budget',
                  value: '\$${widget.weeklyBudget.toStringAsFixed(2)}',
                  color: AppColors.primary,
                  icon: Icons.account_balance_wallet_rounded,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _BudgetStatCard(
                  label: AppStrings.left,
                  value:
                      '${isOverBudget ? '-\$' : '\$'}${_left.abs().toStringAsFixed(2)}',
                  color: isOverBudget
                      ? AppColors.budgetOver
                      : AppColors.budgetSafe,
                  icon: isOverBudget
                      ? Icons.warning_amber_rounded
                      : Icons.savings_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sectionGap),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Meals',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              TextButton.icon(
                onPressed: _showAddMealDialog,
                icon: const Icon(Icons.add_rounded),
                label: const Text(AppStrings.addMeal),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          if (_entries.isEmpty)
            const _EmptyBudgetState()
          else
            ..._entries.map(
              (entry) => Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: const Icon(Icons.receipt_long_rounded),
                  ),
                  title: Text(entry.mealName, style: AppTypography.listTitle),
                  subtitle: Text(entry.date, style: AppTypography.caption),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$${entry.cost.toStringAsFixed(2)}',
                        style: AppTypography.priceTag.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      IconButton(
                        onPressed: () => _deleteEntry(entry),
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BudgetStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _BudgetStatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardInnerPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: AppSpacing.sm),
            Text(label, style: AppTypography.caption),
            const SizedBox(height: AppSpacing.xs),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}

class _EmptyBudgetState extends StatelessWidget {
  const _EmptyBudgetState();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            const Icon(
              Icons.account_balance_wallet_outlined,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No meals added yet.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Tap “Add Meal” to start tracking what you spend.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
        ),
      ),
    );
  }
}
