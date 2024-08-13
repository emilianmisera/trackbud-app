import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';
import 'package:track_bud/views/subpages/account_settings_screen.dart';

class ChangeBankaccountScreen extends StatefulWidget {
  const ChangeBankaccountScreen({super.key});

  @override
  State<ChangeBankaccountScreen> createState() => _ChangeBankaccountScreenState();
}

class _ChangeBankaccountScreenState extends State<ChangeBankaccountScreen> {
  // Controller to handle the input in the TextField for the amount of money.
  final TextEditingController _moneyController = TextEditingController();

  void _saveChanges(){
    Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => AccountSettingsScreen()),
    (Route<dynamic> route) => false,
  );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          // Padding adds spacing around the content inside the screen.
          padding: EdgeInsets.only(
            top: MediaQuery.sizeOf(context).height *
                      CustomPadding.topSpace -
                  Constants.defaultAppBarHeight, // Top padding based on screen height
            left: CustomPadding.defaultSpace, // Left padding
            right: CustomPadding.defaultSpace, // Right padding
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppString.changeBankAccHeading, // The heading text
                style: CustomTextStyle
                    .headingStyle, // The text style for the heading.
              ),
              SizedBox(
                height: CustomPadding
                    .mediumSpace, // Adds vertical space between the heading and the next element.
              ),
              Text(
                AppString.changeBankAccDescribtion, // The description text
                style: CustomTextStyle
                    .hintStyleDefault, // The text style for the description.
              ),
              SizedBox(
                height: CustomPadding
                    .bigSpace, // Adds more vertical space before the next element.
              ),
              // A custom TextField widget for entering the amount of money, using the controller defined above.
              //TODO: insert current BankAccount here
              TextFieldAmountOfMoney(controller: _moneyController, hintText: '0000',), 
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
        child: ElevatedButton( // Saving Button
          onPressed: () {
            //TODO: Connect with backend (change BankAcc Value)
            _saveChanges();
          },
          child: Text(
            AppString.save,
          ),
        ),
      ),
    );
  }
}