import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/provider/user_provider.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/textfield_amount_of_money.dart';

/// This Screen represents the Edit Bank Account Screen
/// here the User can update his own Bank Account
class ChangeBankaccountScreen extends StatefulWidget {
  const ChangeBankaccountScreen({super.key});

  @override
  State<ChangeBankaccountScreen> createState() => _ChangeBankaccountScreenState();
}

class _ChangeBankaccountScreenState extends State<ChangeBankaccountScreen> {
  final TextEditingController _moneyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCurrentBankAccountInfo();
    });
  }

  void _loadCurrentBankAccountInfo() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentBankBalance = userProvider.currentUser?.bankAccountBalance ?? 0.0;
    setState(() {
      _moneyController.text = currentBankBalance.toStringAsFixed(2);
    });
  }

  Future<void> _saveBankAccountInfo() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final defaultColorScheme = Theme.of(context).colorScheme;

    final String amountText = _moneyController.text.trim().replaceAll(',', '.');
    if (amountText.isEmpty) {
      _showErrorSnackBar("Bitte geben Sie den Betrag ein.");
      return;
    }

    final double amount = double.tryParse(amountText) ?? -1;
    if (amount < 0) {
      _showErrorSnackBar("Ungültiger Betrag.");
      return;
    }

    try {
      await userProvider.updateBankAccountBalance(amount);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Bankkonto erfolgreich aktualisiert.",
                style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      _showErrorSnackBar("Fehler beim Speichern der Bankkonto-Informationen: $e");
    }
  }

  void _showErrorSnackBar(String message) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * CustomPadding.topSpace - Constants.defaultAppBarHeight,
              left: CustomPadding.defaultSpace,
              right: CustomPadding.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppTexts.changeBankAccHeading, style: TextStyles.headingStyle.copyWith(color: defaultColorScheme.primary)),
              const Gap(CustomPadding.mediumSpace),
              Text(AppTexts.changeBankAccDescribtion, style: TextStyles.hintStyleDefault),
              const Gap(CustomPadding.bigSpace),
              TextFieldAmountOfMoney(controller: _moneyController, hintText: AppTexts.lines),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: defaultColorScheme.onSurface,
        child: Container(
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * CustomPadding.bottomSpace,
              left: CustomPadding.defaultSpace,
              right: CustomPadding.defaultSpace),
          width: MediaQuery.of(context).size.width,
          // save Button
          child: ElevatedButton(onPressed: _saveBankAccountInfo, child: Text(AppTexts.save)),
        ),
      ),
    );
  }
}
