import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/textfield_widget.dart';
import 'package:track_bud/views/subpages/group_overview_screeen.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupOverviewScreeen(
              groupName: '**group**',
            ), // '**FriendName**'
          ),
        );
      },
      child: CustomShadow(
          child: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: EdgeInsets.all(CustomPadding.defaultSpace),
        decoration: BoxDecoration(
            color: CustomColor.white,
            borderRadius: BorderRadius.circular(Constants.buttonBorderRadius)),
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
                  color: Colors
                      .red, // Placeholder color, replace with actual profile picture
                ),
              ),
              // Friend's name
              title: Text(
                'Name',
                style: CustomTextStyle.regularStyleMedium,
              ),
              // Debt or credit information
              subtitle: Text(
                '**Date**',
                style: CustomTextStyle.hintStyleDefault
                    .copyWith(fontSize: CustomTextStyle.fontSizeHint),
              ),
              // Navigation arrow
              trailing: Text(
                '10000,00',
                style: CustomTextStyle.regularStyleMedium,
              ),
              minVerticalPadding: 0,
              contentPadding: EdgeInsets.zero,
            ),
            Container(
              child: Divider(
                color: CustomColor.grey,
              ),
            ),
            SizedBox(
              height: CustomPadding.mediumSpace,
            ),
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
                              color: Colors
                                  .primaries[index % Colors.primaries.length],
                              shape: BoxShape.circle,
                              border: Border.all(color: CustomColor.white),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                DebtsInformation(
                  colorScheme: DebtsColorScheme.blue,
                )
              ],
            ),
          ],
        ),
      )),
    );
  }
}

enum DebtsColorScheme {
  blue,
  green,
  red,
}

class DebtsInformation extends StatelessWidget {
  final DebtsColorScheme colorScheme;
  final String? amount;

  const DebtsInformation({
    super.key,
    required this.colorScheme,
    this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(colorScheme);

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: CustomPadding.mediumSpace,
          vertical: CustomPadding.smallSpace),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: colors.backgroundColor),
      child: Text(
        amount ?? 'quitt',
        style: CustomTextStyle.regularStyleMedium
            .copyWith(color: colors.textColor),
      ),
    );
  }

  _ColorPair _getColors(DebtsColorScheme scheme) {
    switch (scheme) {
      case DebtsColorScheme.blue:
        return _ColorPair(
          backgroundColor: CustomColor.pastelBlue,
          textColor: CustomColor.bluePrimary,
        );
      case DebtsColorScheme.green:
        return _ColorPair(
          backgroundColor: CustomColor.pastelGreen,
          textColor: CustomColor.green,
        );
      case DebtsColorScheme.red:
        return _ColorPair(
          backgroundColor: CustomColor.pastelRed,
          textColor: CustomColor.red,
        );
    }
  }
}

class _ColorPair {
  final Color backgroundColor;
  final Color textColor;

  _ColorPair({required this.backgroundColor, required this.textColor});
}
