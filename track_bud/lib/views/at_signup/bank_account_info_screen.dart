import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/controller/user_controller.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/textfield_amount_of_money.dart';
import 'package:track_bud/views/at_signup/budget_goal_screen.dart';

// This is the main class for the screen, which represents a form for entering bank account information.
class BankAccountInfoScreen extends StatefulWidget {
  const BankAccountInfoScreen({super.key});

  @override
  State<BankAccountInfoScreen> createState() => _BankAccountInfoScreenState();
}

class _BankAccountInfoScreenState extends State<BankAccountInfoScreen> {
  // Controller to handle the input in the TextField for the amount of money.
  final TextEditingController _moneyController = TextEditingController();

  // Add or update user's bank account balance in Firestore
  Future<void> addUserBankAccount(double amount) async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final String amountText = _moneyController.text.trim();
    final double amount = double.tryParse(amountText) ?? -1;
    if (amount < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ungültiger Betrag."),
        ),
      );
      return;
    }

    try {
      debugPrint("trying to update users bankaccount");
      await UserController().updateBankAccountBalance(userId, amount);
      debugPrint("successfully updated users bankaccount");
    } catch (e) {
      debugPrint("Error updating bank account: $e");
      // Handle the error
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Fehler beim Spiechern der Bankkonto-Informationen $e'),
          ),
        );
      }
    }
  }

  // Convert comma-separated string to double
  double? parseCommaDecimal(String value) {
    String normalizedValue = value.replaceAll(',', '.');
    return double.tryParse(normalizedValue);
  }

  // method for saving information input from user
  Future<void> handleSubmission(BuildContext context) async {
    double? amount = parseCommaDecimal(_moneyController.text);
    if (amount != null) {
      await addUserBankAccount(amount);
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BudgetGoalScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gib eine valide Zahl an')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The bottomSheet contains a button that is fixed at the bottom of the screen.
      bottomSheet: Container(
        // Margin is applied to the bottom of the button and the sides for proper spacing.
        margin: EdgeInsets.only(
          bottom: MediaQuery.sizeOf(context).height * CustomPadding.bottomSpace, // Bottom margin based on screen height
          left: CustomPadding.defaultSpace, // Left margin
          right: CustomPadding.defaultSpace, // Right margin
        ),
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () => handleSubmission(context),
          child: Text(AppTexts.continueText),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          // Padding adds spacing around the content inside the screen.
          padding: EdgeInsets.only(
            top: MediaQuery.sizeOf(context).height * CustomPadding.topSpaceAuth,
            left: CustomPadding.defaultSpace,
            right: CustomPadding.defaultSpace,
          ),
          child: Column(
            // Column to organize the content vertically.
            children: [
              // The heading text
              Text(AppTexts.bankAccInfoHeading, style: TextStyles.headingStyle),
              const Gap(CustomPadding.mediumSpace),
              // The description text
              Text(AppTexts.bankAccInfoDescription, style: TextStyles.hintStyleDefault),
              const Gap(CustomPadding.bigSpace),
              // entering the amount of money
              TextFieldAmountOfMoney(controller: _moneyController),
            ],
          ),
        ),
      ),
    );
  }
}
