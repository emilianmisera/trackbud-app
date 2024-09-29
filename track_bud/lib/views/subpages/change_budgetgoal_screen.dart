import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/provider/user_provider.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/textfield_amount_of_money.dart';

class ChangeBudgetGoalScreen extends StatefulWidget {
  const ChangeBudgetGoalScreen({super.key});

  @override
  State<ChangeBudgetGoalScreen> createState() => _ChangeBudgetGoalScreenState();
}

class _ChangeBudgetGoalScreenState extends State<ChangeBudgetGoalScreen> {
  final TextEditingController _moneyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCurrentBudgetGoal();
    });
  }

  void _loadCurrentBudgetGoal() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentBudgetGoal = userProvider.monthlyBudgetGoal;
    setState(() {
      _moneyController.text = currentBudgetGoal.toStringAsFixed(2);
    });
  }

  Future<void> _saveBudgetGoal() async {
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
      await userProvider.setMonthlyBudgetGoal(amount);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("Budget erfolgreich aktualisiert.", style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      _showErrorSnackBar("Fehler beim Speichern des Budgets: $e");
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
            right: CustomPadding.defaultSpace,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppTexts.changeBudgetGoalHeading,
                style: TextStyles.headingStyle.copyWith(color: defaultColorScheme.primary),
              ),
              const SizedBox(height: CustomPadding.mediumSpace),
              Text(
                AppTexts.changeBudgetGoalDescribtion,
                style: TextStyles.hintStyleDefault,
              ),
              const SizedBox(height: CustomPadding.bigSpace),
              TextFieldAmountOfMoney(
                controller: _moneyController,
                hintText: AppTexts.lines,
              ),
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
            right: CustomPadding.defaultSpace,
          ),
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: _saveBudgetGoal,
            child: Text(AppTexts.save),
          ),
        ),
      ),
    );
  }
}
