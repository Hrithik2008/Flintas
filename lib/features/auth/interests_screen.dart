import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class Interest {
  final String name;
  final IconData icon;
  final Color color;

  const Interest({
    required this.name,
    required this.icon,
    required this.color,
  });
}

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  final List<Interest> interests = [
    const Interest(
      name: 'Science',
      icon: Icons.science_rounded,
      color: Color(0xFFB5EAD7),
    ),
    const Interest(
      name: 'Music',
      icon: Icons.music_note_rounded,
      color: Color(0xFFFFDAC1),
    ),
    const Interest(
      name: 'Environment',
      icon: Icons.eco_rounded,
      color: Color(0xFFA8E6CF),
    ),
    const Interest(
      name: 'Tech',
      icon: Icons.computer_rounded,
      color: Color(0xFFC7CEEA),
    ),
    const Interest(
      name: 'Art',
      icon: Icons.palette_rounded,
      color: Color(0xFFFFB7B2),
    ),
    const Interest(
      name: 'Sports',
      icon: Icons.sports_soccer_rounded,
      color: Color(0xFFE2F0CB),
    ),
    const Interest(
      name: 'Reading',
      icon: Icons.menu_book_rounded,
      color: Color(0xFFB5EAD7),
    ),
    const Interest(
      name: 'Writing',
      icon: Icons.edit_note_rounded,
      color: Color(0xFFFFDAC1),
    ),
  ];

  final Set<String> selectedInterests = {};

  void _toggleInterest(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        selectedInterests.add(interest);
      }
    });
  }

  void _continue() {
    if (selectedInterests.length >= 2) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least 2 interests'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'What interests you?',
                style: Theme.of(context).textTheme.displayMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Select at least 2 interests to get started',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: interests.length,
                  itemBuilder: (context, index) {
                    final interest = interests[index];
                    final isSelected = selectedInterests.contains(interest.name);
                    
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected ? interest.color : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? interest.color : Colors.grey.shade200,
                          width: 2,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () => _toggleInterest(interest.name),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  interest.icon,
                                  size: 32,
                                  color: isSelected ? Colors.white : interest.color,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  interest.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _continue,
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Continue',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 