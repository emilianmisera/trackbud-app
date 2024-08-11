import 'package:flutter/material.dart';
import 'package:track_bud/services/auth/auth_service.dart';
import 'package:track_bud/views/at_signup/login_screen.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewScreen> {
  final AuthService _authService = AuthService();

  // temporary solution to test signup and login
  Future<void> _signOut() async {
    try {
      await _authService.signOut();

      // Open LoginScreen on Signout
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      // Show error if Signout fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Abmelden: ${e.toString()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Übersicht'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _signOut,
          child: const Text('Ausloggen'),
        ),
      ),
    );
  }
}
