import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/services/firestore_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/friends_widget.dart';
import 'package:track_bud/utils/group_widget.dart';
import 'package:track_bud/utils/information_tiles.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/views/subpages/your_friends_screen.dart';
import 'package:track_bud/views/subpages/your_groups_screen.dart';

class DebtsScreen extends StatefulWidget {
  const DebtsScreen({super.key});

  @override
  State<DebtsScreen> createState() => _DebtsScreenState();
}

class _DebtsScreenState extends State<DebtsScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<UserModel> _friends = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  String getCurrentUserId() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return currentUser.uid; // Die eindeutige userId des aktuellen Benutzers
    } else {
      throw Exception('Kein Benutzer ist angemeldet');
    }
  }

  Future<void> _loadFriends() async {
    String _currentUserId = getCurrentUserId();
    try {
      // Lade die Freunde des aktuellen Nutzers
      List<UserModel> friends = await _firestoreService.getFriends(_currentUserId);

      setState(() {
        _friends = friends;
        _isLoading = false;
      });
    } catch (e) {
      print('Fehler beim Laden der Freunde: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        // spacing between content and screen
        padding: EdgeInsets.only(
            top: MediaQuery.sizeOf(context).height * CustomPadding.topSpace,
            left: CustomPadding.defaultSpace,
            right: CustomPadding.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InfoTile(
                    title: AppTexts.debts,
                    amount: 'amount',
                    color: CustomColor.red,
                    width: MediaQuery.sizeOf(context).width / 2 - Constants.infoTileSpace),
                InfoTile(
                    title: AppTexts.credits,
                    amount: 'amount',
                    color: CustomColor.green,
                    width: MediaQuery.sizeOf(context).width / 2 - Constants.infoTileSpace),
              ],
            ),
            SizedBox(
              height: CustomPadding.defaultSpace,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppTexts.friends,
                  style: CustomTextStyle.regularStyleMedium,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => YourFriendsScreen(),
                      ),
                    );
                  },
                  child: Text(AppTexts.showAll, style: CustomTextStyle.regularStyleMedium.copyWith(color: CustomColor.bluePrimary)),
                ),
              ],
            ),
            SizedBox(
              height: CustomPadding.mediumSpace,
            ),
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else if (_friends.isEmpty)
              Center(child: Text("Keine Freunde gefunden."))
            else
              Column(
                children: _friends
                    .map((friend) => Column(
                          children: [
                            FriendCard(friend: friend),
                            SizedBox(height: CustomPadding.smallSpace), // Abstand zwischen den Karten
                          ],
                        ))
                    .toList(),
              ),
            SizedBox(
              height: CustomPadding.defaultSpace,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppTexts.groups,
                  style: CustomTextStyle.regularStyleMedium,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => YourGroupsScreen(),
                      ),
                    );
                  },
                  child: Text(AppTexts.showAll, style: CustomTextStyle.regularStyleMedium.copyWith(color: CustomColor.bluePrimary)),
                ),
              ],
            ),
            SizedBox(
              height: CustomPadding.mediumSpace,
            ),
            GroupCard()
          ],
        ),
      ),
    ));
  }
}
