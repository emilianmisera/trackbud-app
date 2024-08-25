import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/services/firestore_service.dart';
import 'package:track_bud/services/invite_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/friends_widget.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';
import 'package:share/share.dart';

class YourFriendsScreen extends StatefulWidget {
  const YourFriendsScreen({super.key});

  @override
  State<YourFriendsScreen> createState() => _YourFriendsScreenState();
}

class _YourFriendsScreenState extends State<YourFriendsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _emailFriendController = TextEditingController();
  final InviteService _inviteService = InviteService();
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
      List<UserModel> friends =
          await _firestoreService.getFriends(_currentUserId);

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

  Future<void> _shareInviteLink() async {
    try {
      final userId = getCurrentUserId();
      String inviteLink = await _inviteService.createInviteLink(userId);
      Share.share(
          'Füge mich zu deinen Freunden in TrackBud hinzu: $inviteLink');
    } catch (e) {
      print("Fehler beim Teilen des Links: $e");
    }
  }

  void _searchFriend(String query) {
    //TODO: add search-function
    // https://youtu.be/ZHdg2kfKmjI?si=ufWetKZ8HdE6OyjQ&t=49
  }

  Future _displayBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              height: MediaQuery.sizeOf(context).height *
                  Constants.modalBottomSheetHeight,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                color: CustomColor.backgroundPrimary,
                borderRadius:
                    BorderRadius.circular(Constants.buttonBorderRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: CustomPadding.defaultSpace,
                    right: CustomPadding.defaultSpace,
                    bottom: 50),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: CustomPadding.mediumSpace),
                    Center(
                      child: Container(
                        // grabber
                        width: 36,
                        height: 5,
                        decoration: BoxDecoration(
                          color: CustomColor.grabberColor,
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                      ),
                    ),
                    SizedBox(height: CustomPadding.defaultSpace),
                    Text(
                      AppString.addFriend,
                      style: CustomTextStyle.regularStyleMedium,
                    ),
                    SizedBox(height: CustomPadding.mediumSpace),
                    CustomTextfield(
                        name: AppString.email,
                        hintText: AppString.hintEmail,
                        controller: _emailFriendController),
                    Spacer(),
                    ElevatedButton(
                        onPressed: () {
                          _shareInviteLink();
                        },
                        child: Text(AppString.addFriend)),
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppString.yourFriends,
          style: CustomTextStyle.regularStyleMedium,
        ),
        actions: [
          IconButton(
              onPressed: () {
                _displayBottomSheet(context);
              },
              icon: Icon(
                Icons.add,
                color: CustomColor.bluePrimary,
                size: 30,
              ))
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                // spacing between content and screen
                padding: EdgeInsets.only(
                    top: CustomPadding.defaultSpace,
                    left: CustomPadding.defaultSpace,
                    right: CustomPadding.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //SearchField
                    SearchTextfield(
                      hintText: AppString.search,
                      controller: _searchController,
                      onChanged: _searchFriend,
                    ),
                    SizedBox(
                      height: CustomPadding.defaultSpace,
                    ),
                    // List of Friends
                    if (_friends.isEmpty)
                      Center(child: Text("Keine Freunde gefunden."))
                    else
                      Column(
                        children: _friends
                            .map((friend) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: CustomPadding.smallSpace),
                                  child: FriendCard(friend: friend),
                                ))
                            .toList(),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
