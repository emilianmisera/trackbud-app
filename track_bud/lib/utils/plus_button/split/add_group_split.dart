import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/models/group_model.dart';
import 'package:track_bud/models/group_split_model.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/services/firestore_service.dart';
import 'package:track_bud/utils/plus_button/add_entry_modal.dart';
import 'package:track_bud/utils/plus_button/split/split_methods/group_splits/equal_group_split.dart';
import 'package:track_bud/utils/plus_button/split/split_methods/split_method_selector.dart';
import 'package:track_bud/utils/button_widgets/dropdown.dart';
import 'package:track_bud/utils/categories/category_expenses.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/enum/split_methods.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/textfield.dart';
import 'package:uuid/uuid.dart';

class AddGroupSplit extends StatefulWidget {
  final GroupModel selectedGroup;
  final List<String> memberNames;

  const AddGroupSplit({
    Key? key,
    required this.selectedGroup,
    required this.memberNames,
  }) : super(key: key);

  @override
  State<AddGroupSplit> createState() => _AddGroupSplitState();
}

class _AddGroupSplitState extends State<AddGroupSplit> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  String? _selectedCategory;
  SplitMethod _selectedSplitMethod =
      SplitMethod.equal; // Default is equal split
  double _inputNumber = 0.00; // The total input amount
  bool _isFormValid = false; // Tracks if form is valid for submission
  String _payedBy = ''; // Tracks who is paying
  List<String> selectedMemberIds = []; // List of selected members (userIds)
  List<double> _splitAmounts = []; // List of calculated amounts for each user
  List<UserModel>? _groupMembers; // Store fetched members

  @override
  void initState() {
    super.initState();
    // Set listeners to validate form and handle input changes
    _titleController.addListener(_validateForm);
    _amountController.addListener(_onInputChanged);
    // Set default payer as the first member if available
    _payedBy = widget.memberNames.isNotEmpty ? widget.memberNames.first : '';
    selectedMemberIds = List.from(
        widget.selectedGroup.members); // Select all members by default
    _fetchGroupMembers(); // Fetch members once
    debugPrint("Members in selectedGroup: ${widget.selectedGroup.members}");
    debugPrint("Initial selected members: $selectedMemberIds");
  }

  @override
  void dispose() {
    // Remove listeners and dispose of controllers when the widget is removed
    _titleController.removeListener(_validateForm);
    _amountController.removeListener(_onInputChanged);
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // Validates if the form is complete
  void _validateForm() {
    setState(() {
      _isFormValid = _titleController.text.isNotEmpty &&
          _amountController.text.isNotEmpty &&
          _selectedCategory != null; // All fields must be non-empty
      debugPrint("Form validation status: $_isFormValid");
    });
  }

  // Handles changes in the amount input field
  void _onInputChanged() {
    setState(() {
      _inputNumber = _parseAmount(); // Parses the amount to a double
      _validateForm();
      debugPrint("Amount input updated: $_inputNumber");
    });
  }

  // Callback when member selection changes in EqualGroupSplitWidget
  void onGroupSplitMemberSelectionChanged(List<String> newSelectedMemberIds) {
    setState(() {
      selectedMemberIds = newSelectedMemberIds;
      debugPrint("Split amounts updated: $_splitAmounts");
    });
  }

  Future<void> _fetchGroupMembers() async {
    try {
      _groupMembers =
          await _firestoreService.getUsersByIds(widget.selectedGroup.members);
      setState(() {}); // Trigger rebuild to display members
    } catch (e) {
      // Handle error
    }
  }

  // Parses amount input to double, handling commas and dots for decimal values
  double _parseAmount() {
    String amountText = _amountController.text.replaceAll(',', '.');
    double parsedAmount = double.tryParse(amountText) ?? 0.0;
    debugPrint("Parsed amount: $parsedAmount");
    return parsedAmount;
  }

  // Handles category selection change
  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _validateForm(); // Re-validate form
      debugPrint("Selected category: $_selectedCategory");
    });
  }

  // Saves the new group split to Firestore
  Future<void> _saveNewGroupSplit() async {
    // Calculate split amount based on SELECTED members
    final splitAmount = _inputNumber / selectedMemberIds.length;
    debugPrint("The memberIds: $selectedMemberIds");
    debugPrint("Saving group split with splitAmount: $splitAmount");

    final groupSplit = GroupSplitModel(
      groupSplitId: const Uuid().v4(),
      groupId: widget.selectedGroup.groupId,
      totalAmount: _inputNumber,
      title: _titleController.text,
      category: _selectedCategory!,
      type: 'expense',
      date: Timestamp.fromDate(DateTime.now()),
      paidBy: _payedBy,
      splitShares: selectedMemberIds
          .map((memberId) => {
                'memberId': memberId,
                'amountOwed':
                    splitAmount, // Use the calculated splitAmount here
              })
          .toList(),
    );

    try {
      await _firestoreService.saveGroupSplit(groupSplit);
      debugPrint("Group split saved successfully");
    } catch (e) {
      debugPrint("Error saving group split: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return AddEntryModal(
      buttonText: AppTexts.addSplit,
      initialChildSize: 0.76,
      maxChildSize: 0.95,
      isButtonEnabled:
          _isFormValid, // Button is enabled only if the form is valid
      onButtonPressed: () async {
        await _saveNewGroupSplit(); // No need to pass selectedMemberIds here
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
                    AppTexts.newGroupSplit,
                    style: TextStyles.regularStyleMedium
                        .copyWith(color: defaultColorScheme.primary),
                  ),
                  Text(
                    widget.selectedGroup.name,
                    style: TextStyles.titleStyleMedium
                        .copyWith(color: defaultColorScheme.primary),
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
                  width: MediaQuery.of(context).size.width / 3,
                  prefix: Text(
                    '- ',
                    style: TextStyles.titleStyleMedium
                        .copyWith(fontWeight: TextStyles.fontWeightDefault),
                  ),
                  suffix: const Text('€'),
                  type: const TextInputType.numberWithOptions(decimal: true),
                ),
                const Gap(CustomPadding.defaultSpace),
              ],
            ),
            const Gap(CustomPadding.defaultSpace),
            Text(AppTexts.categorie,
                style: TextStyles.regularStyleMedium
                    .copyWith(color: defaultColorScheme.primary)),
            const Gap(CustomPadding.mediumSpace),
            CategoriesExpense(onCategorySelected: _onCategorySelected),
            const Gap(CustomPadding.defaultSpace),
            Text(AppTexts.payedBy,
                style: TextStyles.regularStyleMedium
                    .copyWith(color: defaultColorScheme.primary)),
            const Gap(CustomPadding.mediumSpace),
            CustomDropDown(
              list: widget.memberNames,
              dropdownWidth: MediaQuery.of(context).size.width - 32,
              onChanged: (String? value) {
                setState(() {
                  _payedBy = value ?? widget.memberNames.first;
                  debugPrint("Payer changed: $_payedBy");
                });
              },
            ),
            const Gap(CustomPadding.defaultSpace),
            SplitMethodSelector(
              selectedMethod: _selectedSplitMethod,
              onSplitMethodChanged: (SplitMethod method) {
                setState(() {
                  _selectedSplitMethod = method;
                  debugPrint("Selected split method: $_selectedSplitMethod");
                });
              },
            ),
            const Gap(CustomPadding.defaultSpace),
            if (_selectedSplitMethod == SplitMethod.equal)
              _groupMembers != null // Check if members are fetched
                  ? EqualGroupSplitWidget(
                      amount: _inputNumber,
                      users:
                          _groupMembers!, // Assuming _groupMembers is a List<UserModel>
                      selectedMemberIds: selectedMemberIds,
                      onMemberSelectionChanged:
                          onGroupSplitMemberSelectionChanged, // Pass the callback
                    )
                  : const CircularProgressIndicator(), // Or show loading indicator
            /* if (_selectedSplitMethod == SplitMethod.percent)
              PercentalSplitWidget(
                amount: _inputNumber,
                users: widget.memberNames
                    .map((name) => UserModel(name: name, userId: ''))
                    .toList(),
                onAmountsChanged: (amounts) {
                  // Handle amounts changed
                },
                isGroup: true,
              ),
            if (_selectedSplitMethod == SplitMethod.amount)
              ByAmountSplitWidget(
                users: widget.memberNames
                    .map((name) => UserModel(name: name, userId: ''))
                    .toList(),
                onAmountsChanged: (amounts) {
                  // Handle amounts changed
                },
                isGroup: true,
              ),*/
          ],
        ),
      ),
    );
  }
}
