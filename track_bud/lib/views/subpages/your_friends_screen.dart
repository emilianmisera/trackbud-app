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
  const YourFriendsScreen({super.key});

  @override
  State<YourFriendsScreen> createState() => _YourFriendsScreenState();
}

class _YourFriendsScreenState extends State<YourFriendsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final InviteService _inviteService = InviteService();
// List to store filtered friends based on search

  @override
  void initState() {
    super.initState();
    // Load friends when the widget is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).loadFriends();
    });
  }

  // Function to share invite link
  Future<void> _shareInviteLink() async {
    try {
      final userId = Provider.of<UserProvider>(context, listen: false).currentUser?.userId;
      if (userId != null) {
        String inviteLink = await _inviteService.createInviteLink(userId);
        Share.share('Add me to your friends in TrackBud: $inviteLink');
      }
    } catch (e) {
      debugPrint("Error sharing invite link: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTexts.yourFriends, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
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

          // Filter friends based on search text
          List<UserModel> filteredFriends = userProvider.friends.where((friend) {
            final searchTerm = _searchController.text.toLowerCase();
            return friend.name.toLowerCase().contains(searchTerm) || friend.email.toLowerCase().contains(searchTerm);
          }).toList();

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
                    onChanged: (_) => setState(() {}), // Trigger rebuild on search
                  ),
                  const Gap(CustomPadding.defaultSpace),
                  if (filteredFriends.isEmpty)
                    Center(child: Text("Keine Freunde gefunden.", style: TextStyle(color: defaultColorScheme.primary)))
                  else
                    Column(
                      children: filteredFriends
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
