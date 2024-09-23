import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/models/friend_split_model.dart';
import 'package:track_bud/services/firestore_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/plus_button/add_entry_modal.dart';
import 'package:track_bud/utils/plus_button/split/split_methods/by_amount/by_amount_split.dart';
import 'package:track_bud/utils/plus_button/split/split_methods/equal/equal_split.dart';
import 'package:track_bud/utils/plus_button/split/split_methods/percent/percent_split.dart';
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
  late String _selectedCategory;
  SplitMethod _selectedSplitMethod = SplitMethod.equal;
  double _inputNumber = 0.00;
  bool _isFormValid = false;
  String _payedBy = '';
  final FirestoreService _firestoreService = FirestoreService();
  List<double> _splitAmounts = [0.0, 0.0];

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_validateForm);
    _amountController.addListener(_onInputChanged);
    _payedBy = widget.currentUser.name;
  }

  @override
  void dispose() {
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
          _selectedCategory.isNotEmpty;
    });
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
    double totalAmount = _parseAmount();

    double creditorAmount, debtorAmount;

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

    FriendSplitModel newSplit = FriendSplitModel(
      splitId: const Uuid().v4(),
      creditorId: _payedBy == widget.currentUser.name
          ? widget.currentUser.userId
          : widget.selectedFriend.userId,
      debtorId: _payedBy == widget.currentUser.name
          ? widget.selectedFriend.userId
          : widget.currentUser.userId,
      creditorAmount: creditorAmount,
      debtorAmount: debtorAmount,
      title: _titleController.text,
      type: 'expense',
      category: _selectedCategory,
      date: Timestamp.fromDate(DateTime.now()),
      status: 'pending',
    );

    try {
      await _firestoreService.addFriendSplit(newSplit);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Friend split added successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding friend split: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AddEntryModal(
      buttonText: AppTexts.addSplit,
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
                  Text(
                    AppTexts.newFriendSplit,
                    style: TextStyles.regularStyleMedium,
                  ),
                  Text(
                    widget.selectedFriend.name,
                    style: TextStyles.titleStyleMedium,
                  ),
                ],
              ),
            ),
            const Gap(CustomPadding.defaultSpace),
            CustomTextfield(
              name: AppTexts.title,
              hintText: AppTexts.hintTitle,
              controller: _titleController,
            ),
            const Gap(CustomPadding.defaultSpace),
            Row(
              children: [
                CustomTextfield(
                  name: AppTexts.amount,
                  hintText: '00.00',
                  controller: _amountController,
                  width: MediaQuery.sizeOf(context).width / 3,
                  prefix: Text(
                    '- ',
                    style: TextStyles.titleStyleMedium
                        .copyWith(fontWeight: TextStyles.fontWeightDefault),
                  ),
                  suffix: const Text('€'),
                  type: const TextInputType.numberWithOptions(decimal: true),
                  //inputFormatters: [GermanNumericTextFormatter()],
                ),
                const Gap(CustomPadding.defaultSpace),
              ],
            ),
            const Gap(CustomPadding.defaultSpace),
            Text(AppTexts.categorie, style: TextStyles.regularStyleMedium),
            const Gap(CustomPadding.mediumSpace),
            CategoriesExpense(onCategorySelected: _onCategorySelected),
            const Gap(CustomPadding.defaultSpace),
            Text(AppTexts.payedBy, style: TextStyles.regularStyleMedium),
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
                });
              },
            ),
            const Gap(CustomPadding.defaultSpace),
            // Display the appropriate split widget based on _selectedSplitMethod
            if (_selectedSplitMethod == SplitMethod.equal)
              EqualSplitWidget(
                amount: _inputNumber,
                users: [widget.currentUser, widget.selectedFriend],
                onAmountsChanged: (amounts) {
                  setState(() {
                    _splitAmounts = amounts;
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
                  });
                },
              ),
            if (_selectedSplitMethod == SplitMethod.amount)
              ByAmountSplitWidget(
                users: [widget.currentUser, widget.selectedFriend],
                onAmountsChanged: (amounts) {
                  setState(() {
                    _splitAmounts = amounts;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}
