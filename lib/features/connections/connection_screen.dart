import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class Connection {
  final String name;
  final String bio;
  final List<String> interests;
  final IconData icon;
  final Color color;
  final bool isGroup;

  const Connection({
    required this.name,
    required this.bio,
    required this.interests,
    required this.icon,
    required this.color,
    this.isGroup = false,
  });
}

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  final List<Connection> connections = [
    const Connection(
      name: 'Alex',
      bio: 'Environmental science student passionate about sustainability',
      interests: ['Environment', 'Science', 'Reading'],
      icon: Icons.science_rounded,
      color: AppTheme.primaryColor,
    ),
    const Connection(
      name: 'Sam',
      bio: 'Music enthusiast and book lover',
      interests: ['Music', 'Reading', 'Writing'],
      icon: Icons.music_note_rounded,
      color: AppTheme.secondaryColor,
    ),
    const Connection(
      name: 'Jordan',
      bio: 'Tech enthusiast and aspiring writer',
      interests: ['Tech', 'Writing', 'Science'],
      icon: Icons.computer_rounded,
      color: AppTheme.accentColor,
    ),
    const Connection(
      name: 'Climate Action Team',
      bio: 'Weekly tree planting and environmental awareness group',
      interests: ['Environment', 'Science'],
      icon: Icons.eco_rounded,
      color: AppTheme.successColor,
      isGroup: true,
    ),
    const Connection(
      name: 'Book Lovers Club',
      bio: 'Monthly book discussions and reading challenges',
      interests: ['Reading', 'Writing'],
      icon: Icons.menu_book_rounded,
      color: AppTheme.primaryColor,
      isGroup: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text('Connection Nest'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'People'),
              Tab(text: 'Groups'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildPeopleList(),
            _buildGroupsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPeopleList() {
    final people = connections.where((c) => !c.isGroup).toList();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: people.length,
      itemBuilder: (context, index) {
        final person = people[index];
        return _buildConnectionCard(person);
      },
    );
  }

  Widget _buildGroupsList() {
    final groups = connections.where((c) => c.isGroup).toList();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return _buildConnectionCard(group);
      },
    );
  }

  Widget _buildConnectionCard(Connection connection) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: connection.color.withOpacity(0.2),
                  child: Icon(connection.icon, color: connection.color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        connection.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        connection.bio,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: connection.interests.map((interest) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: connection.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    interest,
                    style: TextStyle(
                      fontSize: 12,
                      color: connection.color,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: connection.color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(connection.isGroup ? 'Join Group' : 'Say Hello'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 