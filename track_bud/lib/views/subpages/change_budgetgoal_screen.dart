import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:track_bud/controller/user_controller.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';
import 'package:track_bud/views/subpages/account_settings_screen.dart';

class ChangeBudgetGoalScreen extends StatefulWidget {
  const ChangeBudgetGoalScreen({super.key});

  @override
  State<ChangeBudgetGoalScreen> createState() => _ChangeBudgetGoalScreenState();
}

class _ChangeBudgetGoalScreenState extends State<ChangeBudgetGoalScreen> {
  // Controller to handle the input in the TextField for the amount of money.
  final TextEditingController _moneyController = TextEditingController();
  final UserController _userController = UserController();

  @override
  void initState() {
    super.initState();
    _loadCurrentBudgetGoal(); // Load bank account info when screen is initialized
  }

  void _saveChanges() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => AccountSettingsScreen()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _loadCurrentBudgetGoal() async {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Benutzer nicht angemeldet."),
        ),
      );
      return;
    }

    try {
      double currentBalance = await _userController.getBudgetGoal(userId);
      _moneyController.text = currentBalance
          .toStringAsFixed(2); // Formatierung auf 2 Dezimalstellen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Fehler beim Laden des Bankkontostands: $e"),
        ),
      );
    }
  }

  Future<void> _saveBudgetGoal() async {
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
      await UserController().updateBudgetGoal(userId, amount);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Budget erfolgreich aktualisiert."),
        ),
      );
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
                AppString.changeBudgetGoalHeading, // The heading text
                style: CustomTextStyle
                    .headingStyle, // The text style for the heading.
              ),
              SizedBox(
                height: CustomPadding
                    .mediumSpace, // Adds vertical space between the heading and the next element.
              ),
              Text(
                AppString.changeBudgetGoalDescribtion, // The description text
                style: CustomTextStyle
                    .hintStyleDefault, // The text style for the description.
              ),
              SizedBox(
                height: CustomPadding
                    .bigSpace, // Adds more vertical space before the next element.
              ),
              // A custom TextField widget for entering the amount of money, using the controller defined above.
              TextFieldAmountOfMoney(
                controller: _moneyController,
                hintText: '0000',
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
          onPressed: () {
            _saveBudgetGoal();
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
