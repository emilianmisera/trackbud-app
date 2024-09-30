import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/provider/user_provider.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/textfield_amount_of_money.dart';
import 'package:track_bud/views/at_signup/set_budget_goal_screen.dart';

// This is the main class for the screen, which represents a form for entering bank account information.
class BankAccountInfoScreen extends StatefulWidget {
  const BankAccountInfoScreen({super.key});

  @override
  State<BankAccountInfoScreen> createState() => _BankAccountInfoScreenState();
}

class _BankAccountInfoScreenState extends State<BankAccountInfoScreen> {
  // Controller to handle the input in the TextField for the amount of money.
  final TextEditingController _moneyController = TextEditingController();
  // make button active or disabled
  bool _textInput = false;

  // Add or update user's bank account balance in Firestore
  Future<void> addUserBankAccount(double amount) async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      debugPrint("trying to update users bankaccount");
      await userProvider.setBankAccountBalance(userId, amount);
      debugPrint("successfully updated users bankaccount");
    } catch (e) {
      debugPrint("Error updating bank account: $e");
      // Handle the error
      if (mounted) {
        final defaultColorScheme = Theme.of(context).colorScheme;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Fehler beim Spiechern der Bankkonto-Informationen $e',
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
        SnackBar(content: Text('Ungültiger Betrag.', style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary))),
      );
      return;
    } else if (amount > 0) {
      debugPrint("Correct Number Input");
      await addUserBankAccount(amount);
      debugPrint("Navigating to Budget Goal Screen...");
      if (context.mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BudgetGoalScreen()));
      }
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
      // The bottomSheet contains a button that is fixed at the bottom of the screen.
      bottomSheet: Container(
        color: defaultColorScheme.onSurface,
        child: Container(
          // Margin is applied to the bottom of the button and the sides for proper spacing.
          margin: EdgeInsets.only(
            bottom: MediaQuery.sizeOf(context).height * CustomPadding.bottomSpace, // Bottom margin based on screen height
            left: CustomPadding.defaultSpace, // Left margin
            right: CustomPadding.defaultSpace, // Right margin
          ),
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: _textInput ? () => handleSubmission(context) : null,
            child: Text(AppTexts.continueText),
          ),
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
              Text(AppTexts.bankAccInfoHeading, style: TextStyles.headingStyle.copyWith(color: defaultColorScheme.primary)),
              const Gap(CustomPadding.mediumSpace),
              // The description text
              Text(AppTexts.bankAccInfoDescription, style: TextStyles.hintStyleDefault.copyWith(color: defaultColorScheme.secondary)),
              const Gap(CustomPadding.bigSpace),
              // entering the amount of money
              TextFieldAmountOfMoney(
                controller: _moneyController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
