import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/balance_state.dart';
import 'package:track_bud/utils/enum/debts_box.dart';
import 'package:track_bud/utils/textfield_widgets.dart';
import 'package:track_bud/views/subpages/group_overview_screeen.dart';
/// This Widget dispalys a single Group in DebtsScreen or YourGroupScreen
class GroupCard extends StatelessWidget {
  const GroupCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupOverviewScreen(
              groupName: '**group**',
            ), // '**FriendName**'
          ),
        );
      },
      child: CustomShadow(
          child: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: EdgeInsets.all(CustomPadding.defaultSpace),
        decoration: BoxDecoration(color: CustomColor.white, borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              // Friend's profile picture
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: Container(
                  width: 40,
                  height: 40,
                  color: Colors.red, // Placeholder color, replace with actual profile picture
                ),
              ),
              // Friend's name
              title: Text('Name', style: TextStyles.regularStyleMedium),
              // Debt or credit information
              subtitle: Text('**Date**', style: TextStyles.hintStyleDefault.copyWith(fontSize: TextStyles.fontSizeHint)),
              // Navigation arrow
              trailing: Text('10000,00€', style: TextStyles.regularStyleMedium),
              minVerticalPadding: 0,
              contentPadding: EdgeInsets.zero,
            ),
            Container(child: Divider(color: CustomColor.grey)),
            Gap(CustomPadding.mediumSpace),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    child: Stack(
                      children: List.generate(4, (index) {
                        return Positioned(
                          left: index * 25,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: CustomColor.white),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                BalanceState(colorScheme: DebtsColorScheme.blue)
              ],
            ),
          ],
        ),
      )),
    );
  }
}
