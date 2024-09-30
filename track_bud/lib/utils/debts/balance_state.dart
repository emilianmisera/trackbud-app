import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/enum/debts_box.dart';

/// This Widgets shows the Balance State between him and his friend
/// blue = even
/// green = friend owes you
/// red = you owe friend
class BalanceState extends StatelessWidget {
  final DebtsColorScheme colorScheme;

  // The amount to be displayed
  final String? amount;

  const BalanceState({super.key, required this.colorScheme, this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: CustomPadding.mediumSpace, vertical: CustomPadding.smallSpace),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(Constants.balanceStateBoxCorners), color: colorScheme.getColor(context)),
      // Display the amount
      child: Text(amount ?? 'quitt', style: TextStyles.regularStyleMedium.copyWith(color: colorScheme.textColor)),
    );
  }
}
