import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/enum/debts_box.dart';

class BalanceState extends StatelessWidget {
  final DebtsColorScheme colorScheme;
  final String? amount;

  const BalanceState({
    super.key,
    required this.colorScheme,
    this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: CustomPadding.mediumSpace, vertical: CustomPadding.smallSpace),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: colorScheme.getColor(context),
      ),
      child: Text(amount ?? 'quitt', style: TextStyles.regularStyleMedium.copyWith(color: colorScheme.textColor)),
    );
  }
}
