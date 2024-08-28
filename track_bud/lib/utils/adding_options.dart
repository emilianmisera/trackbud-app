import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:track_bud/models/transaction_model.dart';
import 'package:track_bud/services/cache_service.dart';
import 'package:track_bud/services/firestore_service.dart';
import 'package:track_bud/services/sqlite_service.dart';
import 'package:track_bud/services/sync_service.dart';
import 'package:track_bud/utils/buttons_widget.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/date_picker.dart';
import 'package:track_bud/utils/split_widget.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';
import 'package:track_bud/utils/textinput_format.dart';
import 'package:uuid/uuid.dart';

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
    required this.onButtonPressed, required this.isButtonEnabled,
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
                    onPressed: isButtonEnabled ? onButtonPressed : null, 
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
  int _currentSegment = 0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final Uuid _uuid = Uuid();
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
      _isFormValid = _titleController.text.isNotEmpty &&
          _amountController.text.isNotEmpty &&
          _selectedCategory != null;
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _validateForm();
    });
  }

  void _onRecurrenceSelected(String recurrence) {
    setState(() {
      _selectedRecurrence = recurrence;
    });
  }

  void _onDateTimeChanged(DateTime newDateTime) {
    setState(() {
      _selectedDateTime = newDateTime;
    });
  }

  String _getAmountPrefix() {
    return _currentSegment == 0 ? '–' : '+';
  }

  // Parse amount from comma-separated string to double
  double _parseAmount() {
    String amountText = _amountController.text.replaceAll(',', '.');
    return double.tryParse(amountText) ?? 0.0;
  }

  TransactionModel _getTransactionFromForm() {
    final String transactionId = _uuid.v4();
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      throw Exception('User nicht angemeldet');
    }
    String title = _titleController.text.trim();
    if (title.isEmpty) {
      title = _selectedCategory ?? 'Sonstiges';
    }
    final double amount = _parseAmount();
    final String type = _currentSegment == 0 ? 'expense' : 'income';
    final String category = _selectedCategory ?? 'none';
    final String notes = _noteController.text.trim();
    final DateTime date = _selectedDateTime;

    final String recurrenceType = _selectedRecurrence ?? 'einmalig';

    return TransactionModel(
      transactionId: transactionId,
      userId: userId,
      title: title,
      amount: amount,
      type: type,
      category: category,
      notes: notes,
      date: date,
      billImageUrl: '',
      currency: 'EUR',
      recurrenceType: recurrenceType,
    );
  }

  Future<void> _saveNewTransaction() async {
    final newTransaction = _getTransactionFromForm();

    try {
      await SQLiteService().insertTransaction(newTransaction);

      bool hasInternet = await SyncService(SQLiteService(), FirestoreService(), CacheService()).checkInternetConnection();
      if (hasInternet) {
        await FirestoreService().addTransaction(newTransaction);
        await SQLiteService().markTransactionAsSynced(newTransaction.transactionId);
      } else {
        print("Keine Internetverbindung, Transaktion wird später synchronisiert.");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaktion erfolgreich gespeichert!')),
      );
    } catch (e) {
      print('Fehler beim Speichern der Transaktion: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Speichern der Transaktion')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DynamicBottomSheet(
      buttonText: AppString.addTransaction,
      initialChildSize: 0.76,
      maxChildSize: 0.95,
      isButtonEnabled: _isFormValid,
      onButtonPressed: () async {
        await _saveNewTransaction();
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
                AppString.newTransaction,
                style: CustomTextStyle.regularStyleMedium,
              ),
            ),
            SizedBox(height: CustomPadding.defaultSpace),
            // Segment control for switching between expense and income
            CustomSegmentControl(
              onValueChanged: (int? newValue) {
                setState(() {
                  _currentSegment = newValue ?? 0;  // Update current segment
                });
              },
            ),
            SizedBox(height: CustomPadding.bigSpace),
            // Text field for transaction title
            CustomTextfield(
                name: AppString.title,
                hintText: AppString.hintTitle,
                controller: _titleController),
            SizedBox(height: CustomPadding.defaultSpace),
            // Row containing amount and date fields
            Row(
              children: [
                // Amount text field
                CustomTextfield(
                  name: AppString.amount,
                  hintText: '',
                  controller: _amountController,
                  width: MediaQuery.sizeOf(context).width / 3,
                  prefix: Text(
                    _getAmountPrefix(),
                    style: CustomTextStyle.titleStyleMedium.copyWith(
                        fontWeight: CustomTextStyle.fontWeightDefault),
                  ),
                  type: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    GermanNumericTextFormatter(),
                  ],

                ),
                SizedBox(width: CustomPadding.defaultSpace),
                // Date
                DatePicker(onDateTimeChanged: _onDateTimeChanged)
              ],
            ),
            SizedBox(height: CustomPadding.defaultSpace),
            Text(
              AppString.categorie,
              style: CustomTextStyle.regularStyleMedium,
            ),
            SizedBox(height: CustomPadding.mediumSpace),
            // Category section
            // Display either expense or income categories based on current segment
            _currentSegment == 0
                ? CategoriesExpense(onCategorySelected: _onCategorySelected)
                : CategoriesIncome(onCategorySelected: _onCategorySelected),
            SizedBox(height: CustomPadding.defaultSpace),
            Text(
              AppString.recurry,
              style: CustomTextStyle.regularStyleMedium,
            ),
            SizedBox(height: CustomPadding.mediumSpace),
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
              onChanged: (value) {
                _onRecurrenceSelected(value);
              },
            ),
            SizedBox(height: CustomPadding.defaultSpace),
            // Note text field
            CustomTextfield(
              name: AppString.note,
              hintText: AppString.noteHint,
              controller: _noteController,
              isMultiline: true,
            ),
            SizedBox(height: CustomPadding.defaultSpace),
          ],
        ),
      ),
    );
  }
}

// Widget for adding new friend split 
class AddFriendSplit extends StatefulWidget {
  final List<String>? list;
  final String? friendName;
  final bool? isGroup;
  const AddFriendSplit({
    Key? key,
    this.list,
    this.friendName,
    this.isGroup,
  }) : super(key: key);

  @override
  State<AddFriendSplit> createState() => _AddFriendSplitState();
}

class _AddFriendSplitState extends State<AddFriendSplit> {
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

  void _validateForm() {
    setState(() {
      _isFormValid = _titleController.text.isNotEmpty &&
          _amountController.text.isNotEmpty &&
          _selectedCategory != null;
    });
  }

// if you change amount, inputnumber will be updated
  void _onInputChanged() {
    setState(() {
      _inputNumber = _parseAmount();
      _validateForm();
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _validateForm();
    });
  }

  double _parseAmount() {
    String amountText = _amountController.text.replaceAll(',', '.');
    return double.tryParse(amountText) ?? 0.0;
  }

  Future<void> _saveNewSplit() async {
    // Implement split saving logic here
  }

  @override
  Widget build(BuildContext context) {
    return DynamicBottomSheet(
      buttonText: AppString.addSplit,
      initialChildSize: 0.76,
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
            Center(
              // Title of the bottom sheet
              child: Text(
                AppString.newSplit,
                style: CustomTextStyle.regularStyleMedium,
              ),
            ),
            SizedBox(height: CustomPadding.defaultSpace),
            // Text field for transaction title
            CustomTextfield(
                name: AppString.title,
                hintText: AppString.hintTitle,
                controller: _titleController),
            SizedBox(height: CustomPadding.defaultSpace),
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
                  type: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    GermanNumericTextFormatter(),
                  ],
                ),
                SizedBox(width: CustomPadding.defaultSpace),
                // Add DatePicker here if needed
              ],
            ),
            SizedBox(height: CustomPadding.defaultSpace),
            Text(
              AppString.categorie,
              style: CustomTextStyle.regularStyleMedium,
            ),
            SizedBox(height: CustomPadding.mediumSpace),
            CategoriesExpense(onCategorySelected: _onCategorySelected),
            SizedBox(height: CustomPadding.defaultSpace),
            Text(
              AppString.payedBy,
              style: CustomTextStyle.regularStyleMedium,
            ),
            SizedBox(height: CustomPadding.mediumSpace),
            // choosing who payed
            // Dropdown for selecting person who paid bill
            CustomDropDown(
              list: widget.list ?? ['Dir', widget.friendName ?? '**Friend Name**'],
              dropdownWidth: MediaQuery.sizeOf(context).width - 32,
            ),
            SizedBox(height: CustomPadding.defaultSpace),
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
            if (_selectedSplitMethod == SplitMethod.equal)
              EqualSplitWidget(
                amount: _inputNumber,
                names: widget.list ??
                    ['Dir', widget.friendName ?? '**Friend Name**'],
                isGroup: widget.isGroup ?? false,

              ),
            if (_selectedSplitMethod == SplitMethod.percent)
              PercentalSplitWidget(
                amount: _inputNumber,
                names: widget.list ??
                    ['Dir', widget.friendName ?? '**Friend Name**'],
              ),
            if (_selectedSplitMethod == SplitMethod.amount)
              ByAmountSplitWidget(
                names: widget.list ??
                    ['Dir', widget.friendName ?? '**Friend Name**'],
              )
          ],
        ),
      ),
    );
  }
}

// Widget for adding new group split
class AddGroupSplit extends StatefulWidget {
  final List<String>? list;
  final String? friendName;
  final bool? isGroup;
  const AddGroupSplit({
    Key? key,
    this.list,
    this.friendName,
    this.isGroup,
  }) : super(key: key);

  @override
  State<AddGroupSplit> createState() => _AddGroupSplitState();
}

class _AddGroupSplitState extends State<AddGroupSplit> {
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
      _isFormValid = _titleController.text.isNotEmpty &&
          _amountController.text.isNotEmpty &&
          _selectedCategory != null;
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
      buttonText: AppString.addSplit,
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
                AppString.newGroupSplit,
                style: CustomTextStyle.regularStyleMedium,
              ),
            ),
            SizedBox(height: CustomPadding.defaultSpace),
            // Text field for transaction title
            CustomTextfield(
                name: AppString.title,
                hintText: AppString.hintTitle,
                controller: _titleController),
            SizedBox(height: CustomPadding.defaultSpace),
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
                  type: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    GermanNumericTextFormatter(),
                  ],
                ),
                SizedBox(width: CustomPadding.defaultSpace),
                // Add DatePicker here if needed
              ],
            ),
            SizedBox(height: CustomPadding.defaultSpace),
            Text(
              AppString.categorie,
              style: CustomTextStyle.regularStyleMedium,
            ),
            SizedBox(height: CustomPadding.mediumSpace),
            // choose category
            CategoriesExpense(onCategorySelected: _onCategorySelected),
            SizedBox(height: CustomPadding.defaultSpace),
            Text(
              AppString.payedBy,
              style: CustomTextStyle.regularStyleMedium,
            ),
            SizedBox(height: CustomPadding.mediumSpace),
            // choosing who payed
            // Dropdown for selecting person who paid bill
            CustomDropDown(
              list: widget.list ?? ['Dir', widget.friendName ?? '**Friend Name**'],
              dropdownWidth: MediaQuery.sizeOf(context).width - 32,
            ),
            SizedBox(height: CustomPadding.defaultSpace),
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
            if (_selectedSplitMethod == SplitMethod.equal)
              EqualSplitWidget(
                amount: _inputNumber,
                names: widget.list ??
                    ['Dir', widget.friendName ?? '**Friend Name**'],
                isGroup: widget.isGroup ?? true,
              ),
            if (_selectedSplitMethod == SplitMethod.percent)
              PercentalSplitWidget(
                amount: _inputNumber,
                names: widget.list ??
                    ['Dir', widget.friendName ?? '**Friend Name**'],
              ),
            if (_selectedSplitMethod == SplitMethod.amount)
              ByAmountSplitWidget(
                names: widget.list ??
                    ['Dir', widget.friendName ?? '**Friend Name**'],
              )
          ],
        ),
      ),
    );
  }
}