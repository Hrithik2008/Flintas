import 'package:flutter/material.dart';

class Connection {
  final String id;
  final String name;
  final String bio;
  final List<String> interests;
  final IconData icon;
  final Color color;
  final bool isGroup;
  final List<String> members;
  final String? imageUrl;

  Connection({
    required this.id,
    required this.name,
    required this.bio,
    required this.interests,
    required this.icon,
    required this.color,
    this.isGroup = false,
    this.members = const [],
    this.imageUrl,
  });
}

class ConnectionService extends ChangeNotifier {
  final List<Connection> _connections = [];
  List<Connection> get connections => _connections;

  ConnectionService() {
    // Initialize with sample connections
    _connections.addAll([
      Connection(
        id: '1',
        name: 'John Doe',
        bio: 'Computer Science Student',
        interests: ['Programming', 'Gaming', 'Reading'],
        icon: Icons.person,
        color: Colors.blue,
        imageUrl: 'https://i.pravatar.cc/150?img=1',
      ),
      Connection(
        id: '2',
        name: 'Jane Smith',
        bio: 'Art & Design Student',
        interests: ['Drawing', 'Photography', 'Music'],
        icon: Icons.person,
        color: Colors.purple,
        imageUrl: 'https://i.pravatar.cc/150?img=2',
      ),
      Connection(
        id: '3',
        name: 'Coding Club',
        bio: 'Join us for weekly coding challenges and workshops!',
        interests: ['Programming', 'Web Development', 'Mobile Apps'],
        icon: Icons.code,
        color: Colors.green,
        isGroup: true,
        members: ['user1', 'user2'],
        imageUrl: 'https://i.pravatar.cc/150?img=3',
      ),
      Connection(
        id: '4',
        name: 'Book Lovers',
        bio: 'A community of avid readers sharing book recommendations',
        interests: ['Reading', 'Literature', 'Book Reviews'],
        icon: Icons.book,
        color: Colors.orange,
        isGroup: true,
        members: ['user1', 'user2'],
        imageUrl: 'https://i.pravatar.cc/150?img=4',
      ),
    ]);
  }

  void addConnection(Connection connection) {
    _connections.add(connection);
    notifyListeners();
  }

  void removeConnection(String id) {
    _connections.removeWhere((connection) => connection.id == id);
    notifyListeners();
  }

  void joinGroup(String groupId, String userId) {
    final index = _connections.indexWhere((connection) => connection.id == groupId);
    if (index != -1 && _connections[index].isGroup) {
      final group = _connections[index];
      final members = List<String>.from(group.members);
      if (!members.contains(userId)) {
        members.add(userId);
        _connections[index] = Connection(
          id: group.id,
          name: group.name,
          bio: group.bio,
          interests: group.interests,
          icon: group.icon,
          color: group.color,
          isGroup: true,
          members: members,
          imageUrl: group.imageUrl,
        );
        notifyListeners();
      }
    }
  }

  void leaveGroup(String groupId, String userId) {
    final index = _connections.indexWhere((connection) => connection.id == groupId);
    if (index != -1 && _connections[index].isGroup) {
      final group = _connections[index];
      final members = List<String>.from(group.members);
      members.remove(userId);
      _connections[index] = Connection(
        id: group.id,
        name: group.name,
        bio: group.bio,
        interests: group.interests,
        icon: group.icon,
        color: group.color,
        isGroup: true,
        members: members,
        imageUrl: group.imageUrl,
      );
      notifyListeners();
    }
  }
} 