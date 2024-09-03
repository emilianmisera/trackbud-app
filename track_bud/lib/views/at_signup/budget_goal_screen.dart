import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/controller/user_controller.dart';
import 'package:track_bud/trackbud.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/textfield_amount_of_money.dart';

// This is the main class for the screen, which represents a form for entering bank account information.
class BudgetGoalScreen extends StatefulWidget {
  const BudgetGoalScreen({super.key});

  @override
  State<BudgetGoalScreen> createState() => _BudgetGoalScreenState();
}

class _BudgetGoalScreenState extends State<BudgetGoalScreen> {
  // Controller to handle the input in the TextField for the amount of money.
  final TextEditingController _moneyController = TextEditingController();

  // Add or update user's bank account balance in Firestore
  Future<void> addUserBankAccount(double amount) async {
    User? user = FirebaseAuth.instance.currentUser;
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    if (user != null) {
      try {
        debugPrint("trying updating BudgetGoal...");
        await UserController().updateBudgetGoal(userId, amount);
        debugPrint("updating BudgetGoal successfull!");
      } catch (e) {
        debugPrint("Error updating bank account: $e");
        // Handle the error
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => const AlertDialog(
              title: Text('Fehler :('),
            ),
          );
        }
      }
    } else {
      debugPrint("No authenticated user found");
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

    if (amount! < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ungültiger Betrag."),
        ),
      );
      return;
    }

    if (amount > 0) {
      debugPrint("Correct Number Input");
      await addUserBankAccount(amount);
      debugPrint("Navigating to Overview Screen...");
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TrackBud()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number')),
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
          bottom: MediaQuery.sizeOf(context).height * CustomPadding.bottomSpace,
          left: CustomPadding.defaultSpace,
          right: CustomPadding.defaultSpace,
        ),
        width: MediaQuery.of(context).size.width, // Set the button width to match the screen width
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
              Text(AppTexts.budgetGoalHeading, style: TextStyles.headingStyle),
              const Gap(CustomPadding.mediumSpace),
              // The description text
              Text(AppTexts.budgetGoalDescription, style: TextStyles.hintStyleDefault),
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
