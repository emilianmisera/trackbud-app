import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/models/group_model.dart';
import 'package:track_bud/models/group_split_model.dart';
import 'package:track_bud/provider/group_provider.dart';
import 'package:track_bud/services/firestore_service.dart';
import 'package:track_bud/utils/plus_button/add_entry_modal.dart';
import 'package:track_bud/utils/plus_button/split/split_methods/group_splits/equal_group_split.dart';
import 'package:track_bud/utils/button_widgets/dropdown.dart';
import 'package:track_bud/utils/categories/category_expenses.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/textfield.dart';
import 'package:uuid/uuid.dart';

// Widget for adding a group split in an expense tracking application
class AddGroupSplit extends StatefulWidget {
  final GroupModel selectedGroup; // Group selected for the split
  final List<String> memberNames; // List of member names in the group
  final String currentUserId; // ID of the current user

  const AddGroupSplit({
    super.key,
    required this.selectedGroup,
    required this.memberNames,
    required this.currentUserId,
  });

  @override
  State<AddGroupSplit> createState() => _AddGroupSplitState();
}

class _AddGroupSplitState extends State<AddGroupSplit> {
  // Controllers for text fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  String? _selectedCategory; // Selected category for the split
  double _inputNumber = 0.00; // Amount input by the user
  bool _isFormValid = false; // Indicates if the form is valid
  String _paidByUserId = ''; // ID of the user making the payment
  List<String> _selectedMembers =
      []; // List of selected member IDs for the split
  late Map<String, String> _memberNameToId; // Maps member names to their IDs

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_validateForm);
    _amountController.addListener(_onInputChanged);
    _memberNameToId =
        _createMemberNameToIdMap(); // Initialize member ID mapping
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
      _isFormValid = _titleController.text.isNotEmpty &&
          _amountController.text.isNotEmpty &&
          _selectedCategory != null &&
          _selectedMembers.isNotEmpty; // Must select at least one member
    });
  }

  // Updates the input number and validates the form when the amount changes
  void _onInputChanged() {
    setState(() {
      _inputNumber = _parseAmount(); // Update the input number
      _validateForm(); // Validate the form after input change
    });
  }

  // Parses the input amount from text to double
  double _parseAmount() {
    String amountText = _amountController.text.replaceAll(',', '.');
    return double.tryParse(amountText) ??
        0.0; // Default to 0.0 if parsing fails
  }

  // Handles category selection and updates the state
  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category; // Update the selected category
      _validateForm(); // Re-validate the form
    });
  }

  // Saves the new group split to Firestore
  Future<void> _saveNewGroupSplit() async {
    double totalAmount = _parseAmount(); // Get total amount for the split
    double splitAmount =
        totalAmount / _selectedMembers.length; // Calculate share amount

    // Create a list of split shares for each member
    List<Map<String, dynamic>> splitShares = _selectedMembers.map((memberId) {
      return {
        'userId': memberId,
        'amount': splitAmount, // Each member's share
      };
    }).toList();

    // Create a new GroupSplitModel instance
    GroupSplitModel newSplit = GroupSplitModel(
      groupSplitId: const Uuid().v4(), // Generate a unique ID
      groupId: widget.selectedGroup.groupId,
      totalAmount: totalAmount,
      title: _titleController.text,
      category: _selectedCategory!,
      type: 'expense',
      date: Timestamp.fromDate(DateTime.now()), // Current date
      paidBy: _paidByUserId,
      splitShares: splitShares, // Share details
    );

    try {
      await _firestoreService
          .addGroupSplit(newSplit); // Save the split to Firestore
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Group split added successfully'),
          ),
        );
        // Refresh the group data and invalidate the debts overview cache
        final groupProvider =
            Provider.of<GroupProvider>(context, listen: false);
        groupProvider.refreshGroupData(widget.selectedGroup.groupId);
        groupProvider
            .invalidateDebtsOverviewCache(widget.selectedGroup.groupId);
      }
    } catch (e) {
      // Handle errors that occur during saving
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding group split: $e')),
        );
      }
    }
  }

  // Builds the header section with group information
  Widget _buildHeader(ColorScheme colorScheme) {
    return Center(
      child: Column(
        children: [
          Text(
            AppTexts.newGroupSplit,
            style: TextStyles.regularStyleMedium
                .copyWith(color: colorScheme.primary),
          ),
          Text(
            widget.selectedGroup.name,
            style: TextStyles.titleStyleMedium
                .copyWith(color: colorScheme.primary),
          ),
        ],
      ),
    );
  }

  // Builds the title input field
  Widget _buildTitleInput() {
    return CustomTextfield(
      name: AppTexts.title,
      hintText: AppTexts.hintTitle,
      controller: _titleController,
    );
  }

  // Builds the amount input field with prefix and suffix
  Widget _buildAmountInput(ColorScheme colorScheme) {
    return Row(
      children: [
        CustomTextfield(
          name: AppTexts.amount,
          hintText: '00.00',
          controller: _amountController,
          width: MediaQuery.of(context).size.width / 3,
          prefix: Text(
            '-',
            style: TextStyles.titleStyleMedium.copyWith(
              fontWeight: TextStyles.fontWeightDefault,
              color: colorScheme.primary,
            ),
          ),
          suffix: const Text('€'),
          type: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            // Erlaubt Zahlen und Punkt oder Komma als Dezimaltrennzeichen
            FilteringTextInputFormatter.allow(
              RegExp(r'^\d+([.,]\d{0,2})?'),
            ),
          ],
        ),
      ],
    );
  }

  // Builds the category selection section
  Widget _buildCategorySelection(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTexts.categorie,
          style: TextStyles.regularStyleMedium
              .copyWith(color: colorScheme.primary),
        ),
        const Gap(CustomPadding.mediumSpace),
        CategoriesExpense(onCategorySelected: _onCategorySelected),
      ],
    );
  }

  // Builds the paying member selection dropdown
  Widget _buildPayingMemberSelection(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTexts.payedBy,
          style: TextStyles.regularStyleMedium
              .copyWith(color: colorScheme.primary),
        ),
        const Gap(CustomPadding.mediumSpace),
        CustomDropDown(
          list: widget.memberNames,
          value: widget.memberNames.firstWhere(
            (name) => _memberNameToId[name] == widget.currentUserId,
            orElse: () => widget.memberNames.first,
          ), // Default to current user's name
          dropdownWidth: MediaQuery.of(context).size.width - 32,
          onChanged: (String? value) {
            setState(() {
              _paidByUserId =
                  _memberNameToId[value] ?? ''; // Update the payer ID
            });
          },
        ),
      ],
    );
  }

  // Builds the members selection section for the split
  Widget _buildMembersSelection(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verteilung',
          style: TextStyles.regularStyleMedium
              .copyWith(color: colorScheme.primary),
        ),
        const Gap(CustomPadding.mediumSpace),
        EqualGroupSplitWidget(
          amount: _inputNumber,
          members: widget.selectedGroup.members,
          onMembersSelected: (selectedMembers) {
            setState(() {
              _selectedMembers =
                  selectedMembers; // Update selected members list
              _validateForm(); // Re-validate form
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme =
        Theme.of(context).colorScheme; // Get current color scheme

    return AddEntryModal(
      buttonText: AppTexts.addSplit,
      initialChildSize: 0.76,
      maxChildSize: 0.95,
      isButtonEnabled: _isFormValid, // Enable button based on form validity
      onButtonPressed: () async {
        await _saveNewGroupSplit(); // Attempt to save the group split
        if (context.mounted) Navigator.pop(context); // Close the modal
      },
      child: Padding(
        padding: CustomPadding.screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(defaultColorScheme),
            const Gap(CustomPadding.defaultSpace),
            _buildTitleInput(),
            const Gap(CustomPadding.defaultSpace),
            _buildAmountInput(defaultColorScheme),
            const Gap(CustomPadding.defaultSpace),
            _buildCategorySelection(defaultColorScheme),
            const Gap(CustomPadding.defaultSpace),
            _buildPayingMemberSelection(defaultColorScheme),
            const Gap(CustomPadding.defaultSpace),
            _buildMembersSelection(defaultColorScheme),
          ],
        ),
      ),
    );
  }
}
