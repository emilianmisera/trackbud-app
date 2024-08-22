import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:track_bud/trackbud.dart';
import 'package:track_bud/views/at_signup/onboarding_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<User?> _reloadUser(User user) async {
    try {
      // Versuche, den Benutzer neu zu laden
      await user.reload();
      return FirebaseAuth.instance.currentUser;
    } catch (e) {
      // Fehler beim Neuladen oder Benutzer wurde gelöscht
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // Fehlerbehandlung
            return Center(
                child: Text('Ein Fehler ist aufgetreten: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            // Ladeindikator anzeigen, während die Authentifizierung geprüft wird
            return Center(child: CircularProgressIndicator());
          }

          final User? user = snapshot.data;

          // Benutzer ist eingeloggt, aber möglicherweise gelöscht worden
          if (user != null) {
            return FutureBuilder<User?>(
              future: _reloadUser(user),
              builder: (context, reloadSnapshot) {
                if (reloadSnapshot.connectionState == ConnectionState.waiting) {
                  // Ladeindikator anzeigen, während die Benutzerinformation neu geladen wird
                  return Center(child: CircularProgressIndicator());
                }

                if (reloadSnapshot.hasError || reloadSnapshot.data == null) {
                  // Fehler oder Benutzer ist gelöscht, leite auf OnboardingScreen
                  return const OnboardingScreen();
                }

                // Benutzer ist aktiv und nicht gelöscht
                return TrackBud();
              },
            );
          }

          // Benutzer ist nicht eingeloggt
          return const OnboardingScreen();
        },
      ),
    );
  }
}
