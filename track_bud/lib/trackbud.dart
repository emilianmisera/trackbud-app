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
  // Constructor with optional parameter for initial index
  TrackBud({super.key});

  @override
  State<TrackBud> createState() => _TrackBudState();
}

class _TrackBudState extends State<TrackBud> {
  final PageController _pageController = PageController();
  final FirestoreService _firestoreService = FirestoreService();
  // Current index to keep track of the selected page
  int _currentIndex = 0;


  @override
  void initState() {
    super.initState();
    _retrieveDynamicLink();
  }

  Future<void> _retrieveDynamicLink() async {
    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData dynamicLinkData) {
      final Uri deepLink = dynamicLinkData.link;

      _handleDynamicLink(deepLink);
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
      if (currentUserId != invitedUserId) {
        _addFriend(currentUserId, invitedUserId);
        debugPrint('You can not add yourself as a friend, i\'m sorry.');
      }
    }
  }

  Future<void> _addFriend(String currentUserId, String invitedUserId) async {
    try {
      await _firestoreService.addFriend(currentUserId, invitedUserId);
    } catch (e) {
      debugPrint('Fehler beim Hinzufügen des Freundes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Custom bottom navigation bar
      bottomNavigationBar: CustomBottomNavigationBar(
        onTap: (index) => _pageController.jumpToPage(index),
        currentIndex: _currentIndex, // Pass the current index
      ),
      // Display the screen corresponding to the current index
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          // Update current index when page changes
          setState(() => _currentIndex = index);
        },
        children: const [
          OverviewScreen(),
          DebtsScreen(),
          AnalysisScreen(),
          SettingsScreen(),
        ],
      ),
    );
  }
}
