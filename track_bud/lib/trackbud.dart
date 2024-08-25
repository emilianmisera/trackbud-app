import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:track_bud/services/firestore_service.dart';
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
  final FirestoreService _firestoreService =
      FirestoreService(); // FirestoreService Instanz

  // List of all screens that can be displayed in the app
  final List<Widget> screens = [
    OverviewScreen(),
    DebtsScreen(),
    AnalysisScreen(),
    SettingsScreen()
  ];

  @override
  void initState() {
    super.initState();
    _retrieveDynamicLink();
  }

  Future<void> _retrieveDynamicLink() async {
    FirebaseDynamicLinks.instance.onLink
        .listen((PendingDynamicLinkData dynamicLinkData) {
      final Uri deepLink = dynamicLinkData.link;

      if (deepLink != null) {
        _handleDynamicLink(deepLink);
      }
    }).onError((error) {
      print('Fehler beim Empfangen des dynamischen Links: $error');
    });
  }

  String getCurrentUserId() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return currentUser.uid; // Die eindeutige userId des aktuellen Benutzers
    } else {
      throw Exception('Kein Benutzer ist angemeldet');
    }
  }

  void _handleDynamicLink(Uri deepLink) {
    final String? invitedUserId = deepLink.queryParameters['userId'];

    if (invitedUserId != null) {
      String currentUserId = getCurrentUserId();
      _addFriend(currentUserId, invitedUserId);
    }
  }

  Future<void> _addFriend(String currentUserId, String invitedUserId) async {
    try {
      await _firestoreService.addFriend(currentUserId, invitedUserId);
    } catch (e) {
      print('Fehler beim Hinzufügen des Freundes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Hinzufügen des Freundes.')),
      );
    }
  }

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
