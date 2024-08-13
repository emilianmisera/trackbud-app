import 'package:flutter/material.dart';
import 'package:track_bud/utils/buttons_widget.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/views/nav_pages/settings_screen.dart';
import 'package:track_bud/views/subpages/change_bankaccount_screen.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  bool isActive = false;

  void _toggleSwitch(bool value) {
    // makes switch widget active when bool == true
    setState(() {
      isActive = !isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppString.accAdjustments,
            style: CustomTextStyle.regularStyleMedium),
        leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SettingsScreen()),
        (Route<dynamic> route) => false,
      );
    },
  ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.sizeOf(context).height *
                      CustomPadding.topSpaceAuth -
                  Constants.defaultAppBarHeight,
              left: CustomPadding.defaultSpace,
              right: CustomPadding.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppString.budget,
                style: CustomTextStyle.regularStyleMedium,
              ),
              SizedBox(
                height: CustomPadding.mediumSpace,
              ),
              AccAdjustmentButton(
                  //BankAccount
                  icon: AssetImport.target,
                  name: AppString.changeBankAcc,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeBankaccountScreen(),
                        ),
                      );
                  }),
              SizedBox(
                height: CustomPadding.mediumSpace,
              ),
              AccAdjustmentButton(
                  // Budget Goal
                  icon: AssetImport.target,
                  name: AppString.changeBudgetGoal,
                  onPressed: () {}),
              SizedBox(
                height: CustomPadding.mediumSpace,
              ),
              AccAdjustmentWidget(
                // Currency
                icon: AssetImport.settings,
                name: AppString.changeCurrency,
                widget: CustomDropDown(), // Dropdown for changing currency
              ),
              SizedBox(height: CustomPadding.defaultSpace),
              Text(
                AppString.appearance,
                style: CustomTextStyle.regularStyleMedium,
              ),
              SizedBox(
                height: CustomPadding.mediumSpace,
              ),
              AccAdjustmentWidget(
                // DarkMode
                icon: AssetImport.mode,
                name: AppString.darkMode,
                widget: Switch( // Switch Widget 
                  value: isActive,
                  onChanged: _toggleSwitch,
                  activeColor: CustomColor.bluePrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
