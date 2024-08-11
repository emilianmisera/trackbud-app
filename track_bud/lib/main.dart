import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:track_bud/utils/color_theme.dart';
import 'package:track_bud/views/at_signup/forgot_password_screen.dart';
import 'package:track_bud/views/at_signup/login.dart';
import 'package:track_bud/views/at_signup/onboarding.dart';
import 'services/firebase_options.dart';
import 'views/at_signup/signup.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    title: 'TrackBud',
    theme: ThemeClass.lightTheme,
    home: OnboardingScreen(),
);

  }
}
