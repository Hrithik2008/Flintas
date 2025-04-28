import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/habit.dart';
import '../../services/database_service.dart';
import '../../core/theme.dart';

class CreateHabitDialog extends StatefulWidget {
  const CreateHabitDialog({Key? key}) : super(key: key);

  @override
  State<CreateHabitDialog> createState() => _CreateHabitDialogState();
}

class _CreateHabitDialogState extends State<CreateHabitDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isDaily = true;
  int _xpValue = 10;
  String _selectedEmoji = '🌟';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Habit'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Habit Title',
                hintText: 'Enter habit title',
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
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter habit description',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedEmoji,
              decoration: const InputDecoration(
                labelText: 'Emoji',
                hintText: 'Select an emoji',
              ),
              items: const [
                DropdownMenuItem(value: '🌟', child: Text('🌟 Star')),
                DropdownMenuItem(value: '🎯', child: Text('🎯 Target')),
                DropdownMenuItem(value: '💪', child: Text('💪 Muscle')),
                DropdownMenuItem(value: '📚', child: Text('📚 Book')),
                DropdownMenuItem(value: '🧘', child: Text('🧘 Meditation')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedEmoji = value);
                }
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Daily Habit'),
              subtitle: Text(
                _isDaily
                    ? 'Complete this habit every day'
                    : 'Complete this habit weekly',
              ),
              value: _isDaily,
              onChanged: (value) => setState(() => _isDaily = value),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _xpValue,
              decoration: const InputDecoration(
                labelText: 'XP Value',
                hintText: 'Select XP value',
              ),
              items: const [
                DropdownMenuItem(
                  value: 10,
                  child: Text('10 XP'),
                ),
                DropdownMenuItem(
                  value: 20,
                  child: Text('20 XP'),
                ),
                DropdownMenuItem(
                  value: 30,
                  child: Text('30 XP'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _xpValue = value);
                }
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
          onPressed: _createHabit,
          child: const Text('Create'),
        ),
      ],
    );
  }

  Future<void> _createHabit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final habit = Habit(
        title: _titleController.text,
        description: _descriptionController.text,
        emoji: _selectedEmoji,
        xpValue: _xpValue,
        isDaily: _isDaily,
      );

      final databaseService = Provider.of<DatabaseService>(context, listen: false);
      await databaseService.insertHabit(habit);

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }
} 