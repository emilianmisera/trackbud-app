import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/textfield_amount_of_money.dart';

class ChangeBudgetGoalScreen extends StatefulWidget {
  const ChangeBudgetGoalScreen({super.key});

  @override
  State<ChangeBudgetGoalScreen> createState() => _ChangeBudgetGoalScreenState();
}

class _ChangeBudgetGoalScreenState extends State<ChangeBudgetGoalScreen> {
  // Controller to handle the input in the TextField for the amount of money.
  final TextEditingController _moneyController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          // Padding adds spacing around the content inside the screen.
          padding: EdgeInsets.only(
            top: MediaQuery.sizeOf(context).height * CustomPadding.topSpace -
                Constants
                    .defaultAppBarHeight, // Top padding based on screen height
            left: CustomPadding.defaultSpace, // Left padding
            right: CustomPadding.defaultSpace, // Right padding
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppTexts.changeBudgetGoalHeading, // The heading text
                style:
                    TextStyles.headingStyle, // The text style for the heading.
              ),
              Gap(
                CustomPadding
                    .mediumSpace, // Adds vertical space between the heading and the next element.
              ),
              Text(
                AppTexts.changeBudgetGoalDescribtion, // The description text
                style: TextStyles
                    .hintStyleDefault, // The text style for the description.
              ),
              Gap(
                CustomPadding
                    .bigSpace, // Adds more vertical space before the next element.
              ),
              // A custom TextField widget for entering the amount of money, using the controller defined above.
              TextFieldAmountOfMoney(
                controller: _moneyController,
                hintText: AppTexts.lines,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        // Margin is applied to the bottom of the button and the sides for proper spacing.
        margin: EdgeInsets.only(
          bottom: MediaQuery.sizeOf(context).height *
              CustomPadding.bottomSpace, // Bottom margin based on screen height
          left: CustomPadding.defaultSpace, // Left margin
          right: CustomPadding.defaultSpace, // Right margin
        ),
        width: MediaQuery.of(context)
            .size
            .width, // Set the button width to match the screen width
        child: ElevatedButton(
          // Saving Button
          onPressed: () {},
          child: Text(
            AppTexts.save,
          ),
        ),
      ),
    );
  }
}
