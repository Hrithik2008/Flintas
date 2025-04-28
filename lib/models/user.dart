import 'habit.dart';

class User {
  final String admissionNumber;
  final String email;
  final String name;
  final List<String> interests;
  final int xpPoints;
  final List<Habit> activeHabits;
  final List<String> goals;

  User({
    required this.admissionNumber,
    required this.email,
    required this.name,
    this.interests = const [],
    this.xpPoints = 0,
    this.activeHabits = const [],
    this.goals = const [],
  });

  User copyWith({
    String? admissionNumber,
    String? email,
    String? name,
    List<String>? interests,
    int? xpPoints,
    List<Habit>? activeHabits,
    List<String>? goals,
  }) {
    return User(
      admissionNumber: admissionNumber ?? this.admissionNumber,
      email: email ?? this.email,
      name: name ?? this.name,
      interests: interests ?? this.interests,
      xpPoints: xpPoints ?? this.xpPoints,
      activeHabits: activeHabits ?? this.activeHabits,
      goals: goals ?? this.goals,
    );
  }
} 