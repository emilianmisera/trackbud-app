import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textinput_formatters.dart';

/// Custom Textfield for BankAccountInfo Page & BudgetGoalPage
class TextFieldAmountOfMoney extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final TextStyle? suffixStyle;
  final TextStyle? inputStyle;
  const TextFieldAmountOfMoney({
    super.key,
    required this.controller,
    this.hintText,
    this.suffixStyle,
    this.inputStyle,
  });
  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return CustomShadow(
      child: TextFormField(
        controller: controller,
        style: TextStyles.headingStyle.copyWith(color: defaultColorScheme.primary),
        keyboardType: TextInputType.number, textAlign: TextAlign.center,
        // only numbers with max two decimal places
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+([.,]\d{0,2})?')),
          MaxValueInputFormatter(maxValue: 999999),
        ],
        decoration: InputDecoration(
          hintText: hintText ?? AppTexts.lines,
          suffix: Text(
            "€",
            style: suffixStyle ?? TextStyles.headingStyle.copyWith(color: defaultColorScheme.primary),
          ),
          contentPadding: const EdgeInsets.only(
              left: CustomPadding.defaultSpace,
              right: CustomPadding.defaultSpace,
              top: CustomPadding.contentHeightSpace,
              bottom: CustomPadding.contentHeightSpace),
          hintStyle: TextStyles.hintStyleHeading.copyWith(color: defaultColorScheme.secondary),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: defaultColorScheme.surface,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
          ),
        ),
      ),
    );
  }
}
