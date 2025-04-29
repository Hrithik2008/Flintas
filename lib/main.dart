import 'package:flutter/material.dart';
import 'core/providers/service_provider.dart';
import 'core/services/habit_service.dart';
import 'core/services/ripple_service.dart';
import 'core/services/connection_service.dart';
import 'services/profile_service.dart';
import 'features/auth/login_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/connections/connection_screen.dart';
import 'features/ripple/ripple_screen.dart';
import 'features/habits/habits_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ServiceProvider(
      habitService: HabitService(),
      rippleService: RippleService(),
      connectionService: ConnectionService(),
      profileService: ProfileService(),
      child: MaterialApp(
        title: 'Ripple App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/connections': (context) => const ConnectionScreen(),
          '/ripple': (context) => const RippleScreen(),
          '/habits': (context) => const HabitsScreen(),
        },
      ),
    );
  }
}
