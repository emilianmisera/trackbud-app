import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/enum/debts_box.dart';

class BalanceState extends StatelessWidget {
  final DebtsColorScheme colorScheme;
  final String? amount;

  const BalanceState({
    Key? key,
    required this.colorScheme,
    this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: CustomPadding.mediumSpace, vertical: CustomPadding.smallSpace),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: colorScheme.color,
      ),
      child: Text(amount ?? 'quitt', style: TextStyles.regularStyleMedium.copyWith(color: colorScheme.textColor)),
    );
  }
}
