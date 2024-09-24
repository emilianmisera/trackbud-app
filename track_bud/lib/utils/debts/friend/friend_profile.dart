import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/balance_state.dart';
import 'package:track_bud/utils/enum/debts_box.dart';
import 'package:track_bud/utils/strings.dart';

class FriendProfileDetails extends StatelessWidget {
  final double totalDebt;
  const FriendProfileDetails({
    super.key,
    required this.totalDebt,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    // Determine the color scheme based on the totalDebt
    DebtsColorScheme colorScheme;
    if (totalDebt > 0) {
      colorScheme = DebtsColorScheme.green;
    } else if (totalDebt < 0) {
      colorScheme = DebtsColorScheme.red;
    } else {
      colorScheme = DebtsColorScheme.blue;
    }

    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: defaultColorScheme.surface,
        borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
      ),
      padding: const EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace, vertical: CustomPadding.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Debts section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppTexts.debts, style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
              BalanceState(
                colorScheme: colorScheme,
                amount: totalDebt == 0
                    ? null // Use null for 'quitt' to trigger the default in BalanceState
                    : '${totalDebt.abs().toStringAsFixed(2)} €',
              ),
            ],
          ),
          const Gap(CustomPadding.defaultSpace),

          // Shared groups section
          Text(AppTexts.sameGroups, style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
          const Gap(CustomPadding.mediumSpace),

          // TODO: add same Groups
        ],
      ),
    );
  }
}
