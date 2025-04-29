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

  Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    this.streak = 0,
    this.xpValue = 10,
    this.isDaily = true,
    required this.startDate,
    this.completedDates = const [],
  });

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
    );
  }

  String get milestoneEmoji {
    if (streak >= 30) return '🏆';
    if (streak >= 21) return '🌟';
    if (streak >= 14) return '✨';
    if (streak >= 7) return '⭐';
    return emoji;
  }
} 