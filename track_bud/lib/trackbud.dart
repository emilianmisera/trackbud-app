import 'package:flutter/material.dart';
import 'package:track_bud/utils/bottom_navigation_bar.dart';
import 'package:track_bud/views/nav_pages/analysis_screen.dart';
import 'package:track_bud/views/nav_pages/debts_screen.dart';
import 'package:track_bud/views/nav_pages/overview_screen.dart';
import 'package:track_bud/views/nav_pages/settings_screen.dart';

// TrackBud: Main widget for the app, managing navigation between screens
// ignore: must_be_immutable
class TrackBud extends StatelessWidget {
 
  // Constructor with optional parameter for initial index
  TrackBud({super.key});

  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Custom bottom navigation bar
      bottomNavigationBar: CustomBottomNavigationBar(
        // Update the current index when a navigation item is tapped
        onTap: (value) => _pageController.jumpToPage(value),
      ),
      // Display the screen corresponding to the current index
      body: PageView(
        controller: _pageController,
        children: [
          OverviewScreen(),
          DebtsScreen(),
          AnalysisScreen(),
          SettingsScreen(),
        ],
      ),
    );
  }
}
