import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/models/group_model.dart';
import 'package:track_bud/models/group_split_model.dart';
import 'package:track_bud/provider/group_provider.dart';
import 'package:track_bud/services/firestore_service.dart';
import 'package:track_bud/utils/date_picker.dart';
import 'package:track_bud/utils/plus_button/add_entry_modal.dart';
import 'package:track_bud/utils/plus_button/split/split_methods/group_splits/equal_group_split.dart';
import 'package:track_bud/utils/button_widgets/dropdown.dart';
import 'package:track_bud/utils/categories/category_expenses.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/textfield.dart';
import 'package:track_bud/utils/textinput_formatters.dart';
import 'package:uuid/uuid.dart';

/// Widget for adding a group split in an expense tracking application
class AddGroupSplit extends StatefulWidget {
  final GroupModel selectedGroup;
  final List<String> memberNames;
  final String currentUserId;

  const AddGroupSplit({super.key, required this.selectedGroup, required this.memberNames, required this.currentUserId});

  @override
  State<AddGroupSplit> createState() => _AddGroupSplitState();
}

class _AddGroupSplitState extends State<AddGroupSplit> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  late String _selectedCategory = ''; // Selected category for the split
  double _inputNumber = 0.00; // Amount input by the user
  bool _isFormValid = false; // Indicates if the form is valid
  String _paidByUserId = ''; // ID of the user making the payment
  List<String> _selectedMembers = []; // List of selected member IDs for the split
  late Map<String, String> _memberNameToId; // Maps member names to their IDs
  final _focusNodeTitle = FocusNode();
  final _focusNodeAmount = FocusNode();
  DateTime _selectedDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_validateForm);
    _amountController.addListener(_onInputChanged);
    _memberNameToId = _createMemberNameToIdMap(); // Initialize member ID mapping
    _paidByUserId = widget.currentUserId; // Set the current user as the payer
    _selectedMembers = [widget.currentUserId]; // Default to current user
  }

  // Creates a map linking member names to their IDs
  Map<String, String> _createMemberNameToIdMap() {
    return Map.fromIterables(widget.memberNames, widget.selectedGroup.members);
  }

  @override
  void dispose() {
    // Dispose of controllers and remove listeners
    _titleController.removeListener(_validateForm);
    _amountController.removeListener(_onInputChanged);
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // Validates the form inputs based on current state
  void _validateForm() {
    setState(() {
      _isFormValid = _amountController.text.isNotEmpty && _selectedCategory.isNotEmpty && _selectedMembers.isNotEmpty;
    });
  }

  // Updates the input number and validates the form when the amount changes
  void _onInputChanged() {
    setState(() {
      _inputNumber = _parseAmount();
      _validateForm();
    });
  }

  // Parses the input amount from text to double
  double _parseAmount() {
    String amountText = _amountController.text.replaceAll(',', '.');
    return double.tryParse(amountText) ?? 0.0; // Default to 0.0 if parsing fails
  }

  // Handles category selection and updates the state
  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _validateForm();
    });
  }

  // Saves the new group split to Firestore
  Future<void> _saveNewGroupSplit() async {
    final defaultColorScheme = Theme.of(context).colorScheme;
    double totalAmount = _parseAmount(); // Get total amount for the split
    double splitAmount = totalAmount / _selectedMembers.length; // Calculate share amount

    // Create a list of split shares for each member
    List<Map<String, dynamic>> splitShares = _selectedMembers.map((memberId) {
      return {
        'userId': memberId,
        'amount': splitAmount, // Each member's share
      };
    }).toList();

    String transactionTitle = _titleController.text.isNotEmpty ? _titleController.text : _selectedCategory;

    // Create a new GroupSplitModel instance
    GroupSplitModel newSplit = GroupSplitModel(
      groupSplitId: const Uuid().v4(),
      groupId: widget.selectedGroup.groupId,
      totalAmount: totalAmount,
      title: transactionTitle,
      category: _selectedCategory,
      type: 'expense',
      date: Timestamp.fromDate(_selectedDateTime),
      paidBy: _paidByUserId,
      splitShares: splitShares,
    );

    try {
      await _firestoreService.addGroupSplit(newSplit); // Save the split to Firestore
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Group split added successfully', style: TextStyle(color: defaultColorScheme.primary)),
          ),
        );
        // Refresh the group data and invalidate the debts overview cache
        final groupProvider = Provider.of<GroupProvider>(context, listen: false);
        groupProvider.refreshGroupData(widget.selectedGroup.groupId);
        groupProvider.invalidateDebtsOverviewCache(widget.selectedGroup.groupId);
      }
    } catch (e) {
      // Handle errors that occur during saving
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding group split: $e', style: TextStyle(color: defaultColorScheme.primary))),
        );
      }
    }
  }

  // Method to unfocus all text fields
  void _unfocusAll() {
    _focusNodeTitle.unfocus();
    _focusNodeAmount.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: _unfocusAll,
      child: AddEntryModal(
        buttonText: AppTexts.addSplit,
        initialChildSize: 0.76,
        maxChildSize: 0.95,
        isButtonEnabled: _isFormValid,
        onButtonPressed: () async {
          await _saveNewGroupSplit(); // Attempt to save the group split
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
                    Text(AppTexts.newGroupSplit, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
                    Text(widget.selectedGroup.name, style: TextStyles.titleStyleMedium.copyWith(color: defaultColorScheme.primary)),
                  ],
                ),
              ),
              const Gap(CustomPadding.defaultSpace),
              CustomTextfield(
                name: AppTexts.title,
                hintText: AppTexts.hintTitle,
                controller: _titleController,
                focusNode: _focusNodeTitle,
              ),
              const Gap(CustomPadding.defaultSpace),
              Row(
                children: [
                  CustomTextfield(
                    name: AppTexts.amount,
                    hintText: '0.00',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    controller: _amountController,
                    width: MediaQuery.of(context).size.width / 3,
                    prefix: Text(
                      '-',
                      style:
                          TextStyles.titleStyleMedium.copyWith(fontWeight: TextStyles.fontWeightDefault, color: defaultColorScheme.primary),
                    ),
                    suffix: Text('€', style: TextStyle(color: defaultColorScheme.primary)),
                    type: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      // Allow digits and dot or comma as decimal separator
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+([.,]\d{0,2})?'),
                      ),
                      MaxValueInputFormatter(maxValue: 999999),
                    ],
                    focusNode: _focusNodeAmount,
                  ),
                  const Gap(CustomPadding.defaultSpace),
                  // Date Picker
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
                list: widget.memberNames,
                value: widget.memberNames.firstWhere(
                  (name) => _memberNameToId[name] == widget.currentUserId,
                  orElse: () => widget.memberNames.first,
                ),
                dropdownWidth: MediaQuery.of(context).size.width - 32,
                onChanged: (String? value) {
                  setState(() {
                    _paidByUserId = _memberNameToId[value] ?? '';
                  });
                },
              ),
              const Gap(CustomPadding.defaultSpace),
              Text('Verteilung', style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
              const Gap(CustomPadding.mediumSpace),
              EqualGroupSplitWidget(
                amount: _inputNumber,
                members: widget.selectedGroup.members,
                onMembersSelected: (selectedMembers) {
                  setState(() {
                    _selectedMembers = selectedMembers;
                    _validateForm();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
