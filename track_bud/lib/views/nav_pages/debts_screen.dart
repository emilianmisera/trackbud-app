import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/provider/group_provider.dart';
import 'package:track_bud/provider/user_provider.dart';
import 'package:track_bud/provider/friend_split_provider.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/friend/friend_card.dart';
import 'package:track_bud/utils/debts/group/group_card.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/tiles/information_tiles.dart';
import 'package:track_bud/views/subpages/your_friends_screen.dart';
import 'package:track_bud/views/subpages/your_groups_screen.dart';

class DebtsScreen extends StatefulWidget {
  const DebtsScreen({super.key});

  @override
  State<DebtsScreen> createState() => _DebtsScreenState();
}

class _DebtsScreenState extends State<DebtsScreen> {
  @override
  void initState() {
    super.initState();
    // Load data after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  // Function to load user, group, and friend debt data
  Future<void> _loadData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final groupProvider = Provider.of<GroupProvider>(context, listen: false);
    final friendSplitProvider = Provider.of<FriendSplitProvider>(context, listen: false);

    // Load current user and associated data
    await userProvider.loadCurrentUser();
    await groupProvider.loadGroups();
    await friendSplitProvider.loadFriendSplits(userProvider.currentUser!.userId, userProvider.friends);
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final userProvider = Provider.of<UserProvider>(context);
    final groupProvider = Provider.of<GroupProvider>(context);
    final friendSplitProvider = Provider.of<FriendSplitProvider>(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadData, // Refresh data on pull-down
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * CustomPadding.topSpace,
                left: CustomPadding.defaultSpace,
                right: CustomPadding.defaultSpace,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Row for displaying total debts and credits
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InfoTile(
                        title: AppTexts.debts,
                        amount: (friendSplitProvider.getTotalFriendDebts().abs() + groupProvider.getTotalDebts()).toStringAsFixed(2),
                        color: CustomColor.red,
                        width: MediaQuery.of(context).size.width / 2 - Constants.infoTileSpace,
                      ),
                      InfoTile(
                        title: AppTexts.credits,
                        amount: (friendSplitProvider.getTotalFriendCredits() + groupProvider.getTotalCredits()).toStringAsFixed(2),
                        color: CustomColor.green,
                        width: MediaQuery.of(context).size.width / 2 - Constants.infoTileSpace,
                      ),
                    ],
                  ),
                  const SizedBox(height: CustomPadding.defaultSpace),
                  // Row for friends section header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppTexts.friends,
                        style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate to friends screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const YourFriendsScreen()),
                          );
                        },
                        child: Text(
                          AppTexts.showAll,
                          style: TextStyles.regularStyleMedium.copyWith(color: CustomColor.bluePrimary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: CustomPadding.mediumSpace),
                  // Display a list of friends with their debts
                  if (friendSplitProvider.isLoading && userProvider.friends.isNotEmpty)
                    Column(
                      children: userProvider.friends
                          .take(5)
                          .map((friend) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: CustomPadding.smallSpace),
                                child: FriendCard(
                                  friend: friend,
                                  debtAmount: friendSplitProvider.getFriendBalance(friend.userId),
                                ),
                              ))
                          .toList(),
                    )
                  else if (friendSplitProvider.isLoading && userProvider.friends.isEmpty)
                    const Center(child: Text("Keine Freunde gefunden."))
                  else
                    Column(
                      children: userProvider.friends
                          .take(5)
                          .map((friend) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: CustomPadding.smallSpace),
                                child: FriendCard(
                                  friend: friend,
                                  debtAmount: friendSplitProvider.getFriendBalance(friend.userId),
                                ),
                              ))
                          .toList(),
                    ),
                  const SizedBox(height: CustomPadding.defaultSpace),
                  // Row for groups section header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppTexts.groups,
                        style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate to groups screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const YourGroupsScreen()),
                          );
                        },
                        child: Text(
                          AppTexts.showAll,
                          style: TextStyles.regularStyleMedium.copyWith(color: CustomColor.bluePrimary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: CustomPadding.mediumSpace),
                ]),
              ),
            ),
            // Consumer widget to listen to group provider changes
            Consumer<GroupProvider>(
              builder: (context, groupProvider, child) {
                // Conditional rendering based on loading state
                if (groupProvider.isLoading && groupProvider.groups.isNotEmpty) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final group = groupProvider.groups[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: CustomPadding.smallSpace, horizontal: CustomPadding.defaultSpace),
                          child: GroupCard(group: group),
                        );
                      },
                      childCount: groupProvider.groups.length,
                    ),
                  );
                } else if (groupProvider.isLoading && groupProvider.groups.isEmpty) {
                  return const SliverFillRemaining(child: Center(child: Text("Keine Gruppen gefunden.")));
                } else {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final group = groupProvider.groups[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: CustomPadding.smallSpace, horizontal: CustomPadding.defaultSpace),
                          child: GroupCard(group: group),
                        );
                      },
                      childCount: groupProvider.groups.length,
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
