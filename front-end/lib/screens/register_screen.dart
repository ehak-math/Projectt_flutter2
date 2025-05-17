import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracking/providers/auth_provider.dart';
import 'package:time_tracking/screens/manager/race_screen.dart';
import 'login_screen.dart';
import 'tracker/race_tracker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _selectedRole = 'race_manager';
  bool _loading = false;
  String? _error;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
        role: _selectedRole,
      );

      // Navigate based on role
      if (_selectedRole == 'race_manager') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const RaceScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const RaceTracker()),
        );
      }
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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color:  Color.fromARGB(255, 88, 86, 214), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color:  Color.fromARGB(255, 88, 86, 214), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color:  Color.fromARGB(255, 88, 86, 214), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: const Color.fromARGB(255, 88, 86, 214),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // dismiss keyboard
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration('Name'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter your name' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: _inputDecoration('Email'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter your email' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: _inputDecoration('Password'),
                    validator: (value) => value != null && value.length < 6
                        ? 'Password must be at least 6 characters'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: _inputDecoration('Confirm Password'),
                    validator: (value) => value != _passwordController.text
                        ? 'Passwords do not match'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: _inputDecoration('Role'),
                    items: const [
                      DropdownMenuItem(
                        value: 'race_manager',
                        child: Text('Race Manager'),
                      ),
                      DropdownMenuItem(
                        value: 'time_tracker',
                        child: Text('Time Tracker'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  _loading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 88, 86, 214),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Register',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      "Already have an account? Login here",
                      style: TextStyle(color:  Color.fromARGB(255, 88, 86, 214)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
