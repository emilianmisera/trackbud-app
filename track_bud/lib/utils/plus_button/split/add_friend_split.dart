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
import 'package:uuid/uuid.dart';

class AddFriendSplit extends StatefulWidget {
  final UserModel selectedFriend;
  final UserModel currentUser;

  const AddFriendSplit({
    required this.selectedFriend,
    required this.currentUser,
    super.key,
  });

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
  //store the split sum validation message
  String _splitSumValidationMessage = '';
  //list to store focus nodes for ByAmountTiles
  List<FocusNode> _byAmountFocusNodes = [];
  DateTime _selectedDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_validateForm);
    _amountController.addListener(_onInputChanged);
    _payedBy = widget.currentUser.name;

    // Initialize focus nodes for ByAmountTiles
    _byAmountFocusNodes = List.generate(2, (_) => FocusNode());
  }

  @override
  void dispose() {
    _titleController.removeListener(_validateForm);
    _amountController.removeListener(_onInputChanged);
    _titleController.dispose();
    _amountController.dispose();

    // Dispose focus nodes for ByAmountTiles
    for (var focusNode in _byAmountFocusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  // validate the form and check split amounts
  void _validateForm() {
    setState(() {
      final totalAmount = _parseAmount();
      final sumOfAmounts = _splitAmounts.reduce((a, b) => a + b);

      if (_selectedSplitMethod == SplitMethod.amount) {
        // For "by amount" split, check if the sum of amounts matches the total
        // and ensure that both split amounts are greater than zero
        _isFormValid = _titleController.text.isNotEmpty &&

            _amountController.text.isNotEmpty &&
            _selectedCategory.isNotEmpty &&
            totalAmount == sumOfAmounts &&
            _splitAmounts.every((amount) => amount > 0);

        // Update the validation message
        _updateSplitSumValidationMessage(totalAmount, sumOfAmounts);
      } else {

        _isFormValid = _amountController.text.isNotEmpty && _selectedCategory.isNotEmpty;
      }
    });
  }

  // update the split sum validation message
  void _updateSplitSumValidationMessage(double totalAmount, double sumOfAmounts) {
    if (totalAmount > sumOfAmounts) {
      _splitSumValidationMessage = '${(totalAmount - sumOfAmounts).toStringAsFixed(2)}€ fehlen noch';
    } else if (totalAmount < sumOfAmounts) {
      _splitSumValidationMessage = '${(sumOfAmounts - totalAmount).toStringAsFixed(2)}€ zu viel';
    } else {
      _splitSumValidationMessage = '';
    }
  }

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

  Future<void> _saveNewFriendSplit() async {
    final defaultColorScheme = Theme.of(context).colorScheme;
    double totalAmount = _parseAmount();

    double creditorAmount, debtorAmount;

    if (_selectedSplitMethod == SplitMethod.equal) {
      // Ensure _splitAmounts has exactly two elements for friend splits
      _splitAmounts = [totalAmount / 2, totalAmount / 2];
    }

    // Determine who is the creditor (payer)
    if (_payedBy == widget.currentUser.name) {
      // Current user is the creditor (payer)
      creditorAmount = totalAmount;
      debtorAmount = _splitAmounts[1]; // Friend owes part of the split
    } else {
      // Friend is the creditor (payer)
      creditorAmount = totalAmount;
      debtorAmount = _splitAmounts[0]; // Current user owes part of the split
    }

    String transactionTitle = _titleController.text.isNotEmpty ? _titleController.text : _selectedCategory;

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
      await _firestoreService.addFriendSplit(newSplit);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Hinzufügen des Freundes-Splits fehlgeschlagen: $e',
                  style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary))),
        );
      }
    }
  }

  // unfocus all text fields
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
                    hintText: '00.00',
                    controller: _amountController,
                    width: MediaQuery.sizeOf(context).width / 3,
                    prefix: Text('-',
                        style: TextStyles.titleStyleMedium
                            .copyWith(fontWeight: TextStyles.fontWeightDefault, color: defaultColorScheme.primary)),
                    suffix: Text('€', style: TextStyle(color: defaultColorScheme.primary)),
                    type: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      // Allows numbers and point or comma as decimal separator
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+([.,]\d{0,2})?'))
                    ],
                    focusNode: _focusNodeAmount,

                  ),
                  const Gap(CustomPadding.defaultSpace),
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
                    // Reset split amounts when changing split method
                    _splitAmounts = [0.0, 0.0];
                    _validateForm(); // Revalidate when the split method changes
                  });
                },
              ),
              const Gap(CustomPadding.defaultSpace),
              // Display the appropriate split widget based on _selectedSplitMethod
              if (_selectedSplitMethod == SplitMethod.equal)
                EqualFriendSplitWidget(
                  amount: _inputNumber,
                  users: [widget.currentUser, widget.selectedFriend],
                  onAmountsChanged: (amounts) {
                    setState(() {
                      _splitAmounts = amounts;
                      _validateForm(); // Revalidate when amounts change
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
                      _validateForm(); // Revalidate when amounts change
                    });
                  },
                ),
              if (_selectedSplitMethod == SplitMethod.amount)
                ByAmountSplitWidget(
                  users: [widget.currentUser, widget.selectedFriend],
                  onAmountsChanged: (amounts) {
                    setState(() {
                      _splitAmounts = amounts;
                      _validateForm(); // Revalidate when amounts change
                    });
                  },
                  focusNodes: _byAmountFocusNodes, // Pass focus nodes to ByAmountSplitWidget
                ),
            ],
          ),
        ),
      ),
    );
  }
}
