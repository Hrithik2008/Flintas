import 'package:flutter/material.dart';
import '../../../core/providers/service_provider.dart';
import '../../../core/services/habit_service.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({Key? key}) : super(key: key);

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  IconData _selectedIcon = Icons.fitness_center;
  Color _selectedColor = Colors.blue;
  bool _isDaily = true;
  int _targetCount = 1;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showAddEditHabitDialog([Habit? habit]) {
    if (habit != null) {
      _nameController.text = habit.name;
      _descriptionController.text = habit.description;
      _selectedIcon = habit.icon;
      _selectedColor = habit.color;
      _isDaily = habit.isDaily;
      _targetCount = habit.targetCount;
    } else {
      _nameController.clear();
      _descriptionController.clear();
      _selectedIcon = Icons.fitness_center;
      _selectedColor = Colors.blue;
      _isDaily = true;
      _targetCount = 1;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(habit == null ? 'Add Habit' : 'Edit Habit'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Habit Name'),
                    validator: (value) => value?.isEmpty ?? true ? 'Please enter a name' : null,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Icon:'),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(_selectedIcon),
                        color: _selectedColor,
                        onPressed: () => _showIconPicker(setState),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Color:'),
                      const SizedBox(width: 8),
                      ...Colors.primaries.map((color) => GestureDetector(
                        onTap: () => setState(() => _selectedColor = color),
                        child: Container(
                          width: 24,
                          height: 24,
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedColor == color ? Colors.black : Colors.grey,
                              width: 2,
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                  SwitchListTile(
                    title: const Text('Daily Habit'),
                    value: _isDaily,
                    onChanged: (value) => setState(() => _isDaily = value),
                  ),
                  if (!_isDaily)
                    TextFormField(
                      initialValue: _targetCount.toString(),
                      decoration: const InputDecoration(labelText: 'Target Count'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => _targetCount = int.tryParse(value) ?? 1,
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final habitService = ServiceProvider.of(context).habitService;
                  if (habit == null) {
                    habitService.addHabit(Habit(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: _nameController.text,
                      description: _descriptionController.text,
                      icon: _selectedIcon,
                      color: _selectedColor,
                      isDaily: _isDaily,
                      targetCount: _targetCount,
                      streak: 0,
                      xpReward: 10,
                      isCompleted: false,
                      lastCompleted: DateTime.now().subtract(const Duration(days: 1)),
                    ));
                  } else {
                    habitService.updateHabit(habit.copyWith(
                      name: _nameController.text,
                      description: _descriptionController.text,
                      icon: _selectedIcon,
                      color: _selectedColor,
                      isDaily: _isDaily,
                      targetCount: _targetCount,
                    ));
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(habit == null ? 'Add' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showIconPicker(void Function(void Function()) setState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Icon'),
        content: SingleChildScrollView(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Icons.fitness_center,
              Icons.book,
              Icons.self_improvement,
              Icons.water_drop,
              Icons.nightlight_round,
              Icons.wb_sunny,
              Icons.eco,
              Icons.music_note,
              Icons.computer,
              Icons.science,
            ].map((icon) => IconButton(
              icon: Icon(icon),
              color: _selectedColor,
              onPressed: () {
                setState(() => _selectedIcon = icon);
                Navigator.pop(context);
              },
            )).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final habitService = ServiceProvider.of(context).habitService;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Habits'),
      ),
      body: ListenableBuilder(
        listenable: habitService,
        builder: (context, _) => ListView.builder(
          itemCount: habitService.habits.length,
          itemBuilder: (context, index) {
            final habit = habitService.habits[index];
            return Dismissible(
              key: Key(habit.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                color: Colors.red,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) => habitService.deleteHabit(habit.id),
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: habit.color.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(habit.icon, color: habit.color),
                  ),
                  title: Text(habit.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(habit.description),
                      const SizedBox(height: 4),
                      Text(
                        'Streak: ${habit.streak} days',
                        style: TextStyle(
                          color: habit.streak > 0 ? Colors.green : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          habit.isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                          color: habit.isCompleted ? Colors.green : Colors.grey,
                        ),
                        onPressed: () => habitService.toggleHabitCompletion(habit.id),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showAddEditHabitDialog(habit),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditHabitDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
} 