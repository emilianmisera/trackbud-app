import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/group_widget.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';

// Widget to display an overview of debts
class OverviewDebtsWidget extends StatelessWidget {
  const OverviewDebtsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: Container(
        padding: EdgeInsets.all(CustomPadding.defaultSpace),
        decoration: BoxDecoration(
          color: CustomColor.white,
          borderRadius: BorderRadius.circular(Constants.buttonBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row to display total debt
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppString.inTotal,
                  style: CustomTextStyle.regularStyleMedium,
                ),
                DebtsInformation(
                  colorScheme: DebtsColorScheme.green,
                  amount: '100,00€',
                )
              ],
            ),
            SizedBox(
              height: CustomPadding.mediumSpace,
            ),
            // Row to display debt to friends
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppString.toFriends,
                  style: CustomTextStyle.hintStyleDefault,
                ),
                Text(
                  '10€',
                  style: CustomTextStyle.regularStyleDefault
                      .copyWith(color: CustomColor.red),
                )
              ],
            ),
            SizedBox(
              height: CustomPadding.mediumSpace,
            ),
            // Row to display friend's avatar and name (for debt to friends)
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Container(
                    width: 25,
                    height: 25,
                    color: Colors.red,
                  ),
                ),
                SizedBox(
                  width: CustomPadding.mediumSpace,
                ),
                Text('Freund', style: CustomTextStyle.regularStyleDefault.copyWith(fontSize: 14),)
              ],
            ),
            SizedBox(
              height: CustomPadding.defaultSpace,
            ),
            // Row to display debt owed to you
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppString.toYou,
                  style: CustomTextStyle.hintStyleDefault,
                ),
                Text(
                  '110€',
                  style: CustomTextStyle.regularStyleDefault
                      .copyWith(color: CustomColor.green),
                )
              ],
            ),
            SizedBox(
              height: CustomPadding.mediumSpace,
            ),
            // Row to display friend's avatar and name (for debt owed to you)
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Container(
                    width: 25,
                    height: 25,
                    color: Colors.red,
                  ),
                ),
                SizedBox(
                  width: CustomPadding.mediumSpace,
                ),
                Text('Freund', style: CustomTextStyle.regularStyleDefault.copyWith(fontSize: 14),)
              ],
            ),
          ],
        ),
      ),
    );
  }
}