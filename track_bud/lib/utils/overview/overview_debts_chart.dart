import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/provider/friend_split_provider.dart';
import 'package:track_bud/provider/group_provider.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/balance_state.dart';
import 'package:track_bud/utils/enum/debts_box.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/strings.dart';

// Widget to display an overview of debts
class OverviewDebtsTile extends StatelessWidget {
  const OverviewDebtsTile({super.key});

  // Determines the color scheme based on the balance
  DebtsColorScheme _getColorScheme(double balance) {
    if (balance > 0) {
      return DebtsColorScheme.green; // Friend owes you money
    } else if (balance < 0) {
      return DebtsColorScheme.red; // You owe friend money
    } else {
      return DebtsColorScheme.blue; // No debt
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final friendSplitProvider = Provider.of<FriendSplitProvider>(context);
    final groupProvider = Provider.of<GroupProvider>(context); // Access GroupProvider

    // Get total debt amounts (including group debts/credits)
    double totalDebtToFriends = friendSplitProvider.getTotalFriendDebts() + groupProvider.getTotalDebts();
    double totalDebtFromFriends = friendSplitProvider.getTotalFriendCredits() + groupProvider.getTotalCredits();

    // Calculate total balance
    double totalBalance = totalDebtFromFriends - totalDebtToFriends; // Subtract debts from credits

    return CustomShadow(
      child: Container(
        padding: const EdgeInsets.all(CustomPadding.defaultSpace),
        decoration: BoxDecoration(
          color: defaultColorScheme.surface,
          borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row to display total balance
            _buildBalanceRow(context, defaultColorScheme, totalBalance),
            const Gap(CustomPadding.mediumSpace),
            // Row to display debt to friends
            _buildDebtRow(AppTexts.toOthers, totalDebtToFriends, CustomColor.red, defaultColorScheme.secondary),
            const Gap(CustomPadding.mediumSpace),
            // Row to display credits from friends
            _buildDebtRow(AppTexts.toYou, totalDebtFromFriends, CustomColor.green, defaultColorScheme.secondary),
          ],
        ),
      ),
    );
  }

  // Builds the balance row
  Widget _buildBalanceRow(BuildContext context, ColorScheme defaultColorScheme, double totalBalance) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppTexts.inTotal,
          style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary),
        ),
        BalanceState(
          colorScheme: _getColorScheme(totalBalance),
          amount: totalBalance == 0 ? '0.00€' : '${totalBalance.toStringAsFixed(2)}€',
        ),
      ],
    );
  }

  // Builds a row for displaying debts and credits
  Widget _buildDebtRow(String label, double amount, Color amountColor, Color labelColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyles.hintStyleDefault.copyWith(color: labelColor),
        ),
        Text(
          '${amount.toStringAsFixed(2)}€',
          style: TextStyles.regularStyleDefault.copyWith(color: amountColor),
        ),
      ],
    );
  }
}
