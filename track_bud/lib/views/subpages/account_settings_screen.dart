import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/button_widgets/acc_adjustment_widget.dart';
import 'package:track_bud/utils/button_widgets/acc_adjustment_button.dart';
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
    final defaultColorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTexts.accAdjustments, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.sizeOf(context).height * CustomPadding.topSpaceAuth - Constants.defaultAppBarHeight,
              left: CustomPadding.defaultSpace,
              right: CustomPadding.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppTexts.budget,
                style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary),
              ),
              const Gap(CustomPadding.mediumSpace),
              AccAdjustmentButton(
                  //BankAccount
                  icon: AssetImport.changeAmount,
                  name: AppTexts.changeBankAcc,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangeBankaccountScreen(),
                      ),
                    );
                  }),
              const Gap(CustomPadding.mediumSpace),
              AccAdjustmentButton(
                  // Budget Goal
                  icon: AssetImport.target,
                  name: AppTexts.changeBudgetGoal,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangeBudgetGoalScreen(),
                      ),
                    );
                  }),
              /*
              const Gap(CustomPadding.mediumSpace),
              AccAdjustmentWidget(
                // Currency
                icon: AssetImport.settings,
                name: AppTexts.changeCurrency,
                widget: const CurrencyDropdown(), // Dropdown for changing currency
              ),
              */
              const Gap(CustomPadding.defaultSpace),
              Text(
                AppTexts.appearance,
                style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary),
              ),
              const Gap(CustomPadding.mediumSpace),
              AccAdjustmentWidget(
                color: defaultColorScheme.onSurface,
                icon: AssetImport.mode,
                name: AppTexts.darkMode,
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
    final defaultColorScheme = Theme.of(context).colorScheme;
    return Container(
      // conatiner decoration
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          color: defaultColorScheme.outline,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
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
          style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary),
          dropdownColor: defaultColorScheme.surface,
          iconSize: 0.0,
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: TextStyles.titleStyleMedium.copyWith(color: defaultColorScheme.primary),
      ),
    );
  }
}
