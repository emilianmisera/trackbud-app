import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/strings.dart';


/// Custom Textfield for BankAccountInfo Page & BudgetGoalPage
class TextFieldAmountOfMoney extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final TextStyle? suffixStyle;
  final TextStyle? inputStyle;
  TextFieldAmountOfMoney({
    Key? key,
    required this.controller,
    this.hintText,
    this.suffixStyle,
    this.inputStyle,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: TextFormField(
        controller: controller,
        style: TextStyles.headingStyle,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.center,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(
              r'[0-9.,]')), // textinput has to have only numbers or a dot or a comma
        ],
        decoration: InputDecoration(
          hintText: hintText ?? AppTexts.lines,
          suffix: Text(
            "€",
            style: suffixStyle ?? TextStyles.headingStyle,
          ),
          contentPadding: EdgeInsets.only(
              left: CustomPadding.defaultSpace,
              right: CustomPadding.defaultSpace,
              top: CustomPadding.contentHeightSpace,
              bottom: CustomPadding.contentHeightSpace),
          hintStyle: TextStyles.hintStyleHeading,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: CustomColor.white,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
          ),
        ),
      ),
    );
  }
}