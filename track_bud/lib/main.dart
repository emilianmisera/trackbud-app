import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:track_bud/services/auth/auth_gate.dart';
import 'package:track_bud/utils/color_theme.dart';
import 'package:track_bud/utils/constants.dart';
import 'services/firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: CustomColor.backgroundPrimary, // StatusBar (android)
    statusBarIconBrightness: Brightness
        .dark, //shows dark icons in status bar (Allways) -> change for dark mode (android)
    systemNavigationBarColor: CustomColor
        .backgroundPrimary, //shows same color as background in the NavigationBar (android)
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
      home: AuthGate(),
    );
  }
}
