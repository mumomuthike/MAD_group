import 'package:flutter/material.dart';
import 'package:budget_bytes/models/user.dart';
import 'package:budget_bytes/utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  final User user;
  final ValueChanged<User>? onSave;
  final VoidCallback? onClearData;

  const SettingsScreen({
    super.key,
    required this.user,
    this.onSave,
    this.onClearData,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _budgetController;
  late final TextEditingController _dietController;

  bool _notificationsEnabled = true;
  bool _showOnlyBudgetFriendly = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _budgetController = TextEditingController(
      text: widget.user.weeklyBudget.toStringAsFixed(0),
    );
    _dietController = TextEditingController(
      text: widget.user.dietaryPreferences,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    _dietController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    final updatedUser = User(
      id: widget.user.id,
      name: _nameController.text.trim(),
      weeklyBudget:
          double.tryParse(_budgetController.text.trim()) ??
          widget.user.weeklyBudget,
      dietaryPreferences: _dietController.text.trim(),
    );

    widget.onSave?.call(updatedUser);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Settings saved.')));
  }

  void _confirmClearData() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear My Data'),
        content: const Text(
          'This will remove your saved app data. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onClearData?.call();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('App data cleared.')),
              );
            },
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: Image.asset(
              'assets/logo_blue.png', // replace if needed
              width: 28,
              height: 28,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.settings_rounded, color: AppColors.white),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          Text('Profile', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.cardInnerPadding),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _budgetController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Weekly Budget',
                      prefixIcon: Icon(Icons.attach_money_rounded),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _dietController,
                    decoration: const InputDecoration(
                      labelText: 'Dietary Preferences',
                      hintText: 'Vegetarian, halal, no dairy...',
                      prefixIcon: Icon(Icons.restaurant_menu_rounded),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),
          Text('Preferences', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),

          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: _notificationsEnabled,
                  onChanged: (value) =>
                      setState(() => _notificationsEnabled = value),
                  title: const Text('Notifications'),
                  subtitle: const Text('Meal reminders and budget alerts'),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: _showOnlyBudgetFriendly,
                  onChanged: (value) =>
                      setState(() => _showOnlyBudgetFriendly = value),
                  title: const Text('Budget-friendly first'),
                  subtitle: const Text('Prioritize cheaper restaurants'),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),
          ElevatedButton(
            onPressed: _saveSettings,
            child: const Text(AppStrings.save),
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton(
            onPressed: _confirmClearData,
            child: const Text(AppStrings.clearData),
          ),
        ],
      ),
    );
  }
}
