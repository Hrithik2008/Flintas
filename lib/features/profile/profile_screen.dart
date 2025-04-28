import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class Badge {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final bool isUnlocked;

  Badge({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    this.isUnlocked = false,
  });
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<String> _interests = [
    'Reading',
    'Environment',
    'Technology',
    'Music',
    'Science',
  ];

  final List<Badge> _badges = [
    Badge(
      name: 'Early Bird',
      description: 'Complete 5 morning habits',
      icon: Icons.wb_sunny_rounded,
      color: AppTheme.primaryColor,
      isUnlocked: true,
    ),
    Badge(
      name: 'Book Worm',
      description: 'Read for 7 days straight',
      icon: Icons.menu_book_rounded,
      color: AppTheme.secondaryColor,
      isUnlocked: true,
    ),
    Badge(
      name: 'Eco Warrior',
      description: 'Plant 3 trees',
      icon: Icons.eco_rounded,
      color: AppTheme.successColor,
    ),
    Badge(
      name: 'Social Butterfly',
      description: 'Connect with 10 people',
      icon: Icons.people_rounded,
      color: AppTheme.accentColor,
    ),
  ];

  void _showEditInterestsDialog() {
    showDialog(
      context: context,
      builder: (context) => EditInterestsDialog(
        interests: _interests,
        onSave: (newInterests) {
          setState(() {
            _interests.clear();
            _interests.addAll(newInterests);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Profile Header
            SliverAppBar(
              expandedHeight: 280,
              floating: false,
              pinned: true,
              backgroundColor: Theme.of(context).colorScheme.background,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.primaryColor.withOpacity(0.2),
                        Theme.of(context).colorScheme.background,
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?img=3',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Alex Johnson',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Science Enthusiast | Book Lover',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // Main Content
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Stats Row
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem(
                          context,
                          Icons.star_rounded,
                          '1,250',
                          'XP Points',
                          AppTheme.accentColor,
                        ),
                        _buildStatItem(
                          context,
                          Icons.workspace_premium_rounded,
                          '5',
                          'Level',
                          AppTheme.primaryColor,
                        ),
                        _buildStatItem(
                          context,
                          Icons.emoji_events_rounded,
                          '2',
                          'Badges',
                          AppTheme.secondaryColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Interests Section
                  _buildSectionHeader(
                    context,
                    'Your Interests',
                    Icons.interests_rounded,
                    onTap: _showEditInterestsDialog,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _interests.map((interest) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getInterestIcon(interest),
                              size: 16,
                              color: AppTheme.primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              interest,
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),

                  // Badges Section
                  _buildSectionHeader(
                    context,
                    'Your Badges',
                    Icons.emoji_events_rounded,
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _badges.length,
                    itemBuilder: (context, index) {
                      final badge = _badges[index];
                      return _buildBadgeCard(badge);
                    },
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
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
        if (onTap != null)
          TextButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.edit_rounded, size: 16),
            label: const Text('Edit'),
          ),
      ],
    );
  }

  Widget _buildBadgeCard(Badge badge) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: badge.isUnlocked
                    ? badge.color.withOpacity(0.2)
                    : Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                badge.icon,
                color: badge.isUnlocked ? badge.color : Colors.grey.shade400,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              badge.name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: badge.isUnlocked ? Colors.black : Colors.grey.shade400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              badge.description,
              style: TextStyle(
                fontSize: 12,
                color: badge.isUnlocked ? Colors.grey.shade600 : Colors.grey.shade400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getInterestIcon(String interest) {
    switch (interest.toLowerCase()) {
      case 'reading':
        return Icons.menu_book_rounded;
      case 'environment':
        return Icons.eco_rounded;
      case 'technology':
        return Icons.computer_rounded;
      case 'music':
        return Icons.music_note_rounded;
      case 'science':
        return Icons.science_rounded;
      default:
        return Icons.interests_rounded;
    }
  }
}

class EditInterestsDialog extends StatefulWidget {
  final List<String> interests;
  final Function(List<String>) onSave;

  const EditInterestsDialog({
    super.key,
    required this.interests,
    required this.onSave,
  });

  @override
  State<EditInterestsDialog> createState() => _EditInterestsDialogState();
}

class _EditInterestsDialogState extends State<EditInterestsDialog> {
  late List<String> _selectedInterests;

  @override
  void initState() {
    super.initState();
    _selectedInterests = List.from(widget.interests);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Interests'),
      content: SingleChildScrollView(
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            'Reading',
            'Environment',
            'Technology',
            'Music',
            'Science',
            'Art',
            'Sports',
            'Cooking',
            'Travel',
            'Photography',
          ].map((interest) {
            final isSelected = _selectedInterests.contains(interest);
            return ChoiceChip(
              label: Text(interest),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedInterests.add(interest);
                  } else {
                    _selectedInterests.remove(interest);
                  }
                });
              },
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              backgroundColor: Colors.grey.shade200,
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.primaryColor : Colors.black,
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(_selectedInterests);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
} 