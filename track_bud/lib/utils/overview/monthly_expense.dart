import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/strings.dart';

class MonthlyExpenseTile extends StatefulWidget {
  const MonthlyExpenseTile({super.key});

  @override
  State<MonthlyExpenseTile> createState() => _MonthlyExpenseTileState();
}

class _MonthlyExpenseTileState extends State<MonthlyExpenseTile> {
  // Progress percentage (0.0 to 1.0)
  double _percentage = 0.6;

  // Function to determine progress color based on percentage
  Color getProgressColor(double percentage) {
    if (percentage < 0.5) {
      return CustomColor.green; // Green for the first half
    } else if (percentage < 0.75) {
      return CustomColor.unterkunft; // Yellow for 50-75%
    } else if (percentage < 1.0) {
      return Colors.orange; // Orange for 75-99%
    } else {
      return Colors.red[900]!; // Dark red for 100%
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: Container(
        padding: EdgeInsets.all(CustomPadding.defaultSpace),
        decoration: BoxDecoration(
          color: CustomColor.white,
          borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Remaining amount
            Text('50,00€', style: TextStyles.headingStyle),
            Text(AppTexts.remainingText, style: TextStyles.hintStyleDefault),
            Gap(CustomPadding.smallSpace),

            // Progress bar
            LinearPercentIndicator(
              padding: EdgeInsets.zero,
              lineHeight: 7,
              percent: _percentage,
              barRadius: const Radius.circular(180),
              backgroundColor: CustomColor.grey,
              progressColor: getProgressColor(
                  _percentage), // Dynamic color based on percentage
              animateFromLastPercent: true,
              animation: true,
            ),
            Gap(CustomPadding.smallSpace),

            // Expense details
            Row(
              children: [
                Text('250€', style: TextStyles.regularStyleMedium),
                Gap(3),
                Text(AppTexts.of, style: TextStyles.hintStyleDefault),
                Gap(3),
                Text('400€', style: TextStyles.regularStyleMedium),
                Gap(3),
                Text(AppTexts.spent, style: TextStyles.hintStyleDefault),
              ],
            )
          ],
        ),
      ),
    );
  }
}
