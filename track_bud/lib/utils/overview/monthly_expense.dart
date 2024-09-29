import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/provider/transaction_provider.dart';
import 'package:track_bud/provider/user_provider.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/strings.dart';

class MonthlyExpenseTile extends StatelessWidget {
  const MonthlyExpenseTile({super.key});

  Color getProgressColor(double percentage) {
    if (percentage < 0.5) return CustomColor.green;
    if (percentage < 0.75) return CustomColor.unterkunft;
    if (percentage < 1.0) return Colors.orange;
    return CustomColor.darkRed;
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return Consumer2<UserProvider, TransactionProvider>(
      builder: (context, userProvider, transactionProvider, _) {
        final user = userProvider.currentUser;
        final totalSpent = transactionProvider.totalMonthlyExpense;
        final monthlyGoal = user?.monthlySpendingGoal ?? 0.0;

        final remainingAmount = monthlyGoal - totalSpent;
        final percentage = (totalSpent / monthlyGoal).clamp(0.0, 1.0);

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
                Text(
                  remainingAmount >= 0 ? '${remainingAmount.toStringAsFixed(2)}€' : '${remainingAmount.abs().toStringAsFixed(2)}€',
                  style: TextStyles.headingStyle.copyWith(color: remainingAmount >= 0 ? defaultColorScheme.primary : CustomColor.darkRed),
                ),
                Text(remainingAmount >= 0 ? AppTexts.remainingText : AppTexts.aboveMonthlyGoal,
                    style: TextStyles.hintStyleDefault.copyWith(color: defaultColorScheme.secondary)),
                const Gap(CustomPadding.smallSpace),
                LinearPercentIndicator(
                  padding: EdgeInsets.zero,
                  lineHeight: 7,
                  percent: percentage,
                  barRadius: const Radius.circular(180),
                  backgroundColor: defaultColorScheme.outline,
                  progressColor: getProgressColor(percentage),
                  animateFromLastPercent: true,
                  animation: true,
                ),
                const Gap(CustomPadding.smallSpace),
                Row(
                  children: [
                    Text('${totalSpent.toStringAsFixed(2)}€',
                        style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
                    const Gap(3),
                    Text(AppTexts.of, style: TextStyles.hintStyleDefault),
                    const Gap(3),
                    Text('${monthlyGoal.toStringAsFixed(2)}€',
                        style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
                    const Gap(3),
                    Text(AppTexts.spent, style: TextStyles.hintStyleDefault),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
