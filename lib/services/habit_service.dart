import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int streak;
  final double progress;
  final DateTime lastCompleted;
  final bool isDaily;
  final int targetCount;
  final int currentCount;

  Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.streak,
    required this.progress,
    required this.lastCompleted,
    required this.isDaily,
    required this.targetCount,
    required this.currentCount,
  });

  Habit copyWith({
    String? id,
    String? title,
    String? description,
    IconData? icon,
    Color? color,
    int? streak,
    double? progress,
    DateTime? lastCompleted,
    bool? isDaily,
    int? targetCount,
    int? currentCount,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      streak: streak ?? this.streak,
      progress: progress ?? this.progress,
      lastCompleted: lastCompleted ?? this.lastCompleted,
      isDaily: isDaily ?? this.isDaily,
      targetCount: targetCount ?? this.targetCount,
      currentCount: currentCount ?? this.currentCount,
    );
  }
}

class HabitService extends ChangeNotifier {
  List<Habit> _habits = [];

  List<Habit> get habits => _habits;

  HabitService() {
    // Initialize with some sample habits
    _habits = [
      Habit(
        id: '1',
        title: 'Read 10 mins',
        description: 'Daily reading habit',
        icon: Icons.menu_book_rounded,
        color: Colors.blue,
        streak: 5,
        progress: 0.7,
        lastCompleted: DateTime.now().subtract(const Duration(days: 1)),
        isDaily: true,
        targetCount: 1,
        currentCount: 1,
      ),
      Habit(
        id: '2',
        title: 'Meditate',
        description: 'Daily meditation',
        icon: Icons.self_improvement_rounded,
        color: Colors.purple,
        streak: 3,
        progress: 0.4,
        lastCompleted: DateTime.now().subtract(const Duration(days: 1)),
        isDaily: true,
        targetCount: 1,
        currentCount: 1,
      ),
      Habit(
        id: '3',
        title: 'Plant a tree',
        description: 'Weekly environmental goal',
        icon: Icons.eco_rounded,
        color: Colors.green,
        streak: 0,
        progress: 0.2,
        lastCompleted: DateTime.now().subtract(const Duration(days: 3)),
        isDaily: false,
        targetCount: 3,
        currentCount: 1,
      ),
    ];
  }

  void addHabit(Habit habit) {
    _habits.add(habit);
    notifyListeners();
  }

  void updateHabit(Habit habit) {
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = habit;
      notifyListeners();
    }
  }

  void deleteHabit(String id) {
    _habits.removeWhere((habit) => habit.id == id);
    notifyListeners();
  }

  void completeHabit(String id) {
    final index = _habits.indexWhere((h) => h.id == id);
    if (index != -1) {
      final habit = _habits[index];
      final now = DateTime.now();
      final isNewStreak = now.difference(habit.lastCompleted).inDays <= 1;

      _habits[index] = habit.copyWith(
        streak: isNewStreak ? habit.streak + 1 : 1,
        lastCompleted: now,
        currentCount: habit.currentCount + 1,
        progress: (habit.currentCount + 1) / habit.targetCount,
      );
      notifyListeners();
    }
  }

  void resetHabit(String id) {
    final index = _habits.indexWhere((h) => h.id == id);
    if (index != -1) {
      final habit = _habits[index];
      _habits[index] = habit.copyWith(
        streak: 0,
        currentCount: 0,
        progress: 0.0,
      );
      notifyListeners();
    }
  }
} 