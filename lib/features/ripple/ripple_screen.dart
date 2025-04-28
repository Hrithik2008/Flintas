import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/service_provider.dart';
import '../../../core/services/ripple_service.dart';

class RippleScreen extends StatefulWidget {
  const RippleScreen({Key? key}) : super(key: key);

  @override
  State<RippleScreen> createState() => _RippleScreenState();
}

class _RippleScreenState extends State<RippleScreen> {
  final _contentController = TextEditingController();
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _contentController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _showCreatePostDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Ripple'),
        content: TextField(
          controller: _contentController,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'What\'s on your mind?',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_contentController.text.isNotEmpty) {
                final rippleService = ServiceProvider.of(context).rippleService;
                rippleService.addPost(_contentController.text);
                _contentController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  void _showCommentsDialog(RipplePost post) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Comments',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListenableBuilder(
                  listenable: ServiceProvider.of(context).rippleService,
                  builder: (context, _) {
                    final updatedPost = ServiceProvider.of(context).rippleService.posts
                        .firstWhere((p) => p.id == post.id);
                    return ListView.builder(
                      itemCount: updatedPost.comments.length,
                      itemBuilder: (context, index) {
                        final comment = updatedPost.comments[index];
                        return ListTile(
                          title: Text(comment.userName),
                          subtitle: Text(comment.content),
                          trailing: Text(
                            _formatTimeAgo(comment.timestamp),
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Add a comment...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (_commentController.text.isNotEmpty) {
                        final rippleService = ServiceProvider.of(context).rippleService;
                        rippleService.addComment(
                          post.id,
                          _commentController.text,
                          'current_user', // TODO: Replace with actual user ID
                          'Current User', // TODO: Replace with actual username
                        );
                        _commentController.clear();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final rippleService = ServiceProvider.of(context).rippleService;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ripple Board'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Navigator.pushNamed(context, '/dashboard');
          },
        ),
      ),
      body: ListenableBuilder(
        listenable: rippleService,
        builder: (context, _) => ListView.builder(
          itemCount: rippleService.posts.length,
          itemBuilder: (context, index) {
            final post = rippleService.posts[index];
            final isLiked = post.likes.contains('current_user'); // TODO: Replace with actual user ID

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      child: Text(post.userName[0]),
                    ),
                    title: Text(post.userName),
                    subtitle: Text(_formatTimeAgo(post.timestamp)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(post.content),
                  ),
                  if (post.imageUrl != null)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Image.network(post.imageUrl!),
                    ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton.icon(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : null,
                        ),
                        label: Text('${post.likes.length}'),
                        onPressed: () => rippleService.toggleLike(
                          post.id,
                          'current_user', // TODO: Replace with actual user ID
                        ),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.comment),
                        label: Text('${post.comments.length}'),
                        onPressed: () => _showCommentsDialog(post),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePostDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NewPostDialog extends StatefulWidget {
  const NewPostDialog({super.key});

  @override
  State<NewPostDialog> createState() => _NewPostDialogState();
}

class _NewPostDialogState extends State<NewPostDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  IconData _selectedInterest = Icons.eco_rounded;
  Color _selectedColor = AppTheme.successColor;

  final List<Map<String, dynamic>> _interests = [
    {
      'icon': Icons.eco_rounded,
      'color': AppTheme.successColor,
      'label': 'Environment',
    },
    {
      'icon': Icons.menu_book_rounded,
      'color': AppTheme.primaryColor,
      'label': 'Reading',
    },
    {
      'icon': Icons.music_note_rounded,
      'color': AppTheme.secondaryColor,
      'label': 'Music',
    },
    {
      'icon': Icons.science_rounded,
      'color': AppTheme.accentColor,
      'label': 'Science',
    },
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Create New Post',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    prefixIcon: Icon(Icons.title_rounded),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    prefixIcon: Icon(Icons.edit_rounded),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some content';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text('Select Interest'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _interests.map((interest) {
                    final isSelected = interest['icon'] == _selectedInterest;
                    return ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            interest['icon'],
                            color: isSelected ? Colors.white : interest['color'],
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(interest['label']),
                        ],
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedInterest = interest['icon'];
                            _selectedColor = interest['color'];
                          });
                        }
                      },
                      backgroundColor: interest['color'].withOpacity(0.2),
                      selectedColor: interest['color'],
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.pop(context);
              }
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }
} 