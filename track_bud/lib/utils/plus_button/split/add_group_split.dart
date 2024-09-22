import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/models/group_model.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/utils/plus_button/add_entry_modal.dart';
import 'package:track_bud/utils/plus_button/split/split_methods/equal/equal_split.dart';
import 'package:track_bud/utils/plus_button/split/split_methods/percent/percent_split.dart';
import 'package:track_bud/utils/plus_button/split/split_methods/split_method_selector.dart';
import 'package:track_bud/utils/button_widgets/dropdown.dart';
import 'package:track_bud/utils/categories/category_expenses.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/enum/split_methods.dart';
import 'package:track_bud/utils/plus_button/split/split_methods/by_amount/by_amount_split.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/textfield.dart';
import 'package:track_bud/utils/textinput_format.dart';

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
  String? _selectedCategory;
  SplitMethod _selectedSplitMethod = SplitMethod.equal;
  double _inputNumber = 0.00;
  bool _isFormValid = false;
  String _payedBy = '';

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_validateForm);
    _amountController.addListener(_onInputChanged);
    _payedBy = widget.memberNames.isNotEmpty ? widget.memberNames.first : '';
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
          _selectedCategory != null;
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

  Future<void> _saveNewGroupSplit() async {
    // Implement group split saving logic here
    // Use widget.selectedGroup and widget.memberNames for processing
  }

  @override
  Widget build(BuildContext context) {
    return AddEntryModal(
      buttonText: AppTexts.addSplit,
      initialChildSize: 0.76,
      maxChildSize: 0.95,
      isButtonEnabled: _isFormValid,
      onButtonPressed: () async {
        await _saveNewGroupSplit();
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
                    style: TextStyles.regularStyleMedium,
                  ),
                  Text(
                    widget.selectedGroup.name,
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
                  hintText: AppTexts.lines,
                  controller: _amountController,
                  width: MediaQuery.of(context).size.width / 3,
                  prefix: Text('-',
                      style: TextStyles.titleStyleMedium
                          .copyWith(fontWeight: TextStyles.fontWeightDefault)),
                  type: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [GermanNumericTextFormatter()],
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
              list: widget.memberNames,
              dropdownWidth: MediaQuery.of(context).size.width - 32,
              onChanged: (String? value) {
                setState(() {
                  _payedBy = value ?? widget.memberNames.first;
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
            /*if (_selectedSplitMethod == SplitMethod.equal)
              EqualSplitWidget(
                amount: _inputNumber,
                users: widget.memberNames
                    .map((name) => UserModel(name: name, userId: ''))
                    .toList(),
                onAmountsChanged: (amounts) {
                  // Handle amounts changed
                },
                isGroup: true,
              ),
            if (_selectedSplitMethod == SplitMethod.percent)
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
