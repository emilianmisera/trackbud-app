import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/models/friend_split_model.dart';
import 'package:track_bud/services/firestore_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/date_picker.dart';
import 'package:track_bud/utils/plus_button/add_entry_modal.dart';
import 'package:track_bud/utils/plus_button/split/split_methods/friend_splits/by_amount/by_amount_split.dart';
import 'package:track_bud/utils/plus_button/split/split_methods/friend_splits/equal/equal_friend_split.dart';
import 'package:track_bud/utils/plus_button/split/split_methods/friend_splits/percent/percent_split.dart';
import 'package:track_bud/utils/plus_button/split/split_methods/split_method_selector.dart';
import 'package:track_bud/utils/button_widgets/dropdown.dart';
import 'package:track_bud/utils/categories/category_expenses.dart';
import 'package:track_bud/utils/enum/split_methods.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/textfield.dart';
import 'package:track_bud/utils/textinput_formatters.dart';
import 'package:uuid/uuid.dart';

/// This Widget is the Sheet, when you want to add a new Friend Split
class AddFriendSplit extends StatefulWidget {
  final UserModel selectedFriend;
  final UserModel currentUser;

  const AddFriendSplit({required this.selectedFriend, required this.currentUser, super.key});

  @override
  State<AddFriendSplit> createState() => _AddFriendSplitState();
}

class _AddFriendSplitState extends State<AddFriendSplit> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedCategory = '';
  SplitMethod _selectedSplitMethod = SplitMethod.equal;
  double _inputNumber = 0.00;
  bool _isFormValid = false;
  String _payedBy = '';
  final FirestoreService _firestoreService = FirestoreService();
  List<double> _splitAmounts = [0.0, 0.0];
  final _focusNodeTitle = FocusNode();
  final _focusNodeAmount = FocusNode();
  String _splitSumValidationMessage = '';
  List<FocusNode> _byAmountFocusNodes = [];
  DateTime _selectedDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Add listeners to validate form inputs
    _titleController.addListener(_validateForm);
    _amountController.addListener(_onInputChanged);
    _payedBy = widget.currentUser.name;
    // Create focus nodes for amount input fields
    _byAmountFocusNodes = List.generate(2, (_) => FocusNode());
  }

  @override
  void dispose() {
    // Remove listeners to prevent memory leaks
    _titleController.removeListener(_validateForm);
    _amountController.removeListener(_onInputChanged);
    _titleController.dispose();
    _amountController.dispose();

    // Dispose of the focus nodes
    for (var focusNode in _byAmountFocusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  // Validates the form and checks the split amounts for consistency
  void _validateForm() {
    setState(() {
      final totalAmount = _parseAmount();
      final sumOfAmounts = _splitAmounts.reduce((a, b) => a + b);

      if (_selectedSplitMethod == SplitMethod.amount) {
        // For "by amount" splits, check that the sum of split amounts equals the total
        _isFormValid = _amountController.text.isNotEmpty &&
            _selectedCategory.isNotEmpty &&
            totalAmount == sumOfAmounts &&
            _splitAmounts.every((amount) => amount > 0);

        // Update the validation message to reflect any discrepancies
        _updateSplitSumValidationMessage(totalAmount, sumOfAmounts);
      } else {
        // For other split methods, only check if required fields are filled
        _splitSumValidationMessage = AppTexts.addSplit;
        _isFormValid = _amountController.text.isNotEmpty && _selectedCategory.isNotEmpty;
      }
    });
  }

  // Updates the message that indicates any issues with the split amounts
  void _updateSplitSumValidationMessage(double totalAmount, double sumOfAmounts) {
    if (totalAmount > sumOfAmounts) {
      _splitSumValidationMessage = '${(totalAmount - sumOfAmounts).toStringAsFixed(2)}€ fehlen noch';
    } else if (totalAmount < sumOfAmounts) {
      _splitSumValidationMessage = '${(sumOfAmounts - totalAmount).toStringAsFixed(2)}€ zu viel';
    } else {
      _splitSumValidationMessage = ''; // Clear the message if amounts are correct
    }
  }

  // Handles changes in the amount input field and triggers validation
  void _onInputChanged() {
    setState(() {
      _inputNumber = _parseAmount();
      _validateForm();
    });
  }

  // Updates the selected category and validates the form
  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _validateForm();
    });
  }

  // Parses the amount entered in the text field to a double
  double _parseAmount() {
    String amountText = _amountController.text.replaceAll(',', '.');
    return double.tryParse(amountText) ?? 0.0; // Default to 0.0 if parsing fails
  }

  // Saves the new friend split entry to Firestore
  Future<void> _saveNewFriendSplit() async {
    final defaultColorScheme = Theme.of(context).colorScheme;
    double totalAmount = _parseAmount();

    double creditorAmount, debtorAmount;

    if (_selectedSplitMethod == SplitMethod.equal) {
      // For equal splits, divide the total amount between the two friends
      _splitAmounts = [totalAmount / 2, totalAmount / 2];
    }

    // Determine the creditor (the person receiving the payment)
    if (_payedBy == widget.currentUser.name) {
      // Current user is the creditor
      creditorAmount = totalAmount;
      debtorAmount = _splitAmounts[1]; // The selected friend owes this amount
    } else {
      // The selected friend is the creditor
      creditorAmount = totalAmount;
      debtorAmount = _splitAmounts[0]; // Current user owes this amount
    }

    String transactionTitle = _titleController.text.isNotEmpty ? _titleController.text : _selectedCategory;

    // Create a new FriendSplitModel instance with the entered data
    FriendSplitModel newSplit = FriendSplitModel(
      splitId: const Uuid().v4(),
      creditorId: _payedBy == widget.currentUser.name ? widget.currentUser.userId : widget.selectedFriend.userId,
      debtorId: _payedBy == widget.currentUser.name ? widget.selectedFriend.userId : widget.currentUser.userId,
      creditorAmount: creditorAmount,
      debtorAmount: debtorAmount,
      title: transactionTitle,
      type: 'expense',
      category: _selectedCategory,
      date: Timestamp.fromDate(_selectedDateTime),
      status: 'pending',
    );

    try {
      // Attempt to save the new split entry to Firestore
      await _firestoreService.addFriendSplit(newSplit);
    } catch (e) {
      if (mounted) {
        // Show a snackbar if saving fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Hinzufügen des Freundes-Splits fehlgeschlagen: $e',
                  style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary))),
        );
      }
    }
  }

  // Unfocuses all input fields
  void _unfocusAll() {
    _focusNodeTitle.unfocus();
    _focusNodeAmount.unfocus();
    for (var focusNode in _byAmountFocusNodes) {
      focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: _unfocusAll,
      child: AddEntryModal(
        buttonText: _splitSumValidationMessage.isNotEmpty ? _splitSumValidationMessage : AppTexts.addSplit,
        initialChildSize: 0.76,
        maxChildSize: 0.95,
        isButtonEnabled: _isFormValid,
        onButtonPressed: () async {
          await _saveNewFriendSplit();
          if (context.mounted) Navigator.pop(context);
        },
        child: Padding(
          padding: CustomPadding.screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(AppTexts.newFriendSplit, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
                    Text(widget.selectedFriend.name, style: TextStyles.titleStyleMedium.copyWith(color: defaultColorScheme.primary)),
                  ],
                ),
              ),
              const Gap(CustomPadding.defaultSpace),
              CustomTextfield(name: AppTexts.title, hintText: AppTexts.hintTitle, controller: _titleController, focusNode: _focusNodeTitle),
              const Gap(CustomPadding.defaultSpace),
              Row(
                children: [
                  CustomTextfield(
                    name: AppTexts.amount,
                    hintText: '0.00',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    controller: _amountController,
                    width: MediaQuery.sizeOf(context).width / 3,
                    prefix: Text('-',
                        style: TextStyles.titleStyleMedium
                            .copyWith(fontWeight: TextStyles.fontWeightDefault, color: defaultColorScheme.primary)),
                    suffix: Text('€', style: TextStyle(color: defaultColorScheme.primary)),
                    type: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      // Allow only numbers, and a point or comma as decimal separator
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+([.,]\d{0,2})?'),
                      ),
                      MaxValueInputFormatter(maxValue: 999999),
                    ],
                    focusNode: _focusNodeAmount,
                  ),
                  const Gap(CustomPadding.defaultSpace),
                  Expanded(
                    child: DatePicker(
                        onDateTimeChanged: (dateTime) => setState(() => _selectedDateTime = dateTime), initialDateTime: DateTime.now()),
                  ),
                ],
              ),
              const Gap(CustomPadding.defaultSpace),
              Text(AppTexts.categorie, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
              const Gap(CustomPadding.mediumSpace),
              CategoriesExpense(onCategorySelected: _onCategorySelected),
              const Gap(CustomPadding.defaultSpace),
              Text(AppTexts.payedBy, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
              const Gap(CustomPadding.mediumSpace),
              CustomDropDown(
                list: [widget.currentUser.name, widget.selectedFriend.name],
                dropdownWidth: MediaQuery.sizeOf(context).width - 32,
                onChanged: (String? value) {
                  setState(() {
                    _payedBy = value ?? widget.currentUser.name;
                  });
                },
              ),
              const Gap(CustomPadding.defaultSpace),
              SplitMethodSelector(
                selectedMethod: _selectedSplitMethod,
                onSplitMethodChanged: (SplitMethod method) {
                  setState(() {
                    _selectedSplitMethod = method;
                    // Reset split amounts to zero when the split method changes
                    _splitAmounts = [0.0, 0.0];
                    _validateForm(); // Revalidate the form after method change
                  });
                },
              ),
              const Gap(CustomPadding.defaultSpace),
              // Display the appropriate widget for the selected split method
              if (_selectedSplitMethod == SplitMethod.equal)
                EqualFriendSplitWidget(
                  amount: _inputNumber,
                  users: [widget.currentUser, widget.selectedFriend],
                  onAmountsChanged: (amounts) {
                    setState(() {
                      _splitAmounts = amounts;
                      _validateForm(); // Revalidate after amount changes
                    });
                  },
                ),
              if (_selectedSplitMethod == SplitMethod.percent)
                PercentalSplitWidget(
                  amount: _inputNumber,
                  users: [widget.currentUser, widget.selectedFriend],
                  onAmountsChanged: (amounts) {
                    setState(() {
                      _splitAmounts = amounts;
                      _validateForm(); // Revalidate after amount changes
                    });
                  },
                ),
              if (_selectedSplitMethod == SplitMethod.amount)
                ByAmountSplitWidget(
                  users: [widget.currentUser, widget.selectedFriend],
                  onAmountsChanged: (amounts) {
                    setState(() {
                      _splitAmounts = amounts;
                      _validateForm(); // Revalidate after amount changes
                    });
                  },
                  focusNodes: _byAmountFocusNodes, // Pass focus nodes to ByAmountSplitWidget for better focus management
                ),
            ],
          ),
        ),
      ),
    );
  }
}
