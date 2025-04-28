import 'package:flutter/material.dart';
//import 'package:flutter/foundation.dart';
//import 'package:intl/intl.dart';

class Habit {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final int streak;
  final int xpReward;
  final bool isCompleted;
  final bool isDaily;
  final int targetCount;
  final DateTime lastCompleted;

  const Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.streak,
    required this.xpReward,
    required this.isCompleted,
    required this.isDaily,
    required this.targetCount,
    required this.lastCompleted,
  });

  Habit copyWith({
    String? id,
    String? name,
    String? description,
    IconData? icon,
    Color? color,
    int? streak,
    int? xpReward,
    bool? isCompleted,
    bool? isDaily,
    int? targetCount,
    DateTime? lastCompleted,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      streak: streak ?? this.streak,
      xpReward: xpReward ?? this.xpReward,
      isCompleted: isCompleted ?? this.isCompleted,
      isDaily: isDaily ?? this.isDaily,
      targetCount: targetCount ?? this.targetCount,
      lastCompleted: lastCompleted ?? this.lastCompleted,
    );
  }

  bool canCompleteToday() {
    final now = DateTime.now();
    final lastCompletedDate = DateTime(
      lastCompleted.year,
      lastCompleted.month,
      lastCompleted.day,
    );
    final today = DateTime(now.year, now.month, now.day);
    return lastCompletedDate.isBefore(today);
  }
}

class HabitService extends ChangeNotifier {
  final List<Habit> _habits = [];

  List<Habit> get habits => List.unmodifiable(_habits);

  HabitService() {
    // Initialize with sample habits
    _habits.addAll([
      Habit(
        id: '1',
        name: 'Read 10 mins',
        description: 'Daily reading habit',
        icon: Icons.menu_book_rounded,
        color: const Color(0xFF6C63FF),
        streak: 5,
        xpReward: 10,
        isCompleted: false,
        isDaily: true,
        targetCount: 1,
        lastCompleted: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Habit(
        id: '2',
        name: 'Meditate',
        description: 'Daily meditation practice',
        icon: Icons.self_improvement_rounded,
        color: const Color(0xFFFF6584),
        streak: 3,
        xpReward: 15,
        isCompleted: false,
        isDaily: true,
        targetCount: 1,
        lastCompleted: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ]);
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

  void toggleHabitCompletion(String id) {
    final index = _habits.indexWhere((h) => h.id == id);
    if (index != -1) {
      final habit = _habits[index];
      final now = DateTime.now();
      
      if (habit.isCompleted) {
        // Untick the habit
        _habits[index] = habit.copyWith(
          isCompleted: false,
          streak: habit.streak > 0 ? habit.streak - 1 : 0,
          lastCompleted: now.subtract(const Duration(days: 1)),
        );
      } else if (habit.canCompleteToday()) {
        // Complete the habit
        _habits[index] = habit.copyWith(
          isCompleted: true,
          streak: habit.streak + 1,
          lastCompleted: now,
        );
      }
      notifyListeners();
    }
  }

  void resetHabit(String id) {
    final index = _habits.indexWhere((h) => h.id == id);
    if (index != -1) {
      _habits[index] = _habits[index].copyWith(
        streak: 0,
        isCompleted: false,
        lastCompleted: DateTime.now().subtract(const Duration(days: 1)),
      );
      notifyListeners();
    }
  }
} 