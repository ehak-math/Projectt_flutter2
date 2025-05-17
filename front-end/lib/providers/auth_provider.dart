import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_tracking/core/services/api_service.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _role; // 👈 Add this
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  String? get role => _role; // 👈 Add getter

  Future<void> login(String email, String password) async {
    final response = await ApiService.post('/login', {
      'email': email,
      'password': password,
    });

    if (response['token'] != null && response['user'] != null) {
      _token = response['token'];
      _role = response['user']['role']; // 👈 Save role from response

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      await prefs.setString('role', _role!); // 👈 Persist role

      _isAuthenticated = true;
      notifyListeners();
    } else {
      throw Exception(response['message'] ?? 'Login failed');
    }
  }

  Future<void> logout() async {
    _token = null;
    _role = null; // 👈 Clear role
    _isAuthenticated = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role'); // 👈 Remove role
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token') || !prefs.containsKey('role')) return;

    _token = prefs.getString('token');
    _role = prefs.getString('role'); // 👈 Restore role
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
  }) async {
    final response = await ApiService.post('/register', {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'role': role,
    });

    print('🔄 Response: $response');

    if (response['token'] != null && response['user'] != null) {
      _token = response['token'];
      _role = response['user']['role'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      await prefs.setString('role', _role!);

      _isAuthenticated = true;
      notifyListeners();
    } else {
      // Debug what caused this
      print('❌ Invalid registration response format');
      throw Exception(response['message'] ?? 'Registration failed');
    }
  }
}
