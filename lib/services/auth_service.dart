import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  Future<bool> login(String admissionNumber, String email) async {
    _isLoading = true;
    notifyListeners();

    // Mock authentication delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock validation
    if (admissionNumber.isNotEmpty && email.isNotEmpty) {
      _currentUser = User(
        admissionNumber: admissionNumber,
        email: email,
        name: 'Student ${admissionNumber.substring(0, 3)}',
      );
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }
} 