import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import '../../models/habit.dart';
import '../../core/theme/app_theme.dart';

class Habit {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int streak;
  final double progress;
  final int xpReward;
  final bool isDaily;

  const Habit({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.streak,
    required this.progress,
    required this.xpReward,
    required this.isDaily,
  });
}

class HabitScreen extends StatefulWidget {
  const HabitScreen({super.key});

  @override
  State<HabitScreen> createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  final List<Habit> habits = [
    const Habit(
      title: 'Read 10 mins',
      description: 'Daily reading habit',
      icon: Icons.menu_book_rounded,
      color: AppTheme.primaryColor,
      streak: 5,
      progress: 0.7,
      xpReward: 10,
      isDaily: true,
    ),
    const Habit(
      title: 'Meditate',
      description: 'Daily mindfulness practice',
      icon: Icons.self_improvement_rounded,
      color: AppTheme.secondaryColor,
      streak: 3,
      progress: 0.4,
      xpReward: 15,
      isDaily: true,
    ),
    const Habit(
      title: 'Plant a tree',
      description: 'Weekly environmental action',
      icon: Icons.eco_rounded,
      color: AppTheme.successColor,
      streak: 1,
      progress: 0.2,
      xpReward: 50,
      isDaily: false,
    ),
  ];

  void _showAddHabitDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddHabitDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Habit Hatch'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: _showAddHabitDialog,
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: habits.length,
        itemBuilder: (context, index) {
          final habit = habits[index];
          return _buildHabitCard(habit);
        },
      ),
    );
  }

  Widget _buildHabitCard(Habit habit) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: habit.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(habit.icon, color: habit.color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        habit.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: habit.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, size: 16),
                      const SizedBox(width: 4),
                      Text('${habit.xpReward} XP'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${habit.streak} day streak',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: habit.progress,
                        backgroundColor: habit.color.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(habit.color),
                        minHeight: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: habit.color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Complete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddHabitDialog extends StatefulWidget {
  const AddHabitDialog({super.key});

  @override
  State<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isDaily = true;
  int _xpReward = 10;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Create New Habit',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Habit Title',
                    prefixIcon: Icon(Icons.title_rounded),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description_rounded),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Daily Habit'),
                    const Spacer(),
                    Switch(
                      value: _isDaily,
                      onChanged: (value) => setState(() => _isDaily = value),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('XP Reward'),
                    const Spacer(),
                    DropdownButton<int>(
                      value: _xpReward,
                      items: const [
                        DropdownMenuItem(value: 10, child: Text('10 XP')),
                        DropdownMenuItem(value: 15, child: Text('15 XP')),
                        DropdownMenuItem(value: 20, child: Text('20 XP')),
                        DropdownMenuItem(value: 50, child: Text('50 XP')),
                      ],
                      onChanged: (value) => setState(() => _xpReward = value!),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.pop(context);
              }
            },
            child: const Text('Create Habit'),
          ),
        ],
      ),
    );
  }
} 