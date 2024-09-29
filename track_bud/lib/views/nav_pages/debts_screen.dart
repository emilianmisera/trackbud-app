import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/provider/group_provider.dart';
import 'package:track_bud/provider/user_provider.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/friend/friend_card.dart';
import 'package:track_bud/utils/debts/group/group_card.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/tiles/information_tiles.dart';
import 'package:track_bud/views/subpages/your_friends_screen.dart';
import 'package:track_bud/views/subpages/your_groups_screen.dart';

class DebtsScreen extends StatefulWidget {
  const DebtsScreen({super.key}); // Constructor

  @override
  State<DebtsScreen> createState() => _DebtsScreenState(); // Create state for the widget
}

class _DebtsScreenState extends State<DebtsScreen> {
  @override
  void initState() {
    super.initState();
    // Load user data and groups after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
      _loadGroups();
    });
  }

  // Load the current user's data
  Future<void> _loadUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadCurrentUser(); // Fetch current user information
  }

  // Load groups associated with the user
  Future<void> _loadGroups() async {
    final groupProvider = Provider.of<GroupProvider>(context, listen: false);
    await groupProvider.loadGroups(); // Fetch user's groups
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme; // Get color scheme from the theme
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // Allow user to refresh data by pulling down
          await _loadUserData();
          await _loadGroups();
        },
        child: CustomScrollView(
          slivers: [
            // Top padding for the scroll view
            SliverPadding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + CustomPadding.defaultSpace, // Padding from the top
                left: CustomPadding.defaultSpace, // Left padding
                right: CustomPadding.defaultSpace, // Right padding
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Display debts and credits information tiles
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InfoTile(
                        title: AppTexts.debts,
                        amount: 'amount', // Placeholder for amount
                        color: CustomColor.red, // Color for debts tile
                        width: MediaQuery.of(context).size.width / 2 - Constants.infoTileSpace, // Dynamic width calculation
                      ),
                      InfoTile(
                        title: AppTexts.credits,
                        amount: 'amount', // Placeholder for amount
                        color: CustomColor.green, // Color for credits tile
                        width: MediaQuery.of(context).size.width / 2 - Constants.infoTileSpace, // Dynamic width calculation
                      ),
                    ],
                  ),
                  const SizedBox(height: CustomPadding.defaultSpace), // Space between elements
                  // Friends section header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppTexts.friends,
                        style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary), // Style for friends text
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate to YourFriendsScreen when tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const YourFriendsScreen()),
                          );
                        },
                        child: Text(
                          AppTexts.showAll,
                          style: TextStyles.regularStyleMedium.copyWith(color: CustomColor.bluePrimary), // Style for show all text
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: CustomPadding.mediumSpace), // Space between elements
                  // List of friends
                  Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      if (userProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator(color: CustomColor.bluePrimary)); // Loading indicator
                      } else if (userProvider.friends.isEmpty) {
                        return Center(
                            child: Text("Keine Freunde gefunden.",
                                style: TextStyle(color: defaultColorScheme.primary))); // No friends found message
                      } else {
                        return Column(
                          children: userProvider.friends
                              .take(5) // Limit to first 5 friends
                              .map((friend) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: CustomPadding.smallSpace),
                                    child: FriendCard(friend: friend), // Display friend card
                                  ))
                              .toList(),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: CustomPadding.defaultSpace), // Space between elements
                  // Groups section header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppTexts.groups,
                        style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary), // Style for groups text
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate to YourGroupsScreen when tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const YourGroupsScreen()),
                          );
                        },
                        child: Text(
                          AppTexts.showAll,
                          style: TextStyles.regularStyleMedium.copyWith(color: CustomColor.bluePrimary), // Style for show all text
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: CustomPadding.mediumSpace), // Space between elements
                ]),
              ),
            ),
            // List of groups
            Consumer<GroupProvider>(
              builder: (context, groupProvider, child) {
                if (groupProvider.isLoading) {
                  return const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator(color: CustomColor.bluePrimary)) // Loading indicator for groups
                      );
                } else if (groupProvider.groups.isEmpty) {
                  return SliverFillRemaining(
                      child: Center(
                          child: Text("Keine Gruppen gefunden.",
                              style: TextStyle(color: defaultColorScheme.primary))) // No groups found message
                      );
                } else {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final group = groupProvider.groups[index]; // Get group by index
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: CustomPadding.smallSpace, horizontal: CustomPadding.defaultSpace),
                          child: GroupCard(group: group), // Display group card
                        );
                      },
                      childCount: groupProvider.groups.length, // Total number of groups
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
