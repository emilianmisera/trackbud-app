import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/friends_widget.dart';
import 'package:track_bud/utils/information_tiles.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/views/subpages/your_friends_screen.dart';

class DebtsScreen extends StatefulWidget {
  const DebtsScreen({super.key});

  @override
  State<DebtsScreen> createState() => _DebtsScreenState();
}

class _DebtsScreenState extends State<DebtsScreen> {
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
                    title: AppString.debts,
                    amount: 'amount',
                    color: CustomColor.red,
                    width: MediaQuery.sizeOf(context).width / 2 -
                        Constants.infoTileSpace),
                InfoTile(
                    title: AppString.credits,
                    amount: 'amount',
                    color: CustomColor.green,
                    width: MediaQuery.sizeOf(context).width / 2 -
                        Constants.infoTileSpace),
              ],
            ),
            SizedBox(
              height: CustomPadding.defaultSpace,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppString.friends,
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
                  child: Text(AppString.showAll,
                      style: CustomTextStyle.regularStyleMedium
                          .copyWith(color: CustomColor.bluePrimary)),
                ),
              ],
            ),
            SizedBox(
              height: CustomPadding.mediumSpace,
            ),
            FriendCard()
          ],
        ),
      ),
    ));
  }
}
