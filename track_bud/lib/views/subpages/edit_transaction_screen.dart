import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/provider/transaction_provider.dart';
import 'package:track_bud/utils/button_widgets/dropdown.dart';
import 'package:track_bud/utils/categories/category_expenses.dart';
import 'package:track_bud/utils/categories/category_income.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/date_picker.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/textfield.dart';

class EditTransactionScreen extends StatefulWidget {
  final String transactionId;
  const EditTransactionScreen({super.key, required this.transactionId});
  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  //change category & prefix
  //if 0 -> expense, if 1 (or other number) -> income
  int _currentSegment = 0;
  //controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String? _selectedCategory; //for later when editing the chosen category
  String? _selectedRecurrence;
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _loadTransactionData();
  }

  Future<void> _loadTransactionData() async {
    // Laden Sie die Transaktionsdaten aus Firestore
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('transactions').doc(widget.transactionId).get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      setState(() {
        _titleController.text = data['title'];
        _amountController.text = data['amount'].toString();
        _noteController.text = data['note'] ?? '';
        _selectedCategory = data['category'];
        _selectedRecurrence = data['recurrence'];
        _selectedDateTime = (data['date'] as Timestamp).toDate();
        _currentSegment = data['type'] == 'expense' ? 0 : 1;
      });
    }
  }

  Future<void> _updateTransaction() async {
    final updatedData = {
      'title': _titleController.text.trim(),
      'amount': double.parse(_amountController.text.replaceAll(',', '.')),
      'category': _selectedCategory,
      'note': _noteController.text,
      'date': Timestamp.fromDate(_selectedDateTime!),
      'recurrence': _selectedRecurrence,
      'type': _currentSegment == 0 ? 'expense' : 'income',
    };

    await Provider.of<TransactionProvider>(context, listen: false).updateTransaction(widget.transactionId, updatedData);

    if (mounted) Navigator.pop(context);
  }

  // Updates the selected transaction type
  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _onDateTimeChanged(DateTime newDateTime) {
    setState(() {
      _selectedDateTime = newDateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTexts.editTransaction, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace, vertical: CustomPadding.defaultSpace),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text field for transaction title
              CustomTextfield(name: AppTexts.title, hintText: AppTexts.hintTitle, controller: _titleController),
              const Gap(CustomPadding.defaultSpace),
              // Row containing amount and date fields
              Row(
                children: [
                  // Amount text field
                  CustomTextfield(
                    name: AppTexts.amount,
                    hintText: '',
                    controller: _amountController,
                    width: MediaQuery.sizeOf(context).width / 3,
                    prefix: Text(_currentSegment == 0 ? '–' : '+',
                        style: TextStyles.titleStyleMedium
                            .copyWith(fontWeight: TextStyles.fontWeightDefault, color: defaultColorScheme.primary)),
                    type: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const Gap(CustomPadding.defaultSpace),

                  DatePicker(onDateTimeChanged: _onDateTimeChanged)
                ],
              ),
              const Gap(CustomPadding.defaultSpace),
              // Category section
              Text(AppTexts.categorie, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
              const Gap(CustomPadding.mediumSpace),
              // Display either expense or income categories based on current segment
              _currentSegment == 0
                  ? CategoriesExpense(
                      onCategorySelected: _onCategorySelected,
                      selectedCategory: _selectedCategory,
                    )
                  : CategoriesIncome(onCategorySelected: _onCategorySelected, selectedCategory: _selectedCategory),
              const Gap(CustomPadding.defaultSpace),
              // Recurrence section
              Text(AppTexts.recurrency, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
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
                value: _selectedRecurrence,
                onChanged: (value) {
                  setState(() {
                    _selectedRecurrence = value;
                  });
                },
              ),
              const Gap(CustomPadding.defaultSpace),
              // Note text field
              CustomTextfield(
                name: AppTexts.note,
                hintText: AppTexts.noteHint,
                controller: _noteController,
                isMultiline: true,
              ),
              const Gap(CustomPadding.defaultSpace),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: defaultColorScheme.onSurface,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          margin: EdgeInsets.only(
            bottom: min(MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : MediaQuery.of(context).size.height * CustomPadding.bottomSpace,
                MediaQuery.of(context).size.height * CustomPadding.bottomSpace),
            left: CustomPadding.defaultSpace,
            right: CustomPadding.defaultSpace,
          ),
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            // Enable button only if profile has changed
            onPressed: () => _updateTransaction(),
            style: ElevatedButton.styleFrom(
                // Set button color based on whether profile has changed
                disabledBackgroundColor: CustomColor.bluePrimary.withOpacity(0.5),
                backgroundColor: CustomColor.bluePrimary),
            child: Text(AppTexts.save),
          ),
        ),
      ),
    );
  }
}
