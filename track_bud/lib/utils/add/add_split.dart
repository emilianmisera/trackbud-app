import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/add/add_entry_modal.dart';
import 'package:track_bud/utils/button_widgets/buttons_widget.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/enum/split_methods.dart';
import 'package:track_bud/utils/split_widget.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widgets.dart';
import 'package:track_bud/utils/textinput_format.dart';

//___________________________________________________________________________________________________________________

// Widget for adding new split
class AddSplit extends StatefulWidget {
  final List<String>? list;
  final String? friendName;
  final bool? isGroup;
  const AddSplit({this.list, this.friendName, this.isGroup, super.key});

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
    return AddEntryModal(
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
                  prefix: Text('-', style: TextStyles.titleStyleMedium.copyWith(fontWeight: TextStyles.fontWeightDefault)),
                  type: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [GermanNumericTextFormatter()],
                ),
                Gap(CustomPadding.defaultSpace),
                // Add DatePicker here if needed
              ],
            ),
            Gap(CustomPadding.defaultSpace),

            Text(AppTexts.categorie, style: TextStyles.regularStyleMedium),
            Gap(CustomPadding.mediumSpace),
            // choose category
            CategoriesExpense(onCategorySelected: _onCategorySelected),
            Gap(CustomPadding.defaultSpace),

            // choosing who payed
            Text(AppTexts.payedBy, style: TextStyles.regularStyleMedium),
            Gap(CustomPadding.mediumSpace),

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
