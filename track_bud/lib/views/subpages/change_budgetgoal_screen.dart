import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  void initState() {
    super.initState();
    _loadCurrentBudgetGoal(); 
  }

  Future<void> _loadCurrentBudgetGoal() async {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Benutzer nicht angemeldet."),
        ),
      );
      return;
    }

    try {
      // Fetch user data directly from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null && userData.containsKey('monthlySpendingGoal'))
 {
          setState(() {
            _moneyController.text = userData['monthlySpendingGoal'].toStringAsFixed(2);
          });
        } else {
          // Handle case where budget goal is not found in Firestore
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Budgetziel nicht gefunden."),
            ),
          );
        }
      } else {
        // Handle case where user document is not found in Firestore
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Benutzerdaten nicht gefunden."),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Fehler beim Laden des Budgetziels: $e"),
        ),
      );
    }
  }

  Future<void> _saveBudgetGoal() async {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Benutzer nicht angemeldet."),
        ),
      );
      return;
    }

    final String amountText = _moneyController.text.trim().replaceAll(',', '.');
    if (amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Bitte geben Sie den Betrag ein."),
        ),
      );
      return;
    }

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
      // Update budget goal directly in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'monthlySpendingGoal': amount});

      // If you have a UserController, you might want to update it as well
      // await UserController().updateBudgetGoal(userId, amount); 

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Budget erfolgreich aktualisiert."),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Fehler beim Speichern des Budgets: $e"),
        ),
      );
    }
  }


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
              const Gap(
                CustomPadding
                    .mediumSpace, // Adds vertical space between the heading and the next element.
              ),
              Text(
                AppTexts.changeBudgetGoalDescribtion, // The description text
                style: TextStyles
                    .hintStyleDefault, // The text style for the description.
              ),
              const Gap(
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
          onPressed: _saveBudgetGoal,
          child: Text(
            AppTexts.save,
          ),
        ),
      ),
    );
  }
}