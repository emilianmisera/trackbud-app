import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/add/add_entry_modal.dart';
import 'package:track_bud/utils/button_widgets/buttons_widget.dart';
import 'package:track_bud/utils/button_widgets/dropdown.dart';
import 'package:track_bud/utils/button_widgets/segment_control.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/date_picker.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widgets.dart';
import 'package:track_bud/utils/textinput_format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//___________________________________________________________________________________________________________________

// Widget for adding a new transaction
class AddTransaction extends StatefulWidget {
  AddTransaction({Key? key}) : super(key: key);

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  int _currentSegment = 0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String? _selectedCategory;
  String? _selectedRecurrence = 'einmalig';
  DateTime _selectedDateTime = DateTime.now();
  bool _isFormValid = false; // Track form validity

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_validateForm);
    _amountController.addListener(_validateForm);
  }

  // Function to add a new transaction to Firestore
  Future<void> _addTransactionToDB() async {
    try {
      // Get the current user
      final user = FirebaseAuth.instance.currentUser;

      // Create a new transaction document
      await FirebaseFirestore.instance.collection('transactions').add({
        'userId': user!.uid,
        'title': _titleController.text,
        // Parse amount from comma-separated string to double
        'amount':
            double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0 * (_currentSegment == 0 ? -1 : 1), // Negative for expenses
        'category': _selectedCategory,
        'date': _selectedDateTime,
        'recurrence': _selectedRecurrence,
        'note': _noteController.text,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaktion erfolgreich hinzugefügt.')),
      );

      // Clear the form or navigate back
      Navigator.pop(context);
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Hinzufügen der Transaktion: $e')),
      );
    }
  }

  @override
  void dispose() {
    // _titleController.removeListener(_validateForm);
    // _amountController.removeListener(_validateForm);
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // Validate form inputs
  void _validateForm() {
    setState(() {
      _isFormValid = _titleController.text.isNotEmpty && _amountController.text.isNotEmpty && _selectedCategory != null;
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _validateForm();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AddEntryModal(
      buttonText: AppTexts.addTransaction,
      initialChildSize: 0.76,
      maxChildSize: 0.95,
      isButtonEnabled: _isFormValid,
      onButtonPressed: () async {
        _addTransactionToDB();
      },
      child: Padding(
        padding: CustomPadding.screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title of the bottom sheet
            Center(
              child: Text(
                AppTexts.newTransaction,
                style: TextStyles.regularStyleMedium,
              ),
            ),
            Gap(CustomPadding.defaultSpace),
            // Segment control for switching between expense and income
            CustomSegmentControl(
              onValueChanged: (int? newValue) {
                setState(() {
                  _currentSegment = newValue ?? 0; // Update current segment
                });
              },
            ),
            Gap(CustomPadding.bigSpace),
            // Text field for transaction title
            CustomTextfield(name: AppTexts.title, hintText: AppTexts.hintTitle, controller: _titleController),
            Gap(CustomPadding.defaultSpace),
            // Row containing amount and date fields
            Row(
              children: [
                // Amount text field
                CustomTextfield(
                  name: AppTexts.amount,
                  hintText: '',
                  controller: _amountController,
                  width: MediaQuery.sizeOf(context).width / 3,
                  prefix: Text(
                    _currentSegment == 0 ? '–' : '+',
                    style: TextStyles.titleStyleMedium.copyWith(fontWeight: TextStyles.fontWeightDefault),
                  ),
                  type: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [GermanNumericTextFormatter()],
                ),
                Gap(CustomPadding.defaultSpace),
                // Date
                DatePicker(onDateTimeChanged: (dateTime) => setState(() => _selectedDateTime = dateTime)),
              ],
            ),
            Gap(CustomPadding.defaultSpace),
            Text(
              AppTexts.categorie,
              style: TextStyles.regularStyleMedium,
            ),
            Gap(CustomPadding.mediumSpace),
            // Category section
            // Display either expense or income categories based on current segment
            _currentSegment == 0
                ? CategoriesExpense(onCategorySelected: _onCategorySelected)
                : CategoriesIncome(onCategorySelected: _onCategorySelected),
            Gap(CustomPadding.defaultSpace),
            Text(
              AppTexts.recurry,
              style: TextStyles.regularStyleMedium,
            ),
            Gap(CustomPadding.mediumSpace),
            // Dropdown for selecting recurrence frequency
            CustomDropDown(list: [
              'einmalig',
              'täglich',
              'wöchentlich',
              'zweiwöchentlich',
              'halb-monatlich',
              'monatlich',
              'vierteljährlich',
              'halb-jährlich',
              'jährlich'
            ], dropdownWidth: MediaQuery.sizeOf(context).width - 32, onChanged: (value) => setState(() => _selectedRecurrence = value)),
            Gap(CustomPadding.defaultSpace),
            // Note text field
            CustomTextfield(
              name: AppTexts.note,
              hintText: AppTexts.noteHint,
              controller: _noteController,
              isMultiline: true,
            ),
            Gap(CustomPadding.defaultSpace),
          ],
        ),
      ),
    );
  }
}
