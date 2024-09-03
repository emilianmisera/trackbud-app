import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/services/invite_services.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/friend/add_friend_bottom_sheet.dart';
import 'package:track_bud/utils/debts/friend/friend_card.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:share/share.dart';
import 'package:track_bud/utils/textfields/searchfield.dart';
import 'package:track_bud/views/at_signup/firestore_service.dart';

class YourFriendsScreen extends StatefulWidget {
  const YourFriendsScreen({super.key});

  @override
  State<YourFriendsScreen> createState() => _YourFriendsScreenState();
}

class _YourFriendsScreenState extends State<YourFriendsScreen> {
  final TextEditingController _searchController = TextEditingController();
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
    String currentUserId = getCurrentUserId();
    try {
      // Lade die Freunde des aktuellen Nutzers
      List<UserModel> friends = await _firestoreService.getFriends(currentUserId);

      setState(() {
        _friends = friends;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Fehler beim Laden der Freunde: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _shareInviteLink() async {
    try {
      final userId = getCurrentUserId();
      String inviteLink = await _inviteService.createInviteLink(userId);
      Share.share('Füge mich zu deinen Freunden in TrackBud hinzu: $inviteLink');
    } catch (e) {
      debugPrint("Fehler beim Teilen des Links: $e");
    }
  }

  void _searchFriend(String query) {
    //TODO: add search-function
    // https://youtu.be/ZHdg2kfKmjI?si=ufWetKZ8HdE6OyjQ&t=49
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTexts.yourFriends, style: TextStyles.regularStyleMedium),
        actions: [
          IconButton(
              onPressed: () =>
                  showModalBottomSheet(context: context, builder: (context) => AddFriendBottomSheet(onPressed: () => _shareInviteLink())),
              icon: const Icon(
                Icons.add,
                color: CustomColor.bluePrimary,
                size: 30,
              ))
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                // spacing between content and screen
                padding: const EdgeInsets.only(
                    top: CustomPadding.defaultSpace, left: CustomPadding.defaultSpace, right: CustomPadding.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //SearchField
                    SearchTextfield(
                      hintText: AppTexts.search,
                      controller: _searchController,
                      onChanged: _searchFriend,
                    ),
                    const Gap(CustomPadding.defaultSpace),
                    // List of Friends
                    if (_friends.isEmpty)
                      const Center(child: Text("Keine Freunde gefunden."))
                    else
                      Column(
                        children: _friends
                            .map((friend) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: CustomPadding.smallSpace),
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
