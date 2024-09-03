import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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

    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .update({
          'budgetgoal': amount,
        });
      } catch (e) {
        debugPrint("Error updating bank account: $e");
        // Handle the error
        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  title: Text('Fehler :('),
                ));
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
    if (amount != null) {
      await addUserBankAccount(amount);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TrackBud()),
      );
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
          bottom: MediaQuery.sizeOf(context).height *
              CustomPadding.bottomSpace, // Bottom margin based on screen height
          left: CustomPadding.defaultSpace, // Left margin
          right: CustomPadding.defaultSpace, // Right margin
        ),
        width: MediaQuery.of(context)
            .size
            .width, // Set the button width to match the screen width
        child: ElevatedButton(
          onPressed: () {
            handleSubmission(context);
          },
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
            top: MediaQuery.sizeOf(context).height *
                CustomPadding
                    .topSpaceAuth, // Top padding based on screen height
            left: CustomPadding.defaultSpace, // Left padding
            right: CustomPadding.defaultSpace, // Right padding
          ),
          child: Column(
            // Column to organize the content vertically.
            children: [
              Text(
                AppTexts.budgetGoalHeading, // The heading text
                style:
                    TextStyles.headingStyle, // The text style for the heading.
              ),
              Gap(
                CustomPadding
                    .mediumSpace, // Adds vertical space between the heading and the next element.
              ),
              Text(
                AppTexts.budgetGoalDescription, // The description text
                style: TextStyles
                    .hintStyleDefault, // The text style for the description.
              ),
              Gap(
                CustomPadding
                    .bigSpace, // Adds more vertical space before the next element.
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
