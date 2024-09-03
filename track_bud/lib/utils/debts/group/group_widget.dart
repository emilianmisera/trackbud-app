import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/balance_state.dart';
import 'package:track_bud/utils/debts/group/payoff_debts.dart';
import 'package:track_bud/utils/enum/debts_box.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/strings.dart';

class DebtsOverview extends StatefulWidget {
  const DebtsOverview({super.key});

  @override
  State<DebtsOverview> createState() => _DebtsOverviewState();
}

class _DebtsOverviewState extends State<DebtsOverview> {
  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.all(CustomPadding.defaultSpace),
        decoration: BoxDecoration(color: CustomColor.white, borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
        child: Column(
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

              // Navigation arrow
              trailing: const BalanceState(
                //TODO: Change ColorScheme based on amount
                colorScheme: DebtsColorScheme.red,
                amount: '-120€',
              ),
              minVerticalPadding: 0,
              contentPadding: EdgeInsets.zero,
            ),
            const Gap(CustomPadding.smallSpace),
            GestureDetector(
              // popup window to pay off debts
              onTap: () => PayOffDebts(
                onPressed: () {},
              ),
              child: Text(AppTexts.payOff, style: TextStyles.regularStyleDefault.copyWith(color: CustomColor.bluePrimary)),
            ),
          ],
        ),
      ),
    );
  }
}
