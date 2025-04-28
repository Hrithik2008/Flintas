import 'package:flutter/material.dart';

class Connection {
  final String id;
  final String name;
  final String bio;
  final List<String> interests;
  final IconData icon;
  final Color color;
  final bool isOnline;
  final bool isGroup;
  final List<String> members;
  final String? groupDescription;

  Connection({
    required this.id,
    required this.name,
    required this.bio,
    required this.interests,
    required this.icon,
    required this.color,
    required this.isOnline,
    required this.isGroup,
    this.members = const [],
    this.groupDescription,
  });

  Connection copyWith({
    String? id,
    String? name,
    String? bio,
    List<String>? interests,
    IconData? icon,
    Color? color,
    bool? isOnline,
    bool? isGroup,
    List<String>? members,
    String? groupDescription,
  }) {
    return Connection(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isOnline: isOnline ?? this.isOnline,
      isGroup: isGroup ?? this.isGroup,
      members: members ?? this.members,
      groupDescription: groupDescription ?? this.groupDescription,
    );
  }
}

class ConnectionService extends ChangeNotifier {
  List<Connection> _connections = [];
  List<Connection> _groups = [];

  List<Connection> get connections => _connections;
  List<Connection> get groups => _groups;

  ConnectionService() {
    // Initialize with some sample connections
    _connections = [
      Connection(
        id: '1',
        name: 'Alex',
        bio: 'Science Enthusiast',
        interests: ['Science', 'Environment'],
        icon: Icons.science_rounded,
        color: Colors.blue,
        isOnline: false,
        isGroup: false,
      ),
      Connection(
        id: '2',
        name: 'Sam',
        bio: 'Music Lover',
        interests: ['Music', 'Reading'],
        icon: Icons.music_note_rounded,
        color: Colors.purple,
        isOnline: true,
        isGroup: false,
      ),
      Connection(
        id: '3',
        name: 'Jordan',
        bio: 'Tech Enthusiast',
        interests: ['Technology', 'Writing'],
        icon: Icons.computer_rounded,
        color: Colors.teal,
        isOnline: false,
        isGroup: false,
      ),
    ];

    // Initialize with some sample groups
    _groups = [
      Connection(
        id: 'g1',
        name: 'Climate Action Team',
        bio: 'Environmental activists',
        interests: ['Environment', 'Science'],
        icon: Icons.eco_rounded,
        color: Colors.green,
        isOnline: true,
        isGroup: true,
        members: ['user1', 'user2', 'user3'],
        groupDescription: 'Join us in making a difference for our planet!',
      ),
      Connection(
        id: 'g2',
        name: 'Book Lovers Club',
        bio: 'Reading enthusiasts',
        interests: ['Reading', 'Literature'],
        icon: Icons.menu_book_rounded,
        color: Colors.orange,
        isOnline: true,
        isGroup: true,
        members: ['user4', 'user5'],
        groupDescription: 'Share your favorite books and discuss literature!',
      ),
    ];
  }

  void addConnection(Connection connection) {
    if (connection.isGroup) {
      _groups.add(connection);
    } else {
      _connections.add(connection);
    }
    notifyListeners();
  }

  void updateConnection(Connection connection) {
    if (connection.isGroup) {
      final index = _groups.indexWhere((c) => c.id == connection.id);
      if (index != -1) {
        _groups[index] = connection;
      }
    } else {
      final index = _connections.indexWhere((c) => c.id == connection.id);
      if (index != -1) {
        _connections[index] = connection;
      }
    }
    notifyListeners();
  }

  void deleteConnection(String id, bool isGroup) {
    if (isGroup) {
      _groups.removeWhere((c) => c.id == id);
    } else {
      _connections.removeWhere((c) => c.id == id);
    }
    notifyListeners();
  }

  void joinGroup(String groupId, String userId) {
    final index = _groups.indexWhere((g) => g.id == groupId);
    if (index != -1) {
      final group = _groups[index];
      if (!group.members.contains(userId)) {
        final updatedMembers = List<String>.from(group.members)..add(userId);
        _groups[index] = group.copyWith(members: updatedMembers);
        notifyListeners();
      }
    }
  }

  void leaveGroup(String groupId, String userId) {
    final index = _groups.indexWhere((g) => g.id == groupId);
    if (index != -1) {
      final group = _groups[index];
      final updatedMembers = List<String>.from(group.members)..remove(userId);
      _groups[index] = group.copyWith(members: updatedMembers);
      notifyListeners();
    }
  }

  void updateOnlineStatus(String id, bool isOnline, bool isGroup) {
    if (isGroup) {
      final index = _groups.indexWhere((c) => c.id == id);
      if (index != -1) {
        _groups[index] = _groups[index].copyWith(isOnline: isOnline);
      }
    } else {
      final index = _connections.indexWhere((c) => c.id == id);
      if (index != -1) {
        _connections[index] = _connections[index].copyWith(isOnline: isOnline);
      }
    }
    notifyListeners();
  }
} 