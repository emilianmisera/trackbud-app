import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
  const DebtsScreen({super.key});

  @override
  State<DebtsScreen> createState() => _DebtsScreenState();
}

class _DebtsScreenState extends State<DebtsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
      _loadGroups();
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

  Future<void> _loadUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadCurrentUser();
  }

  Future<void> _loadGroups() async {
    final groupProvider = Provider.of<GroupProvider>(context, listen: false);
    await groupProvider
        .loadGroups(); // Assume this method exists to load groups
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
                      width: MediaQuery.sizeOf(context).width / 2 -
                          Constants.infoTileSpace),
                  InfoTile(
                      title: AppTexts.credits,
                      amount: 'amount',
                      color: CustomColor.green,
                      width: MediaQuery.sizeOf(context).width / 2 -
                          Constants.infoTileSpace),
                ],
              ),
              const Gap(
                CustomPadding.defaultSpace,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppTexts.friends,
                    style: TextStyles.regularStyleMedium,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const YourFriendsScreen(),
                        ),
                      );
                    },
                    child: Text(AppTexts.showAll,
                        style: TextStyles.regularStyleMedium
                            .copyWith(color: CustomColor.bluePrimary)),
                  ),
                ],
              ),
              const Gap(
                CustomPadding.mediumSpace,
              ),
              // Use Consumer to access friends from UserProvider
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  if (userProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (userProvider.friends.isEmpty) {
                    return const Center(child: Text("Keine Freunde gefunden."));
                  } else {
                    return Column(
                      children: userProvider.friends
                          .take(5) // Limit to 5 friends
                          .map((friend) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: CustomPadding.smallSpace),
                                child: FriendCard(friend: friend),
                              ))
                          .toList(),
                    );
                  }
                },
              ),
              const Gap(
                CustomPadding.defaultSpace,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppTexts.groups,
                    style: TextStyles.regularStyleMedium,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const YourGroupsScreen(),
                        ),
                      );
                    },
                    child: Text(
                      AppTexts.showAll,
                      style: TextStyles.regularStyleMedium
                          .copyWith(color: CustomColor.bluePrimary),
                    ),
                  ),
                ],
              ),
              const Gap(CustomPadding.mediumSpace),
              Consumer<GroupProvider>(
                builder: (context, groupProvider, child) {
                  if (groupProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (groupProvider.groups.isEmpty) {
                    return const Center(child: Text("Keine Gruppen gefunden."));
                  } else {
                    return Column(
                      children: groupProvider.groups
                          .take(3) //limits to 3
                          .map((group) => Column(
                                children: [
                                  GroupCard(group: group),
                                  const Gap(CustomPadding.smallSpace),
                                ],
                              ))
                          .toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
