import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/service_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitService = ServiceProvider.of(context).habitService;
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar with XP Points
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              backgroundColor: Theme.of(context).colorScheme.background,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text('Dashboard'),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.water_drop),
                  onPressed: () {
                    Navigator.pushNamed(context, '/ripple');
                  },
                  tooltip: 'Ripple Board',
                ),
              ],
            ),

            // Main Content
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Active Habits Section
                  _buildSectionHeader(
                    context,
                    'Active Habits',
                    Icons.timeline_rounded,
                    onTap: () => Navigator.pushNamed(context, '/habits'),
                  ),
                  const SizedBox(height: 16),
                  ListenableBuilder(
                    listenable: habitService,
                    builder: (context, _) => SizedBox(
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: habitService.habits.length,
                        itemBuilder: (context, index) {
                          final habit = habitService.habits[index];
                          return _buildHabitCard(
                            habit.name,
                            '${habit.streak} day streak',
                            habit.isDaily ? 1.0 : (habit.streak / habit.targetCount),
                            habit.icon,
                            habit.color,
                            onTap: () => Navigator.pushNamed(context, '/habits'),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Recent Ripple Posts
                  _buildSectionHeader(
                    context,
                    'Recent Ripples',
                    Icons.water_drop_rounded,
                    onTap: () => Navigator.pushNamed(context, '/ripple'),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      _buildRipplePost(
                        'Climate Action Team',
                        'Join our weekly tree planting initiative!',
                        Icons.eco_rounded,
                        AppTheme.successColor,
                        12,
                      ),
                      const SizedBox(height: 12),
                      _buildRipplePost(
                        'Book Lovers Club',
                        'Just finished "Atomic Habits" - amazing insights!',
                        Icons.menu_book_rounded,
                        AppTheme.primaryColor,
                        8,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Connection Suggestions
                  _buildSectionHeader(
                    context,
                    'People You Might Click With',
                    Icons.people_rounded,
                    onTap: () => Navigator.pushNamed(context, '/connections'),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        final connections = [
                          ('Alex', 'Science, Environment', Icons.science_rounded, AppTheme.primaryColor, false),
                          ('Sam', 'Music, Reading', Icons.music_note_rounded, AppTheme.secondaryColor, true),
                          ('Jordan', 'Tech, Writing', Icons.computer_rounded, AppTheme.accentColor, false),
                        ];
                        final (name, interests, icon, color, isOnline) = connections[index];
                        return _buildConnectionCard(name, interests, icon, color, isOnline: isOnline);
                      },
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          TextButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.arrow_forward_rounded, size: 16),
            label: const Text('See All'),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitCard(
    String title,
    String subtitle,
    double progress,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 16),
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: color.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRipplePost(
    String title,
    String content,
    IconData icon,
    Color color,
    int resonances,
  ) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: TextStyle(
                color: Colors.grey.shade800,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border_rounded),
                  onPressed: () {},
                  color: color,
                ),
                Text(
                  '$resonances',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                  label: const Text('Comment'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionCard(
    String name,
    String interests,
    IconData icon,
    Color color, {
    bool isOnline = false,
  }) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: color.withOpacity(0.2),
                    child: Icon(icon, color: color, size: 30),
                  ),
                  if (isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppTheme.successColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                interests,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(120, 36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Say Hello'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 