import 'package:flutter/foundation.dart';

class RipplePost {
  final String id;
  final String userId;
  final String userName;
  final String content;
  final List<String> likes;
  final List<RippleComment> comments;
  final DateTime timestamp;
  final String? imageUrl;

  RipplePost({
    required this.id,
    required this.userId,
    required this.userName,
    required this.content,
    required this.likes,
    required this.comments,
    required this.timestamp,
    this.imageUrl,
  });

  RipplePost copyWith({
    String? id,
    String? userId,
    String? userName,
    String? content,
    List<String>? likes,
    List<RippleComment>? comments,
    DateTime? timestamp,
    String? imageUrl,
  }) {
    return RipplePost(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      content: content ?? this.content,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      timestamp: timestamp ?? this.timestamp,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class RippleComment {
  final String id;
  final String userId;
  final String userName;
  final String content;
  final DateTime timestamp;

  RippleComment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.content,
    required this.timestamp,
  });
}

class RippleService extends ChangeNotifier {
  final List<RipplePost> _posts = [];

  List<RipplePost> get posts => List.unmodifiable(_posts);

  RippleService() {
    // Initialize with sample posts
    _posts.addAll([
      RipplePost(
        id: '1',
        userId: 'user1',
        userName: 'John Doe',
        content: 'Just completed my morning meditation! Feeling refreshed and ready for the day. 🧘‍♂️',
        likes: ['user2', 'user3'],
        comments: [
          RippleComment(
            id: '1',
            userId: 'user2',
            userName: 'Jane Smith',
            content: 'Great job! Keep it up!',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          ),
        ],
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      RipplePost(
        id: '2',
        userId: 'user2',
        userName: 'Jane Smith',
        content: 'Started reading "Atomic Habits" today. Any tips for building better habits? 📚',
        likes: ['user1'],
        comments: [],
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ]);
  }

  void addPost(String content, {String? imageUrl}) {
    final post = RipplePost(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user', // TODO: Replace with actual user ID
      userName: 'Current User', // TODO: Replace with actual username
      content: content,
      likes: [],
      comments: [],
      timestamp: DateTime.now(),
      imageUrl: imageUrl,
    );
    _posts.insert(0, post);
    notifyListeners();
  }

  void deletePost(String id) {
    _posts.removeWhere((post) => post.id == id);
    notifyListeners();
  }

  void toggleLike(String postId, String userId) {
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final post = _posts[index];
      final likes = List<String>.from(post.likes);
      if (likes.contains(userId)) {
        likes.remove(userId);
      } else {
        likes.add(userId);
      }
      _posts[index] = post.copyWith(likes: likes);
      notifyListeners();
    }
  }

  void addComment(String postId, String content, String userId, String userName) {
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final post = _posts[index];
      final comments = List<RippleComment>.from(post.comments);
      comments.add(RippleComment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        userName: userName,
        content: content,
        timestamp: DateTime.now(),
      ));
      _posts[index] = post.copyWith(comments: comments);
      notifyListeners();
    }
  }

  void deleteComment(String postId, String commentId) {
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final post = _posts[index];
      final comments = post.comments.where((comment) => comment.id != commentId).toList();
      _posts[index] = post.copyWith(comments: comments);
      notifyListeners();
    }
  }
} 