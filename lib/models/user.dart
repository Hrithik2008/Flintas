import 'habit.dart';
import 'package:uuid/uuid.dart';

class User {
  final String id;
  final String username;
  final String track;
  final int xp;
  final int worldLevel;
  final List<String> badges;
  final List<String> teamIds;
  final DateTime createdAt;

  User({
    String? id,
    required this.username,
    required this.track,
    this.xp = 0,
    this.worldLevel = 1,
    List<String>? badges,
    List<String>? teamIds,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        badges = badges ?? [],
        teamIds = teamIds ?? [],
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'track': track,
      'xp': xp,
      'worldLevel': worldLevel,
      'badges': badges,
      'teamIds': teamIds,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      track: json['track'],
      xp: json['xp'],
      worldLevel: json['worldLevel'],
      badges: List<String>.from(json['badges']),
      teamIds: List<String>.from(json['teamIds']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  User copyWith({
    String? username,
    String? track,
    int? xp,
    int? worldLevel,
    List<String>? badges,
    List<String>? teamIds,
  }) {
    return User(
      id: id,
      username: username ?? this.username,
      track: track ?? this.track,
      xp: xp ?? this.xp,
      worldLevel: worldLevel ?? this.worldLevel,
      badges: badges ?? this.badges,
      teamIds: teamIds ?? this.teamIds,
      createdAt: createdAt,
    );
  }
} 