import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:track_bud/utils/bottom_navigation_bar.dart';
import 'package:track_bud/views/nav_pages/analysis_screen.dart';
import 'package:track_bud/views/nav_pages/debts_screen.dart';
import 'package:track_bud/views/nav_pages/overview_screen.dart';
import 'package:track_bud/views/nav_pages/settings_screen.dart';

// TrackBud: Main widget for the app, managing navigation between screens
// ignore: must_be_immutable
class TrackBud extends StatefulWidget {
  // Current index of the selected navigation item
  int currentIndex;

  // Constructor with optional parameter for initial index
  TrackBud({super.key, this.currentIndex = 0});

  @override
  State<TrackBud> createState() => _TrackBudState();
}

class _TrackBudState extends State<TrackBud> {
 final user = FirebaseAuth.instance.currentUser;
  // List of all screens that can be displayed in the app
  final List<Widget> screens = [
    OverviewScreen(),
    DebtsScreen(),
    AnalysisScreen(),
    SettingsScreen()
  ];

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Custom bottom navigation bar
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: widget.currentIndex,
          // Update the current index when a navigation item is tapped
          onTap: (value) => setState(() {
            widget.currentIndex = value;
          }),
        ),
        // Display the screen corresponding to the current index
        body: screens[widget.currentIndex]);
  }
}
