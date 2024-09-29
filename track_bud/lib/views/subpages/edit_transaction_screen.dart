import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/provider/transaction_provider.dart';
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
  int _currentSegment = 0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String? _selectedCategory;
  String? _selectedRecurrence;
  DateTime? _selectedDateTime;
  late Future<DocumentSnapshot> _transactionFuture;

  @override
  void initState() {
    super.initState();
    _transactionFuture = _loadTransactionData();
  }

  Future<DocumentSnapshot> _loadTransactionData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('transactions').doc(widget.transactionId).get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      setState(() {
        _titleController.text = data['title'] ?? '';
        _amountController.text = data['amount']?.toString() ?? '';
        _noteController.text = data['note'] ?? '';
        _selectedCategory = data['category'];
        _selectedRecurrence = data['recurrence'];
        _selectedDateTime = (data['date'] as Timestamp?)?.toDate();
        _currentSegment = data['type'] == 'expense' ? 0 : 1;
      });
    }
    return doc;
  }

  Future<void> _updateTransaction() async {
    if (_selectedDateTime == null) return;

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
      body: FutureBuilder<DocumentSnapshot>(
        future: _transactionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: defaultColorScheme.primary)));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Transaction not found', style: TextStyle(color: defaultColorScheme.primary)));
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace, vertical: CustomPadding.defaultSpace),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextfield(name: AppTexts.title, hintText: AppTexts.hintTitle, controller: _titleController),
                  const Gap(CustomPadding.defaultSpace),
                  Row(
                    children: [
                      CustomTextfield(
                        name: AppTexts.amount,
                        hintText: '00.00',
                        controller: _amountController,
                        width: MediaQuery.sizeOf(context).width / 3,
                        prefix: Text(
                          _currentSegment == 0 ? '–' : '+',
                          style: TextStyles.titleStyleMedium
                              .copyWith(fontWeight: TextStyles.fontWeightDefault, color: defaultColorScheme.primary),
                        ),
                        suffix: Text('€', style: TextStyle(color: defaultColorScheme.primary)),
                        type: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+([.,]\d{0,2})?'),
                          ),
                        ],
                      ),
                      const Gap(CustomPadding.defaultSpace),
                      if (_selectedDateTime != null)
                        DatePicker(
                          onDateTimeChanged: _onDateTimeChanged,
                          initialDateTime: _selectedDateTime!,
                        ),
                    ],
                  ),
                  const Gap(CustomPadding.defaultSpace),
                  Text(AppTexts.categorie, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
                  const Gap(CustomPadding.mediumSpace),
                  _currentSegment == 0
                      ? CategoriesExpense(
                          onCategorySelected: _onCategorySelected,
                          selectedCategory: _selectedCategory,
                        )
                      : CategoriesIncome(onCategorySelected: _onCategorySelected, selectedCategory: _selectedCategory),
                  const Gap(CustomPadding.defaultSpace),
                  Text(AppTexts.recurrency, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
                  const Gap(CustomPadding.mediumSpace),
                  /*CustomDropDown(
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
                  ),*/
                  const Gap(CustomPadding.defaultSpace),
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
          );
        },
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
            onPressed: _updateTransaction,
            style: ElevatedButton.styleFrom(
                disabledBackgroundColor: CustomColor.bluePrimary.withOpacity(0.5), backgroundColor: CustomColor.bluePrimary),
            child: Text(AppTexts.save),
          ),
        ),
      ),
    );
  }
}
