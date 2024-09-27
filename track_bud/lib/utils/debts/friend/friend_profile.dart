import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/balance_state.dart';
import 'package:track_bud/utils/enum/debts_box.dart';
import 'package:track_bud/utils/strings.dart';

class FriendProfileDetails extends StatelessWidget {
  final double totalDebt; // Total debt amount for the friend

  const FriendProfileDetails({
    super.key,
    required this.totalDebt,
  });

  // Determines the appropriate color scheme based on the total debt
  DebtsColorScheme _determineColorScheme(double totalDebt) {
    if (totalDebt > 0) {
      return DebtsColorScheme.green; // Positive debt (money owed)
    } else if (totalDebt < 0) {
      return DebtsColorScheme.red; // Negative debt (money receivable)
    } else {
      return DebtsColorScheme.blue; // No debt
    }
  }

  // Builds the debts section of the profile
  Widget _buildDebtsSection(
      BuildContext context, DebtsColorScheme colorScheme) {
    final defaultColorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppTexts.debts,
          style: TextStyles.regularStyleDefault
              .copyWith(color: defaultColorScheme.primary),
        ),
        BalanceState(
          colorScheme: colorScheme,
          amount: totalDebt == 0
              ? null // Use null for 'quitt' to trigger the default in BalanceState
              : '${totalDebt.abs().toStringAsFixed(2)}€', // Display the absolute value of total debt
        ),
      ],
    );
  }

  // Builds the shared groups section header
  Widget _buildSharedGroupsSection(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTexts.sameGroups,
          style: TextStyles.regularStyleDefault
              .copyWith(color: defaultColorScheme.primary),
        ),
        const Gap(CustomPadding.mediumSpace),
        // TODO: Add shared groups functionality here
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme =
        Theme.of(context).colorScheme; // Get the default color scheme
    final colorScheme = _determineColorScheme(
        totalDebt); // Determine the color scheme based on total debt

    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: defaultColorScheme.surface, // Background color of the container
        borderRadius: BorderRadius.circular(
            Constants.contentBorderRadius), // Rounded corners
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: CustomPadding.defaultSpace,
        vertical: CustomPadding.defaultSpace,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDebtsSection(context, colorScheme), // Build debts section
          const Gap(CustomPadding.defaultSpace), // Space between sections
          _buildSharedGroupsSection(context), // Build shared groups section
        ],
      ),
    );
  }
}
