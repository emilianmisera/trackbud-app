import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';



enum DebtsColorScheme {
  blue,
  green,
  red,
}

class DebtsInformation extends StatelessWidget {
  final DebtsColorScheme colorScheme;
  final String? amount;

  const DebtsInformation({
    super.key,
    required this.colorScheme,
    this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(colorScheme);

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: CustomPadding.mediumSpace,
          vertical: CustomPadding.smallSpace),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: colors.backgroundColor),
      child: Text(
        amount ?? 'quitt',
        style: CustomTextStyle.regularStyleMedium
            .copyWith(color: colors.textColor),
      ),
    );
  }

  _ColorPair _getColors(DebtsColorScheme scheme) {
    switch (scheme) {
      case DebtsColorScheme.blue:
        return _ColorPair(
          backgroundColor: CustomColor.pastelBlue,
          textColor: CustomColor.bluePrimary,
        );
      case DebtsColorScheme.green:
        return _ColorPair(
          backgroundColor: CustomColor.pastelGreen,
          textColor: CustomColor.green,
        );
      case DebtsColorScheme.red:
        return _ColorPair(
          backgroundColor: CustomColor.pastelRed,
          textColor: CustomColor.red,
        );
    }
  }
}

class _ColorPair {
  final Color backgroundColor;
  final Color textColor;

  _ColorPair({required this.backgroundColor, required this.textColor});
}

