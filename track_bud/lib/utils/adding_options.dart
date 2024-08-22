// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:track_bud/utils/buttons_widget.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/date_picker.dart';
import 'package:track_bud/utils/split_widget.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';

// Reusable DynamicBottomSheet component
class DynamicBottomSheet extends StatelessWidget {
  // The content to be displayed in the bottom sheet
  final Widget child;
  // Initial size of the bottom sheet as a fraction of screen height
  final double initialChildSize;
  // Minimum size the bottom sheet can be dragged to
  final double minChildSize;
  // Maximum size the bottom sheet can be expanded to
  final double maxChildSize;
  // text of the button
  final String buttonText;

  const DynamicBottomSheet({
    Key? key,
    required this.child,
    this.initialChildSize = 0.8,
    this.minChildSize = 0.2,
    this.maxChildSize = 0.90,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: CustomColor.backgroundPrimary,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(Constants.buttonBorderRadius)),
          ),
          child: Column(
            children: [
              SizedBox(height: CustomPadding.mediumSpace),
              Center(
                child: Container(
                  // grabber
                  width: 36,
                  height: 5,
                  decoration: BoxDecoration(
                    color: CustomColor.grabberColor,
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                ),
              ),
              SizedBox(height: CustomPadding.defaultSpace),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: child, // The main content of the bottom sheet
                ),
              ),
              // Button to add the transaction
              Padding(
                padding: EdgeInsets.only(
                    left: CustomPadding.mediumSpace,
                    right: CustomPadding.mediumSpace,
                    bottom: MediaQuery.sizeOf(context).height *
                        CustomPadding.bottomSpace),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      //TODO: add Save option
                    },
                    child: Text(buttonText)),
              )
            ],
          ),
        );
      },
    );
  }
}

//____________________________________________________________________

// Widget for adding a new transaction
class AddTransaction extends StatefulWidget {
  AddTransaction({Key? key}) : super(key: key);

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  int _currentSegment = 0; // Tracks the current segment (expense or income)
  Set<String> _selected = {AppString.expense}; // Selected transaction type
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  // Updates the selected transaction type
  void updateSelected(Set<String> newSelection) {
    setState(() {
      _selected = newSelection;
    });
  }

// when Expense is selected, prefix is "-", income is "+"
  String _getAmountPrefix() {
    return _currentSegment == 0 ? '–' : '+';
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return DynamicBottomSheet(
      buttonText: AppString.addTransaction,
      initialChildSize: 0.80,
      maxChildSize: 0.95,
      child: Padding(
        padding: CustomPadding.screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title of the bottom sheet
            Center(
              child: Text(
                AppString.newTransaction,
                style: CustomTextStyle.regularStyleMedium,
              ),
            ),
            SizedBox(
              height: CustomPadding.defaultSpace,
            ),
            // Segment control for switching between expense and income
            CustomSegmentControl(
              onValueChanged: (int? newValue) {
                setState(() {
                  _currentSegment = newValue ?? 0; // Update current segment
                });
              },
            ),
            SizedBox(
              height: CustomPadding.bigSpace,
            ),
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
            _currentSegment == 0 ? CategoriesExpense() : CategoriesIncome(),
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
            if (keyboardHeight >
                0) // when you want to tip some text in notice, you can scroll up
              SizedBox(height: keyboardHeight),
          ],
        ),
      ),
    );
  }
}

//____________________________________________________________________

// Widget for adding new split
class AddSplit extends StatefulWidget {
  final List<String>? list;
  final String? friendName;
  final bool? isGroup;
  const AddSplit({
    Key? key,
    this.list, this.friendName, this.isGroup,
  }) : super(key: key);

  @override
  State<AddSplit> createState() => _AddSplitState();
}

class _AddSplitState extends State<AddSplit> {
  int _currentSegment = 0; // 0 for user, 1 for friend
  final TextEditingController _titleController = TextEditingController(); // title input
  final TextEditingController _amountController = TextEditingController(); // amount input

  SplitMethod _selectedSplitMethod = SplitMethod.equal; // equal Split is selected as default
  double _inputNumber = 0.00; // input Number

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_onInputChanged); // change input number
  }

// if you change amount, inputnumber will be updated
  void _onInputChanged() {
    setState(() {
      _inputNumber = double.tryParse(_amountController.text) ?? 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DynamicBottomSheet(
      buttonText: AppString.addSplit,
      initialChildSize: 0.80,
      maxChildSize: 0.95,
      child: Padding(
        padding: CustomPadding.screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title of the bottom sheet
            Center(
              child: Text(
                AppString.newSplit,
                style: CustomTextStyle.regularStyleMedium,
              ),
            ),
            SizedBox(
              height: CustomPadding.defaultSpace,
            ),
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
                    '-',
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
            // choosing who payed
            Text(
              AppString.payedBy,
              style: CustomTextStyle.regularStyleMedium,
            ),
            SizedBox(
              height: CustomPadding.mediumSpace,
            ),
            // Dropdown for selecting person who paid bill
            CustomDropDown(
              list: widget.list ?? [
                'Dir',
                widget.friendName ?? '**Friend Name**'
              ],
              dropdownWidth: MediaQuery.sizeOf(context).width - 32,
            ),
            SizedBox(
              height: CustomPadding.defaultSpace,
            ),
            // choose between 3 split options
            SplitMethodSelector(
              selectedMethod: _selectedSplitMethod,
              onSplitMethodChanged: (SplitMethod method) {
                setState(() {
                  _selectedSplitMethod = method;
                });
              },
            ),
            SizedBox(height: CustomPadding.defaultSpace),
            // first split option (eaul & default)
            if (_selectedSplitMethod == SplitMethod.equal)
              EqualSplitWidget(
                amount: _inputNumber,
                names: widget.list ?? [
                'Dir',
                widget.friendName ?? '**Friend Name**'
                ],
                isGroup: widget.isGroup ?? false,
              ),
            // second split option (percental)
            if (_selectedSplitMethod == SplitMethod.percent)
              PercentalSplitWidget(
                amount: _inputNumber,
                names: widget.list ?? [
                'Dir',
                widget.friendName ?? '**Friend Name**'
              ],
                ),
            // third split option (by amount)
            if (_selectedSplitMethod == SplitMethod.amount)
              ByAmountSplitWidget(names: widget.list ?? [
                'Dir',
                widget.friendName ?? '**Friend Name**'
              ],)
          ]
        ),
      ),
    );
  }
}
