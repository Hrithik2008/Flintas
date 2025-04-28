import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../models/team.dart';
import '../../services/database_service.dart';
import '../../providers/user_provider.dart';
import 'team_card.dart';
import 'create_team_dialog.dart';

class TeamsScreen extends StatelessWidget {
  const TeamsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    if (user == null) {
      return const Center(child: Text('Please log in to see your teams'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Teams'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateTeamDialog(context),
          ),
        ],
      ),
      body: FutureBuilder<List<Team>>(
        future: _loadUserTeams(context, user),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final teams = snapshot.data ?? [];
          if (teams.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No teams yet'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _showCreateTeamDialog(context),
                    child: const Text('Create a Team'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: teams.length,
            itemBuilder: (context, index) {
              return TeamCard(team: teams[index]);
            },
          );
        },
      ),
    );
  }

  Future<List<Team>> _loadUserTeams(BuildContext context, User user) async {
    final databaseService = context.read<DatabaseService>();
    final teams = <Team>[];
    
    for (final teamId in user.teamIds) {
      final team = await databaseService.getTeam(teamId);
      if (team != null) {
        teams.add(team);
      }
    }
    
    return teams;
  }

  void _showCreateTeamDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateTeamDialog(),
    );
  }
} 