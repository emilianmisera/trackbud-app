import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/provider/transaction_provider.dart';
import 'package:track_bud/utils/plus_button/add_entry_modal.dart';
import 'package:track_bud/utils/button_widgets/segment_control.dart';
import 'package:track_bud/utils/categories/category_expenses.dart';
import 'package:track_bud/utils/categories/category_income.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/date_picker.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/textfield.dart';
import 'package:track_bud/utils/textinput_formatters.dart';
//___________________________________________________________________________________________________________________

// Widget for adding a new transaction
class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  int _currentSegment = 0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String? _selectedCategory;
  final String _selectedRecurrence = 'einmalig';
  DateTime _selectedDateTime = DateTime.now();
  bool _isFormValid = false; // Track form validity
  final _focusNodeTitle = FocusNode();
  final _focusNodeAmount = FocusNode();
  final _focusNodeNote = FocusNode();

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_validateForm);
    _amountController.addListener(_validateForm);
  }

  // Function to add a new transaction to Firestore
  Future<void> _addTransactionToDB() async {
    final defaultColorScheme = Theme.of(context).colorScheme;
    try {
      final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

      // Determine title based on the input or selected category
      String transactionTitle =
          _titleController.text.isNotEmpty ? _titleController.text : _selectedCategory ?? ''; // Use category name if title is empty

      await transactionProvider.addTransaction(
        _currentSegment == 0 ? 'expense' : 'income',
        double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0,
        {
          'title': transactionTitle, // Use the determined title
          'category': _selectedCategory,
          'recurrence': _selectedRecurrence,
          'note': _noteController.text,
          'date': _selectedDateTime,
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Transaktion erfolgreich hinzugefügt.',
                style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary))));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Fehler beim Hinzufügen der Transaktion: $e',
                style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary))));
      }
    }
  }

  @override
  void dispose() {
    _titleController.removeListener(_validateForm);
    _amountController.removeListener(_validateForm);
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // Validate form inputs
  void _validateForm() {
    setState(() {
      _isFormValid = _amountController.text.isNotEmpty && _selectedCategory != null;
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _validateForm();
    });
  }

  // Method to unfocus all text fields
  void _unfocusAll() {
    _focusNodeTitle.unfocus();
    _focusNodeAmount.unfocus();
    _focusNodeNote.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: _unfocusAll,
      child: AddEntryModal(
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
                  child: Text(AppTexts.newTransaction, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary))),
              const Gap(CustomPadding.defaultSpace),
              // Segment control for switching between expense and income
              CustomSegmentControl(
                onValueChanged: (int? newValue) {
                  setState(() {
                    _currentSegment = newValue ?? 0; // Update current segment
                  });
                },
              ),
              const Gap(CustomPadding.bigSpace),
              // Text field for transaction title
              CustomTextfield(
                name: AppTexts.title,
                hintText: AppTexts.hintTitle,
                controller: _titleController,
                focusNode: _focusNodeTitle,
              ),
              const Gap(CustomPadding.defaultSpace),
              // Row containing amount and date fields
              Row(
                children: [
                  // Amount text field
                  CustomTextfield(
                    name: AppTexts.amount,
                    hintText: '0.00',
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    width: MediaQuery.sizeOf(context).width / 3,
                    prefix: Text(_currentSegment == 0 ? '–' : '+',
                        style: TextStyles.titleStyleMedium
                            .copyWith(fontWeight: TextStyles.fontWeightDefault, color: defaultColorScheme.primary)),
                    suffix: Text('€', style: TextStyle(color: defaultColorScheme.primary)),
                    type: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      // Allow numbers and '.' or ',' as decimal separators and limit to 1,000,000
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+([.,]\d{0,2})?')), MaxValueInputFormatter(maxValue: 999999),
                    ],
                    focusNode: _focusNodeAmount,
                  ),
                  const Gap(CustomPadding.defaultSpace),
                  // Date
                  DatePicker(
                    onDateTimeChanged: (dateTime) => setState(() => _selectedDateTime = dateTime),
                    initialDateTime: DateTime.now(),
                  ),
                ],
              ),
              const Gap(CustomPadding.defaultSpace),
              Text(AppTexts.categorie, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
              const Gap(CustomPadding.mediumSpace),
              // Category section
              // Display either expense or income categories based on current segment
              _currentSegment == 0
                  ? CategoriesExpense(onCategorySelected: _onCategorySelected)
                  : CategoriesIncome(onCategorySelected: _onCategorySelected),
              const Gap(CustomPadding.defaultSpace),

              /*Text(AppTexts.recurrency,
                  style: TextStyles.regularStyleMedium
                      .copyWith(color: defaultColorScheme.primary)),
              const Gap(CustomPadding.mediumSpace),
              // Dropdown for selecting recurrence frequency
              CustomDropDown(
                  list: const [
                    'einmalig',
                    'täglich',
                    'wöchentlich',
                    'zweiwöchentlich',
                    'halb-monatlich',
                    'monatlich',
                    'vierteljährlich',
                    'halb-jährlich',
                    'jährlich'
                  ],
                  dropdownWidth: MediaQuery.sizeOf(context).width - 32,
                  onChanged: (value) =>
                      setState(() => _selectedRecurrence = value)),
              const Gap(CustomPadding.defaultSpace),*/
              // Note text field
              CustomTextfield(
                  name: AppTexts.note,
                  maxLength: 150,
                  hintText: AppTexts.noteHint,
                  controller: _noteController,
                  isMultiline: true,
                  focusNode: _focusNodeNote),
              const Gap(CustomPadding.defaultSpace),
            ],
          ),
        ),
      ),
    );
  }
}
