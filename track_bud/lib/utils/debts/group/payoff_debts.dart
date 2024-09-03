import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/split_widget.dart';
import 'package:track_bud/utils/strings.dart';

class PayOffDebts extends StatelessWidget {
  final void Function() onPressed;
  const PayOffDebts({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      padding: EdgeInsets.all(CustomPadding.defaultSpace),
      decoration: BoxDecoration(
        color: CustomColor.backgroundPrimary,
        borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppTexts.payOffDebts, style: TextStyles.titleStyleMedium),
          Gap(CustomPadding.defaultSpace),
          Text(AppTexts.payOffDebts, style: TextStyles.hintStyleDefault),
          Gap(CustomPadding.defaultSpace),
          ByAmountTile(),
          Gap(CustomPadding.defaultSpace),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              //TODO: update debts in db
            },
            child: Text(AppTexts.payOff),
          ),
        ],
      ),
    );
  }
}
