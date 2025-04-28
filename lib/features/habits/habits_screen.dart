import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/habit.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../../core/theme.dart';
import '../../providers/user_provider.dart';
import 'habit_card.dart';
import 'create_habit_dialog.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    if (user == null) {
      return const Center(child: Text('Please log in to see your habits'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Habits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateHabitDialog(context),
          ),
        ],
      ),
      body: FutureBuilder<List<Habit>>(
        future: _loadHabits(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final habits = snapshot.data ?? [];
          if (habits.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No habits yet'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _showCreateHabitDialog(context),
                    child: const Text('Create a Habit'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: habits.length,
            itemBuilder: (context, index) {
              return HabitCard(
                habit: habits[index],
                onComplete: () => _completeHabit(context, habits[index]),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Habit>> _loadHabits(BuildContext context) async {
    final databaseService = context.read<DatabaseService>();
    return await databaseService.getHabits();
  }

  void _showCreateHabitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateHabitDialog(),
    );
  }

  Future<void> _completeHabit(BuildContext context, Habit habit) async {
    final user = context.read<UserProvider>().user;
    if (user == null) return;

    final now = DateTime.now();
    final updatedHabit = habit.copyWith(
      completedDates: [...habit.completedDates, now],
    );

    final databaseService = context.read<DatabaseService>();
    await databaseService.insertHabit(updatedHabit);

    // Update user XP
    final updatedUser = user.copyWith(
      xp: user.xp + habit.xpValue,
    );
    await databaseService.insertUser(updatedUser);
    context.read<UserProvider>().updateUser(updatedUser);

    // Check for level up
    if (updatedUser.xp >= updatedUser.worldLevel * 1000) {
      final leveledUpUser = updatedUser.copyWith(
        worldLevel: updatedUser.worldLevel + 1,
      );
      await databaseService.insertUser(leveledUpUser);
      context.read<UserProvider>().updateUser(leveledUpUser);
    }
  }
} 