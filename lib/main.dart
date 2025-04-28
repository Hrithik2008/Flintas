import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'services/database_service.dart';
import 'models/user.dart';
import 'features/habits/habits_screen.dart';
import 'features/world/world_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/teams/teams_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final databaseService = DatabaseService();
  await databaseService.database; // Initialize database
  runApp(MyApp(databaseService: databaseService));
}

class MyApp extends StatelessWidget {
  final DatabaseService databaseService;

  const MyApp({Key? key, required this.databaseService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DatabaseService>.value(value: databaseService),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Habit World',
        theme: AppTheme.theme,
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HabitsScreen(),
    const WorldScreen(),
    const TeamsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Habits',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.landscape),
            label: 'World',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Teams',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void updateUser(User user) {
    _user = user;
    notifyListeners();
  }
}
