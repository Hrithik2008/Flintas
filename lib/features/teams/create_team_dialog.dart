import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/team.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../../core/theme.dart';
import '../../providers/user_provider.dart';

class CreateTeamDialog extends StatefulWidget {
  const CreateTeamDialog({Key? key}) : super(key: key);

  @override
  State<CreateTeamDialog> createState() => _CreateTeamDialogState();
}

class _CreateTeamDialogState extends State<CreateTeamDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedTrack = '';

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user;
    if (user != null) {
      _selectedTrack = user.track;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Team'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Team Name',
                hintText: 'Enter team name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a team name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedTrack,
              decoration: const InputDecoration(
                labelText: 'Track',
                hintText: 'Select track',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Mindfulness',
                  child: Text('Mindfulness'),
                ),
                DropdownMenuItem(
                  value: 'Eco',
                  child: Text('Eco'),
                ),
                DropdownMenuItem(
                  value: 'Fitness',
                  child: Text('Fitness'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedTrack = value);
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a track';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _createTeam,
          child: const Text('Create'),
        ),
      ],
    );
  }

  Future<void> _createTeam() async {
    if (_formKey.currentState?.validate() ?? false) {
      final user = context.read<UserProvider>().user;
      if (user == null) return;

      final team = Team(
        name: _nameController.text,
        track: _selectedTrack,
        memberIds: [user.id],
      );

      final databaseService = context.read<DatabaseService>();
      await databaseService.insertTeam(team);

      // Update user's team list
      final updatedUser = user.copyWith(
        teamIds: [...user.teamIds, team.id],
      );
      await databaseService.insertUser(updatedUser);
      context.read<UserProvider>().updateUser(updatedUser);

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }
} 