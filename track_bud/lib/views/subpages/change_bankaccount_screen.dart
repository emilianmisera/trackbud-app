import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:track_bud/controller/user_controller.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/services/dependency_injector.dart';
import 'package:track_bud/services/sqlite_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';

class ChangeBankaccountScreen extends StatefulWidget {
  const ChangeBankaccountScreen({super.key});

  @override
  State<ChangeBankaccountScreen> createState() => _ChangeBankaccountScreenState();
}

class _ChangeBankaccountScreenState extends State<ChangeBankaccountScreen> {
  // Controller to handle the input in the TextField for the amount of money.
  final TextEditingController _moneyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //_loadCurrentBankAccountInfo(); // Load bank account info when screen is initialized
  }

/*
  Future<void> _loadCurrentBankAccountInfo() async {
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
      UserModel? localUser = await SQLiteService().getUserById(userId);
      print(
          'Loaded user bankaccount from SQLite: ${localUser?.bankAccountBalance}');
      await DependencyInjector.syncService.syncData(userId);
      if (localUser != null) {
        setState(() {
          _moneyController.text =
              localUser.bankAccountBalance.toStringAsFixed(2);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Fehler beim Laden des Bankkontostands: $e"),
        ),
      );
    }
  }
*/
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

    final String amountText = _moneyController.text.trim().replaceAll(',', '.');
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
      Navigator.pop(context);
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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          // Padding adds spacing around the content inside the screen.
          padding: EdgeInsets.only(
            top: MediaQuery.sizeOf(context).height * CustomPadding.topSpace -
                Constants.defaultAppBarHeight, // Top padding based on screen height
            left: CustomPadding.defaultSpace, // Left padding
            right: CustomPadding.defaultSpace, // Right padding
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppTexts.changeBankAccHeading, // The heading text
                style: TextStyles.headingStyle, // The text style for the heading.
              ),
              SizedBox(
                height: CustomPadding.mediumSpace, // Adds vertical space between the heading and the next element.
              ),
              Text(
                AppTexts.changeBankAccDescribtion, // The description text
                style: TextStyles.hintStyleDefault, // The text style for the description.
              ),
              SizedBox(
                height: CustomPadding.bigSpace, // Adds more vertical space before the next element.
              ),
              // A custom TextField widget for entering the amount of money, using the controller defined above.
              //TODO: insert current BankAccount here
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
          bottom: MediaQuery.sizeOf(context).height * CustomPadding.bottomSpace, // Bottom margin based on screen height
          left: CustomPadding.defaultSpace, // Left margin
          right: CustomPadding.defaultSpace, // Right margin
        ),
        child: ElevatedButton(
          // Saving Button
          onPressed: () {
            _saveBankAccountInfo();
          },
          child: Text(
            AppTexts.save,
          ),
        ),
      ),
    );
  }
}
