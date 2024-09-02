import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/buttons_widget.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/date_picker.dart';
import 'package:track_bud/utils/enum/split_methods.dart';
import 'package:track_bud/utils/split_widget.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widgets.dart';
import 'package:track_bud/utils/textinput_format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// This File shows following Widgets:
// 1) Reusuble scrollable DynamicBottomSheet that is only used for adding a new Transaction, Friendsplit & Groupsplit
// 2) Add a new Transaction
// 3) Add a new Split

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
  final VoidCallback onButtonPressed;

  final bool isButtonEnabled;

  const DynamicBottomSheet({
    Key? key,
    required this.child,
    this.initialChildSize = 0.76,
    this.minChildSize = 0.3,
    this.maxChildSize = 0.95,
    required this.buttonText,
    required this.onButtonPressed,
    required this.isButtonEnabled,
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
            borderRadius: BorderRadius.vertical(top: Radius.circular(Constants.contentBorderRadius)),
          ),
          child: Column(
            children: [
              Gap(CustomPadding.mediumSpace),
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
              Gap(CustomPadding.defaultSpace),
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
                    bottom: MediaQuery.sizeOf(context).height * CustomPadding.bottomSpace),
                child: ElevatedButton(onPressed: isButtonEnabled ? onButtonPressed : null, child: Text(buttonText)),
              )
            ],
          ),
        );
      },
    );
  }
}

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
    return DynamicBottomSheet(
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

//___________________________________________________________________________________________________________________

// Widget for adding new split
class AddSplit extends StatefulWidget {
  final List<String>? list;
  final String? friendName;
  final bool? isGroup;
  const AddSplit({
    Key? key,
    this.list,
    this.friendName,
    this.isGroup,
  }) : super(key: key);

  @override
  State<AddSplit> createState() => _AddSplitState();
}

class _AddSplitState extends State<AddSplit> {
  final TextEditingController _titleController = TextEditingController(); // title input
  final TextEditingController _amountController = TextEditingController(); // amount input
  String? _selectedCategory;
  SplitMethod _selectedSplitMethod = SplitMethod.equal; // equal Split is selected as default
  double _inputNumber = 0.00; // amount input Number
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_validateForm);
    _amountController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    // Remove listeners
    _titleController.removeListener(_validateForm);
    _amountController.removeListener(_onInputChanged);
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // Validate form inputs
  void _validateForm() {
    setState(() {
      _isFormValid = _titleController.text.isNotEmpty && _amountController.text.isNotEmpty && _selectedCategory != null;
    });
  }

  // Handle input changes for amount
  void _onInputChanged() {
    setState(() {
      _inputNumber = _parseAmount();
      _validateForm();
    });
  }

  // Handle category selection
  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _validateForm();
    });
  }

  // Parse amount from comma-separated string to double
  double _parseAmount() {
    String amountText = _amountController.text.replaceAll(',', '.');
    return double.tryParse(amountText) ?? 0.0;
  }

  Future<void> _saveNewSplit() async {
    // Implement group split saving logic here
  }

  @override
  Widget build(BuildContext context) {
    return DynamicBottomSheet(
      buttonText: AppTexts.addSplit,
      initialChildSize: 0.62,
      maxChildSize: 0.95,
      isButtonEnabled: _isFormValid,
      onButtonPressed: () async {
        await _saveNewSplit();
        Navigator.pop(context);
      },
      child: Padding(
        padding: CustomPadding.screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title of the bottom sheet
            Center(
              child: Text(
                AppTexts.newGroupSplit,
                style: TextStyles.regularStyleMedium,
              ),
            ),
            Gap(CustomPadding.defaultSpace),
            // Text field for transaction title
            CustomTextfield(name: AppTexts.title, hintText: AppTexts.hintTitle, controller: _titleController),
            Gap(CustomPadding.defaultSpace),
            // Row containing amount and date fields
            Row(
              children: [
                // Amount text field
                CustomTextfield(
                  name: AppTexts.amount,
                  hintText: AppTexts.lines,
                  controller: _amountController,
                  width: MediaQuery.sizeOf(context).width / 3,
                  prefix: Text(
                    '-',
                    style: TextStyles.titleStyleMedium.copyWith(fontWeight: TextStyles.fontWeightDefault),
                  ),
                  type: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    GermanNumericTextFormatter(),
                  ],
                ),
                Gap(CustomPadding.defaultSpace),
                // Add DatePicker here if needed
              ],
            ),
            Gap(CustomPadding.defaultSpace),
            Text(
              AppTexts.categorie,
              style: TextStyles.regularStyleMedium,
            ),
            Gap(CustomPadding.mediumSpace),
            // choose category
            CategoriesExpense(onCategorySelected: _onCategorySelected),
            Gap(CustomPadding.defaultSpace),
            Text(
              AppTexts.payedBy,
              style: TextStyles.regularStyleMedium,
            ),
            Gap(CustomPadding.mediumSpace),
            // choosing who payed
            // Dropdown for selecting person who paid bill
            CustomDropDown(
              list: widget.list ?? ['Dir', widget.friendName ?? '**Friend Name**'],
              dropdownWidth: MediaQuery.sizeOf(context).width - 32,
            ),
            Gap(CustomPadding.defaultSpace),
            // choose between 3 split options
            SplitMethodSelector(
              selectedMethod: _selectedSplitMethod,
              onSplitMethodChanged: (SplitMethod method) {
                setState(() {
                  _selectedSplitMethod = method;
                });
              },
            ),
            Gap(CustomPadding.defaultSpace),
            if (_selectedSplitMethod == SplitMethod.equal)
              EqualSplitWidget(
                amount: _inputNumber,
                names: widget.list ?? ['Dir', widget.friendName ?? '**Friend Name**'],
                isGroup: widget.isGroup ?? true,
              ),
            if (_selectedSplitMethod == SplitMethod.percent)
              PercentalSplitWidget(
                amount: _inputNumber,
                names: widget.list ?? ['Dir', widget.friendName ?? '**Friend Name**'],
              ),
            if (_selectedSplitMethod == SplitMethod.amount)
              ByAmountSplitWidget(
                names: widget.list ?? ['Dir', widget.friendName ?? '**Friend Name**'],
              )
          ],
        ),
      ),
    );
  }
}
