import 'package:flutter/material.dart';
import 'package:track_bud/utils/buttons_widget.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/views/subpages/change_bankaccount_screen.dart';
import 'package:track_bud/views/subpages/change_budgetgoal_screen.dart';

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
                  icon: AssetImport.changeAmount,
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeBudgetGoalScreen(),
                      ),
                    );
                  }),
              SizedBox(
                height: CustomPadding.mediumSpace,
              ),
              AccAdjustmentWidget(
                // Currency
                icon: AssetImport.settings,
                name: AppString.changeCurrency,
                widget: CurrencyDropdown(), // Dropdown for changing currency
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
                widget: Switch(
                  // Switch Widget
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

// Dropdown menu for currency
class CurrencyDropdown extends StatefulWidget {
  const CurrencyDropdown({super.key});

  @override
  State<CurrencyDropdown> createState() => _CurrencyDropdownState();
}

class _CurrencyDropdownState extends State<CurrencyDropdown> {
  final _currencyList = [
    "€",
    "\$",
    "£",
    "¥",
  ]; // List of currency Symbols
  String? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      // conatiner decoration
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          color: CustomColor.grey,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: DropdownButton<String>(
          // DropdownButton
          items: _currencyList.map(buildMenuItem).toList(),
          onChanged: (value) => setState(() {
            this.value = value;
          }),
          value: value,
          elevation: 0,
          style: CustomTextStyle.regularStyleMedium,
          dropdownColor: CustomColor.white,
          iconSize: 0.0,
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: CustomTextStyle.titleStyleMedium,
        ),
      );
}
