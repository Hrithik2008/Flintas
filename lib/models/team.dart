import 'package:uuid/uuid.dart';

class Team {
  final String id;
  final String name;
  final String track;
  final List<String> memberIds;
  final List<String> projectIds;
  final DateTime createdAt;

  Team({
    String? id,
    required this.name,
    required this.track,
    List<String>? memberIds,
    List<String>? projectIds,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        memberIds = memberIds ?? [],
        projectIds = projectIds ?? [],
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'track': track,
      'memberIds': memberIds,
      'projectIds': projectIds,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      track: json['track'],
      memberIds: List<String>.from(json['memberIds']),
      projectIds: List<String>.from(json['projectIds']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Team copyWith({
    String? name,
    String? track,
    List<String>? memberIds,
    List<String>? projectIds,
  }) {
    return Team(
      id: id,
      name: name ?? this.name,
      track: track ?? this.track,
      memberIds: memberIds ?? this.memberIds,
      projectIds: projectIds ?? this.projectIds,
      createdAt: createdAt,
    );
  }
} 