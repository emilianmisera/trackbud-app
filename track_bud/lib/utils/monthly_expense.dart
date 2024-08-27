import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';

class MonthlyExpense extends StatefulWidget {
  const MonthlyExpense({super.key});

  @override
  State<MonthlyExpense> createState() => _MonthlyExpenseState();
}

class _MonthlyExpenseState extends State<MonthlyExpense> {
  //display Progress
  double _percentage = 0.1;

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: Container(
        padding: EdgeInsets.all(CustomPadding.defaultSpace),
        decoration: BoxDecoration(
          color: CustomColor.white,
          borderRadius: BorderRadius.circular(Constants.buttonBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('50,00€', style: CustomTextStyle.headingStyle,),
            Text(AppString.remainingText, style: CustomTextStyle.hintStyleDefault,),
            SizedBox(height: CustomPadding.smallSpace,),
            LinearPercentIndicator(
              padding: EdgeInsets.zero,
              lineHeight: 7,
              percent: _percentage, // Display the progress
              barRadius: const Radius.circular(180),
              backgroundColor: CustomColor.grey,
              progressColor: CustomColor.bluePrimary,
              animateFromLastPercent: true,
            ),
            SizedBox(height: CustomPadding.smallSpace,),
            Row(
              children: [
                Text('250€', style: CustomTextStyle.regularStyleMedium,),
                SizedBox(width: 3,),
                Text('von', style: CustomTextStyle.hintStyleDefault,),
                SizedBox(width: 3,),
                Text('400€', style: CustomTextStyle.regularStyleMedium,),
                SizedBox(width: 3,),
                Text('ausgegeben', style: CustomTextStyle.hintStyleDefault,),
              ],
            )
          ],
        ),
      ),
    );
  }
}
