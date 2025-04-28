import 'package:uuid/uuid.dart';

class Habit {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final int streak;
  final int xpValue;
  final bool isDaily;
  final DateTime startDate;
  final List<DateTime> completedDates;
  final DateTime createdAt;

  Habit({
    String? id,
    required this.title,
    required this.description,
    required this.emoji,
    this.streak = 0,
    required this.xpValue,
    required this.isDaily,
    DateTime? startDate,
    List<DateTime>? completedDates,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        startDate = startDate ?? DateTime.now(),
        completedDates = completedDates ?? [],
        createdAt = createdAt ?? DateTime.now();

  Habit copyWith({
    String? id,
    String? title,
    String? description,
    String? emoji,
    int? streak,
    int? xpValue,
    bool? isDaily,
    DateTime? startDate,
    List<DateTime>? completedDates,
    DateTime? createdAt,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      streak: streak ?? this.streak,
      xpValue: xpValue ?? this.xpValue,
      isDaily: isDaily ?? this.isDaily,
      startDate: startDate ?? this.startDate,
      completedDates: completedDates ?? this.completedDates,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get milestoneEmoji {
    if (streak >= 30) return '🏆';
    if (streak >= 21) return '🌟';
    if (streak >= 14) return '✨';
    if (streak >= 7) return '⭐';
    return emoji;
  }

  bool isCompletedForDate(DateTime date) {
    return completedDates.any((completedDate) =>
        completedDate.year == date.year &&
        completedDate.month == date.month &&
        completedDate.day == date.day);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'emoji': emoji,
      'streak': streak,
      'xpValue': xpValue,
      'isDaily': isDaily,
      'startDate': startDate.toIso8601String(),
      'completedDates': completedDates.map((date) => date.toIso8601String()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      emoji: json['emoji'],
      streak: json['streak'],
      xpValue: json['xpValue'],
      isDaily: json['isDaily'],
      startDate: DateTime.parse(json['startDate']),
      completedDates: (json['completedDates'] as List)
          .map((date) => DateTime.parse(date))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
} 