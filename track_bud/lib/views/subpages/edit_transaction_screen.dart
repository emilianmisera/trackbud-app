import 'dart:math';
import 'package:flutter/material.dart';
import 'package:track_bud/utils/buttons_widget.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/date_picker.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';

class EditTransactionScreen extends StatefulWidget {
  const EditTransactionScreen({super.key});

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

  String? _selectedCategory;  //for later when editing the chosen category

  // Updates the selected transaction type
  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  // when Expense is selected, prefix is "-", income is "+"
  String _getAmountPrefix() {
    return _currentSegment == 0 ? '–' : '+';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppString.editTransaction,
            style: CustomTextStyle.regularStyleMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: CustomPadding.defaultSpace,
            vertical: CustomPadding.defaultSpace),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text field for transaction title
              CustomTextfield(
                  name: AppString.title,
                  hintText: AppString.hintTitle,
                  controller: _titleController),
              SizedBox(
                height: CustomPadding.defaultSpace,
              ),
              // Row containing amount and date fields
              Row(
                children: [
                  // Amount text field
                  CustomTextfield(
                    name: AppString.amount,
                    hintText: AppString.lines,
                    controller: _amountController,
                    width: MediaQuery.sizeOf(context).width / 3,
                    prefix: Text(
                      _getAmountPrefix(),
                      style: CustomTextStyle.titleStyleMedium.copyWith(
                          fontWeight: CustomTextStyle.fontWeightDefault),
                    ),
                    type: TextInputType.numberWithOptions(),
                  ),
                  SizedBox(
                    width: CustomPadding.defaultSpace,
                  ),

                  // Date text field
                  DatePicker()
                ],
              ),
              SizedBox(
                height: CustomPadding.defaultSpace,
              ),
              // Category section
              Text(
                AppString.categorie,
                style: CustomTextStyle.regularStyleMedium,
              ),
              SizedBox(
                height: CustomPadding.mediumSpace,
              ),
              // Display either expense or income categories based on current segment
              _currentSegment == 0
                  ? CategoriesExpense(onCategorySelected: _onCategorySelected)
                  : CategoriesIncome(onCategorySelected: _onCategorySelected),
              SizedBox(
                height: CustomPadding.defaultSpace,
              ),
              // Recurrence section
              Text(
                AppString.recurry,
                style: CustomTextStyle.regularStyleMedium,
              ),
              SizedBox(
                height: CustomPadding.mediumSpace,
              ),
              // Dropdown for selecting recurrence frequency
              CustomDropDown(
                list: [
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
              ),
              SizedBox(
                height: CustomPadding.defaultSpace,
              ),
              // Note text field
              CustomTextfield(
                name: AppString.note,
                hintText: AppString.noteHint,
                controller: _noteController,
                isMultiline: true,
              ),
              SizedBox(
                height: CustomPadding.defaultSpace,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(
          bottom: min(
              MediaQuery.of(context).viewInsets.bottom > 0
                  ? 0
                  : MediaQuery.of(context).size.height *
                      CustomPadding.bottomSpace,
              MediaQuery.of(context).size.height * CustomPadding.bottomSpace),
          left: CustomPadding.defaultSpace,
          right: CustomPadding.defaultSpace,
        ),
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          // Enable button only if profile has changed
          onPressed: () {
            //TODO: Backend edit Transactions
          },
          style: ElevatedButton.styleFrom(
              // Set button color based on whether profile has changed
              disabledBackgroundColor: CustomColor.bluePrimary.withOpacity(0.5),
              backgroundColor: CustomColor.bluePrimary),
          child: Text(AppString.save),
        ),
      ),
    );
  }
}
