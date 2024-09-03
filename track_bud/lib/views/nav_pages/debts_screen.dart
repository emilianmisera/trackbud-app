import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/friend/friend_card.dart';
import 'package:track_bud/utils/debts/group/group_card.dart';
import 'package:track_bud/utils/tiles/information_tiles.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/views/subpages/your_friends_screen.dart';
import 'package:track_bud/views/subpages/your_groups_screen.dart';

class DebtsScreen extends StatefulWidget {
  const DebtsScreen({super.key});

  @override
  State<DebtsScreen> createState() => _DebtsScreenState();
}

class _DebtsScreenState extends State<DebtsScreen> {
  // ignore: prefer_final_fields
  List<UserModel> _friends = [];
  // ignore: prefer_final_fields
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            const Gap(CustomPadding.defaultSpace),
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
                  child: Text(AppTexts.showAll, style: TextStyles.regularStyleMedium.copyWith(color: CustomColor.bluePrimary)),
                ),
              ],
            ),
            const Gap(CustomPadding.mediumSpace),
            //TODO: Use FutureBuilder instead of isLoading check
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_friends.isEmpty)
              const Center(child: Text("Keine Freunde gefunden."))
            else
              Column(
                children: _friends
                    .map((friend) => Column(
                          children: [
                            FriendCard(friend: friend),
                            const Gap(CustomPadding.smallSpace), // Abstand zwischen den Karten
                          ],
                        ))
                    .toList(),
              ),
            const Gap(CustomPadding.defaultSpace),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppTexts.groups, style: TextStyles.regularStyleMedium),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const YourGroupsScreen(),
                      ),
                    );
                  },
                  child: Text(AppTexts.showAll, style: TextStyles.regularStyleMedium.copyWith(color: CustomColor.bluePrimary)),
                ),
              ],
            ),
            const Gap(CustomPadding.mediumSpace),
            const GroupCard()
          ],
        ),
      ),
    );
  }
}
