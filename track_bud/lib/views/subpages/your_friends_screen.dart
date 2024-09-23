import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/provider/user_provider.dart';
import 'package:track_bud/services/invite_services.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/friend/add_friend_bottom_sheet.dart';
import 'package:track_bud/utils/debts/friend/friend_card.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/searchfield.dart';
import 'package:share_plus/share_plus.dart';

class YourFriendsScreen extends StatefulWidget {
  const YourFriendsScreen({Key? key}) : super(key: key);

  @override
  State<YourFriendsScreen> createState() => _YourFriendsScreenState();
}

class _YourFriendsScreenState extends State<YourFriendsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final InviteService _inviteService = InviteService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).loadFriends();
    });
  }

  Future<void> _shareInviteLink() async {
    try {
      final userId = Provider.of<UserProvider>(context, listen: false).currentUser?.userId;
      if (userId != null) {
        String inviteLink = await _inviteService.createInviteLink(userId);
        Share.share('Füge mich zu deinen Freunden in TrackBud hinzu: $inviteLink');
      }
    } catch (e) {
      debugPrint("Fehler beim Teilen des Links: $e");
    }
  }

  void _searchFriend(String query) {
    // TODO: Implement search functionality
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTexts.yourFriends, style: TextStyles.regularStyleMedium),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (context) => AddFriendBottomSheet(onPressed: _shareInviteLink),
            ),
            icon: const Icon(Icons.add, color: CustomColor.bluePrimary, size: 30),
          )
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: CustomColor.bluePrimary));
          }

          List<UserModel> friends = userProvider.friends;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                top: CustomPadding.defaultSpace,
                left: CustomPadding.defaultSpace,
                right: CustomPadding.defaultSpace,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchTextfield(
                    hintText: AppTexts.search,
                    controller: _searchController,
                    onChanged: _searchFriend,
                  ),
                  const Gap(CustomPadding.defaultSpace),
                  if (friends.isEmpty)
                    const Center(child: Text("Keine Freunde gefunden."))
                  else
                    Column(
                      children: friends
                          .map((friend) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: CustomPadding.smallSpace),
                                child: FriendCard(friend: friend),
                              ))
                          .toList(),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
