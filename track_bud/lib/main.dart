import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/views/at_signup/onboarding.dart';
import 'firebase_options.dart';

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
    theme: ThemeData(scaffoldBackgroundColor: CustomColor.backgroundPrimary),
    home: OnboardingScreen(),
);
  }
}
