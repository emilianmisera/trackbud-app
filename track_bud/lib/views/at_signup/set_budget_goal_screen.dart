import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/provider/user_provider.dart';
import 'package:track_bud/trackbud.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/textfield_amount_of_money.dart';

/// This Screen represents a form for entering the Users Budget Goal
class BudgetGoalScreen extends StatefulWidget {
  const BudgetGoalScreen({super.key});

  @override
  State<BudgetGoalScreen> createState() => _BudgetGoalScreenState();
}

class _BudgetGoalScreenState extends State<BudgetGoalScreen> {
  final TextEditingController _moneyController = TextEditingController();
  bool _textInput = false;

  // Add or update user's bank account balance in Firestore
  Future<void> addUserBankAccount(double amount) async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      debugPrint("trying updating BudgetGoal...");
      await UserProvider().setBudgetGoal(userId, amount);
      debugPrint("updating BudgetGoal successfull!");
    } catch (e) {
      debugPrint("Error updating bank account: $e");
      // Handle the error
      if (mounted) {
        final defaultColorScheme = Theme.of(context).colorScheme;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Fehler beim Spiechern des Budgetgoals $e',
                style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
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

  // checking if there was an input of the User
  void _validateForm() {
    setState(() {
      _textInput = _moneyController.text.isNotEmpty;
    });
  }

  // method for saving information input from user
  Future<void> handleSubmission(BuildContext context) async {
    final defaultColorScheme = Theme.of(context).colorScheme;
    double? amount = parseCommaDecimal(_moneyController.text);

    if (amount! < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ungültiger Betrag.", style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary))),
      );
      return;
    } else if (amount > 0) {
      debugPrint("Correct Number Input");
      await addUserBankAccount(amount);
      debugPrint("Navigating to Overview Screen...");
      if (context.mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TrackBud()));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Please enter a valid number', style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary))),
      );
    }
  }

  @override
  void initState() {
    _moneyController.addListener(_validateForm);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      bottomSheet: Container(
        color: defaultColorScheme.onSurface,
        child: Container(
          margin: EdgeInsets.only(
              bottom: MediaQuery.sizeOf(context).height * CustomPadding.bottomSpace,
              left: CustomPadding.defaultSpace,
              right: CustomPadding.defaultSpace),
          width: MediaQuery.of(context).size.width,
          // Continue Button
          child: ElevatedButton(onPressed: _textInput ? () => handleSubmission(context) : null, child: Text(AppTexts.continueText)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.sizeOf(context).height * CustomPadding.topSpaceAuth,
              left: CustomPadding.defaultSpace,
              right: CustomPadding.defaultSpace),
          child: Column(
            children: [
              // The heading text
              Text(AppTexts.budgetGoalHeading, style: TextStyles.headingStyle.copyWith(color: defaultColorScheme.primary)),
              const Gap(CustomPadding.mediumSpace),
              // The description text
              Text(AppTexts.budgetGoalDescription, style: TextStyles.hintStyleDefault.copyWith(color: defaultColorScheme.secondary)),
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
