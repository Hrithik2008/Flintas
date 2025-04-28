import 'package:flutter/material.dart';

class Badge {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final bool isUnlocked;
  final int xpReward;
  final String unlockCondition;

  Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.isUnlocked,
    required this.xpReward,
    required this.unlockCondition,
  });

  Badge copyWith({
    String? id,
    String? name,
    String? description,
    IconData? icon,
    Color? color,
    bool? isUnlocked,
    int? xpReward,
    String? unlockCondition,
  }) {
    return Badge(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      xpReward: xpReward ?? this.xpReward,
      unlockCondition: unlockCondition ?? this.unlockCondition,
    );
  }
}

class ProfileService extends ChangeNotifier {
  String _name = 'Alex Johnson';
  String _bio = 'Science Enthusiast | Book Lover';
  String _avatarUrl = 'https://i.pravatar.cc/150?img=3';
  List<String> _interests = ['Reading', 'Environment', 'Technology', 'Music', 'Science'];
  int _xp = 1250;
  int _level = 5;
  List<Badge> _badges = [];

  String get name => _name;
  String get bio => _bio;
  String get avatarUrl => _avatarUrl;
  List<String> get interests => _interests;
  int get xp => _xp;
  int get level => _level;
  List<Badge> get badges => _badges;

  ProfileService() {
    // Initialize with some sample badges
    _badges = [
      Badge(
        id: '1',
        name: 'Early Bird',
        description: 'Complete 5 morning habits',
        icon: Icons.wb_sunny_rounded,
        color: Colors.orange,
        isUnlocked: true,
        xpReward: 100,
        unlockCondition: 'Complete 5 morning habits',
      ),
      Badge(
        id: '2',
        name: 'Book Worm',
        description: 'Read for 7 days straight',
        icon: Icons.menu_book_rounded,
        color: Colors.blue,
        isUnlocked: true,
        xpReward: 150,
        unlockCondition: 'Read for 7 consecutive days',
      ),
      Badge(
        id: '3',
        name: 'Eco Warrior',
        description: 'Plant 3 trees',
        icon: Icons.eco_rounded,
        color: Colors.green,
        isUnlocked: false,
        xpReward: 200,
        unlockCondition: 'Plant 3 trees',
      ),
      Badge(
        id: '4',
        name: 'Social Butterfly',
        description: 'Connect with 10 people',
        icon: Icons.people_rounded,
        color: Colors.purple,
        isUnlocked: false,
        xpReward: 150,
        unlockCondition: 'Connect with 10 people',
      ),
    ];
  }

  void updateProfile({
    String? name,
    String? bio,
    String? avatarUrl,
    List<String>? interests,
  }) {
    _name = name ?? _name;
    _bio = bio ?? _bio;
    _avatarUrl = avatarUrl ?? _avatarUrl;
    _interests = interests ?? _interests;
    notifyListeners();
  }

  void addXP(int amount) {
    _xp += amount;
    _checkLevelUp();
    notifyListeners();
  }

  void _checkLevelUp() {
    final xpForNextLevel = _level * 250;
    if (_xp >= xpForNextLevel) {
      _level++;
      _xp -= xpForNextLevel;
    }
  }

  void unlockBadge(String id) {
    final index = _badges.indexWhere((b) => b.id == id);
    if (index != -1) {
      _badges[index] = _badges[index].copyWith(isUnlocked: true);
      addXP(_badges[index].xpReward);
      notifyListeners();
    }
  }

  void addInterest(String interest) {
    if (!_interests.contains(interest)) {
      _interests.add(interest);
      notifyListeners();
    }
  }

  void removeInterest(String interest) {
    _interests.remove(interest);
    notifyListeners();
  }

  void updateInterests(List<String> interests) {
    _interests = interests;
    notifyListeners();
  }
} 