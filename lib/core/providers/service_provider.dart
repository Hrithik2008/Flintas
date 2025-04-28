import 'package:flutter/material.dart';
import '../services/habit_service.dart';
import '../services/ripple_service.dart';
import '../services/connection_service.dart';
import '../../services/profile_service.dart';

class ServiceProvider extends InheritedWidget {
  final HabitService habitService;
  final RippleService rippleService;
  final ConnectionService connectionService;
  final ProfileService profileService;

  const ServiceProvider({
    Key? key,
    required Widget child,
    required this.habitService,
    required this.rippleService,
    required this.connectionService,
    required this.profileService,
  }) : super(key: key, child: child);

  static ServiceProvider of(BuildContext context) {
    final ServiceProvider? result = context.dependOnInheritedWidgetOfExactType<ServiceProvider>();
    assert(result != null, 'No ServiceProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ServiceProvider oldWidget) {
    return habitService != oldWidget.habitService ||
        rippleService != oldWidget.rippleService ||
        connectionService != oldWidget.connectionService ||
        profileService != oldWidget.profileService;
  }
} 