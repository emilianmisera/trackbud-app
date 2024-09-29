import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';

class PayOffDebts extends StatelessWidget {
  final void Function() onPressed;
  const PayOffDebts({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      padding: const EdgeInsets.all(CustomPadding.defaultSpace),
      decoration: BoxDecoration(
        color: defaultColorScheme.surface,
        borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppTexts.payOffDebts, style: TextStyles.titleStyleMedium.copyWith(color: defaultColorScheme.primary)),
          const Gap(CustomPadding.defaultSpace),
          Text(AppTexts.payOffDebts, style: TextStyles.hintStyleDefault.copyWith(color: defaultColorScheme.secondary)),
          const Gap(CustomPadding.defaultSpace),
          //const ByAmountTile(),
          const Gap(CustomPadding.defaultSpace),
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
