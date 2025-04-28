import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../../core/theme.dart';
import 'world_progress.dart';
import 'world_animations.dart';

class WorldScreen extends StatelessWidget {
  const WorldScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    if (user == null) {
      return const Center(child: Text('Please log in to see your world'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My World'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Show world info dialog
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            WorldProgress(worldLevel: user.worldLevel),
            const SizedBox(height: 20),
            WorldAnimations(worldLevel: user.worldLevel),
            const SizedBox(height: 20),
            _buildNextMilestone(user),
          ],
        ),
      ),
    );
  }

  Widget _buildNextMilestone(User user) {
    final nextLevel = user.worldLevel + 1;
    final xpNeeded = nextLevel * 1000 - user.xp;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Next Milestone',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Level $nextLevel: ${_getMilestoneDescription(nextLevel)}'),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (user.xp % 1000) / 1000,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
            const SizedBox(height: 8),
            Text('$xpNeeded XP needed for next level'),
          ],
        ),
      ),
    );
  }

  String _getMilestoneDescription(int level) {
    switch (level) {
      case 2:
        return 'Plant a new tree';
      case 3:
        return 'Add flowing river';
      case 4:
        return 'Grow flowers';
      case 5:
        return 'Add mountains';
      default:
        return 'Unlock new world feature';
    }
  }
} 