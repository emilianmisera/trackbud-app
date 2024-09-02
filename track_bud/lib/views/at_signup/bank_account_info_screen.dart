import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/controller/user_controller.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';
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

  Future<void> _saveBankAccountInfo() async {
    // Get the current user's ID
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (userId.isEmpty) {
      // Handle the case when user ID is not available
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Benutzer nicht angemeldet."),
        ),
      );
      return;
    }

    final String amountText = _moneyController.text.trim();
    if (amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Bitte geben Sie den Betrag ein."),
        ),
      );
      return;
    }

    final double amount = double.tryParse(amountText) ?? -1;
    if (amount < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Ungültiger Betrag."),
        ),
      );
      return;
    }

    try {
      // Call the UserController to update the bank account information
      await UserController().updateBankAccountBalance(userId, amount);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Bankkonto erfolgreich aktualisiert."),
        ),
      );

      // Navigate to the main screen or wherever is appropriate
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => BudgetGoalScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Fehler beim Speichern der Bankkonto-Informationen: $e"),
        ),
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
        width: MediaQuery.of(context).size.width, // Set the button width to match the screen width
        child: ElevatedButton(
          onPressed: _saveBankAccountInfo,
          child: Text(
            AppTexts.continueText,
          ),
        ),
      ),
      // The main content of the screen is wrapped in a SingleChildScrollView to make it scrollable.
      body: SingleChildScrollView(
        child: Padding(
          // Padding adds spacing around the content inside the screen.
          padding: EdgeInsets.only(
            top: MediaQuery.sizeOf(context).height * CustomPadding.topSpaceAuth, // Top padding based on screen height
            left: CustomPadding.defaultSpace, // Left padding
            right: CustomPadding.defaultSpace, // Right padding
          ),
          child: Column(
            // Column to organize the content vertically.
            children: [
              Text(
                AppTexts.bankAccInfoHeading, // The heading text
                style: TextStyles.headingStyle, // The text style for the heading.
              ),
              Gap(CustomPadding.mediumSpace // Adds vertical space between the heading and the next element.
                  ),
              Text(
                AppTexts.bankAccInfoDescription, // The description text
                style: TextStyles.hintStyleDefault, // The text style for the description.
              ),
              Gap(CustomPadding.bigSpace // Adds more vertical space before the next element.
                  ),
              // A custom TextField widget for entering the amount of money, using the controller defined above.
              TextFieldAmountOfMoney(controller: _moneyController),
            ],
          ),
        ),
      ),
    );
  }
}
