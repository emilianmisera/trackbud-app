import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/balance_state.dart';
import 'package:track_bud/utils/enum/debts_box.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/strings.dart';


// Widget to display an overview of debts
class OverviewDebtsTile extends StatelessWidget {
  const OverviewDebtsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: Container(
        padding: const EdgeInsets.all(CustomPadding.defaultSpace),
        decoration: BoxDecoration(
          color: CustomColor.white,
          borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row to display total debt
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppTexts.inTotal, style: TextStyles.regularStyleMedium),
                const BalanceState(
                    //TODO: Change ColorScheme based on amount
                    colorScheme: DebtsColorScheme.green,
                    amount: '100,00€')
              ],
            ),
            const Gap(CustomPadding.mediumSpace),
            // Row to display debt to friends
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppTexts.toFriends, style: TextStyles.hintStyleDefault),
                Text('10€', style: TextStyles.regularStyleDefault.copyWith(color: CustomColor.red))
              ],
            ),
            const Gap(CustomPadding.mediumSpace),
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
                const Gap(CustomPadding.mediumSpace),
                Text('Freund', style: TextStyles.regularStyleDefault.copyWith(fontSize: TextStyles.fontSizeHint))
              ],
            ),
            const Gap(CustomPadding.defaultSpace),
            // Row to display debt owed to you
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppTexts.toYou, style: TextStyles.hintStyleDefault),
                Text('110€', style: TextStyles.regularStyleDefault.copyWith(color: CustomColor.green))
              ],
            ),
            const Gap(CustomPadding.mediumSpace),
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
                const Gap(CustomPadding.mediumSpace),
                Text('Freund', style: TextStyles.regularStyleDefault.copyWith(fontSize: TextStyles.fontSizeHint))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
