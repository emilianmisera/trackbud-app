import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/textfield_amount_of_money.dart';

class ChangeBankaccountScreen extends StatefulWidget {
  const ChangeBankaccountScreen({super.key});

  @override
  State<ChangeBankaccountScreen> createState() =>
      _ChangeBankaccountScreenState();
}

class _ChangeBankaccountScreenState extends State<ChangeBankaccountScreen> {
  // Controller to handle the input in the TextField for the amount of money.
  final TextEditingController _moneyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentBankAccountInfo(); // Load bank account info when screen is initialized
  }

  Future<void> _loadCurrentBankAccountInfo() async {
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
        if (userData != null && userData.containsKey('bankAccountBalance'))
 {
          setState(() {
            _moneyController.text = userData['bankAccountBalance'].toStringAsFixed(2);
          });
        } else {
          // Handle case where bank account balance is not found in Firestore
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Bankkontostand nicht gefunden."),
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
          content: Text("Fehler beim Laden des Bankkontostands: $e"),
        ),
      );
    }
  }

  Future<void> _saveBankAccountInfo() async {
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
      // Update bank account balance directly in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'bankAccountBalance': amount});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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
                Constants
                    .defaultAppBarHeight, // Top padding based on screen height
            left: CustomPadding.defaultSpace, // Left padding
            right: CustomPadding.defaultSpace, // Right padding
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppTexts.changeBankAccHeading, // The heading text
                style:
                    TextStyles.headingStyle, // The text style for the heading.
              ),
              const Gap(
          CustomPadding
                    .mediumSpace, // Adds vertical space between the heading and the next element.
              ),
              Text(
                AppTexts.changeBankAccDescribtion, // The description text
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
        child: ElevatedButton(
          // Saving Button
          onPressed: _saveBankAccountInfo,
          child: Text(
            AppTexts.save,
          ),
        ),
      ),
    );
  }
}