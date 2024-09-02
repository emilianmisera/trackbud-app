import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:track_bud/firebase_options.dart';
import 'package:track_bud/services/auth/authgate.dart';
import 'package:track_bud/trackbud.dart';
import 'package:track_bud/utils/color_theme.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:track_bud/views/at_signup/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true); // Offline-Persistence deaktivieren

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: CustomColor.backgroundPrimary, // StatusBar (android)
    statusBarIconBrightness: Brightness.dark, //shows dark icons in status bar (Allways) -> change for dark mode (android)
    systemNavigationBarColor: CustomColor.backgroundPrimary, //shows same color as background in the NavigationBar (android)
  ));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Portrait mode only (android)
  ]);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrackBud',
      theme: ColorTheme.lightTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Show Login screen if we aren't logged in, otherwise go to main app.
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) => snapshot.hasData ? TrackBud() : const OnboardingScreen(),
      ),
    );
  }
}
