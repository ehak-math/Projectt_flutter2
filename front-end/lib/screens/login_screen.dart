import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracking/providers/auth_provider.dart';
import 'package:time_tracking/screens/manager/race_screen.dart';
import 'tracker/race_tracker.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _checking = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initAuth();
  }

  Future<void> _initAuth() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.tryAutoLogin();
    if (authProvider.isAuthenticated) {
      _navigateToRoleBasedScreen(authProvider.role);
    } else {
      setState(() {
        _checking = false;
      });
    }
  }

  void _submit() async {
    FocusScope.of(context).unfocus(); // Dismiss keyboard
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      _navigateToRoleBasedScreen(authProvider.role);
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _navigateToRoleBasedScreen(String? role) {
    Widget targetScreen;

    if (role == 'race_manager') {
      targetScreen = RaceScreen();
    } else if (role == 'time_tracker') {
      targetScreen = RaceTracker();
    } else {
      setState(() {
        _error = 'Unknown user role';
      });
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => targetScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Triathlon Login')),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (_error != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            _error!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter your email'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(labelText: 'Password'),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter your password'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      _loading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _submit,
                              child: const Text('Login'),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
