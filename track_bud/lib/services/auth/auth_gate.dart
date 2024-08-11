import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:track_bud/views/at_signup/login.dart';
import 'package:track_bud/views/nav_pages/overview_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user is logged in
          if (snapshot.hasData) {
            return const OverviewPage();
          }

          //user is not logged in
          else {
            return const SignInScreen();
          }
        },
      ),
    );
  }
}
