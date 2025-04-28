import 'package:flutter/material.dart';

class RipplePost {
  final String id;
  final String title;
  final String content;
  final IconData icon;
  final Color color;
  final int resonances;
  final List<String> comments;
  final DateTime createdAt;
  final String authorId;
  final String authorName;

  RipplePost({
    required this.id,
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
    required this.resonances,
    required this.comments,
    required this.createdAt,
    required this.authorId,
    required this.authorName,
  });

  RipplePost copyWith({
    String? id,
    String? title,
    String? content,
    IconData? icon,
    Color? color,
    int? resonances,
    List<String>? comments,
    DateTime? createdAt,
    String? authorId,
    String? authorName,
  }) {
    return RipplePost(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      resonances: resonances ?? this.resonances,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
    );
  }
}

class RippleService extends ChangeNotifier {
  List<RipplePost> _posts = [];

  List<RipplePost> get posts => _posts;

  RippleService() {
    // Initialize with some sample posts
    _posts = [
      RipplePost(
        id: '1',
        title: 'Climate Action Team',
        content: 'Join our weekly tree planting initiative!',
        icon: Icons.eco_rounded,
        color: Colors.green,
        resonances: 12,
        comments: [
          'Count me in!',
          'Great initiative!',
        ],
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        authorId: 'user1',
        authorName: 'Eco Warriors',
      ),
      RipplePost(
        id: '2',
        title: 'Book Lovers Club',
        content: 'Just finished "Atomic Habits" - amazing insights!',
        icon: Icons.menu_book_rounded,
        color: Colors.blue,
        resonances: 8,
        comments: [
          'One of my favorites!',
          'The habit stacking concept is brilliant',
        ],
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        authorId: 'user2',
        authorName: 'Book Enthusiasts',
      ),
    ];
  }

  void addPost(RipplePost post) {
    _posts.insert(0, post);
    notifyListeners();
  }

  void deletePost(String id) {
    _posts.removeWhere((post) => post.id == id);
    notifyListeners();
  }

  void addResonance(String id) {
    final index = _posts.indexWhere((p) => p.id == id);
    if (index != -1) {
      final post = _posts[index];
      _posts[index] = post.copyWith(
        resonances: post.resonances + 1,
      );
      notifyListeners();
    }
  }

  void addComment(String id, String comment) {
    final index = _posts.indexWhere((p) => p.id == id);
    if (index != -1) {
      final post = _posts[index];
      final updatedComments = List<String>.from(post.comments)..add(comment);
      _posts[index] = post.copyWith(comments: updatedComments);
      notifyListeners();
    }
  }
} 