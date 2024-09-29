import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/provider/friend_split_provider.dart';
import 'package:track_bud/provider/user_provider.dart';
import 'package:track_bud/services/invite_services.dart';
import 'package:track_bud/utils/constants.dart';
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

  @override
  void initState() {
    super.initState();
    // Load friends after the initial frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).loadFriends();
    });
  }

  // Function to share an invite link with friends
  Future<void> _shareInviteLink() async {
    try {
      final userId = Provider.of<UserProvider>(context, listen: false).currentUser?.userId;
      if (userId != null) {
        // Create and share the invite link
        String inviteLink = await _inviteService.createInviteLink(userId);
        Share.share('Add me to your friends in TrackBud: $inviteLink');
      }
    } catch (e) {
      // Log any error that occurs while sharing the invite link
      debugPrint("Error sharing invite link: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final friendSplitProvider = Provider.of<FriendSplitProvider>(context);
    final defaultColorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppTexts.yourFriends, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
        centerTitle: true,
        actions: [
          // Icon button to share the invite link
          IconButton(
            onPressed: _shareInviteLink,
            icon: const Icon(Icons.person_add_alt_outlined, color: CustomColor.bluePrimary, size: 30),
          )
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          // Display loading indicator while user data is being fetched
          if (userProvider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: CustomColor.bluePrimary));
          }

          // Filter friends based on search input
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
                  // Search text field for filtering friends
                  SearchTextfield(
                    hintText: AppTexts.search,
                    controller: _searchController,
                    onChanged: (_) => setState(() {}), // Update search results on text change
                  ),
                  const Gap(CustomPadding.defaultSpace),
                  // Display message if no friends are found
                  if (filteredFriends.isEmpty)
                    Center(child: Text("Keine Freunde gefunden.", style: TextStyle(color: defaultColorScheme.primary)))
                  else
                    // Display list of filtered friends
                    Column(
                      children: filteredFriends
                          .map((friend) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: CustomPadding.smallSpace),
                                child: FriendCard(friend: friend, debtAmount: friendSplitProvider.getFriendBalance(friend.userId)),
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
