import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';


/// Custom Textfield for Split ByAmount option in MethodSplitSelector (AddSplit)
class TextFieldByAmount extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final TextStyle? suffixStyle;
  final TextStyle? inputStyle;
  TextFieldByAmount({
    Key? key,
    required this.controller,
    this.hintText,
    this.suffixStyle,
    this.inputStyle,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: inputStyle ?? TextStyles.headingStyle,
      keyboardType: TextInputType.numberWithOptions(),
      textAlign: TextAlign.center,
      inputFormatters: [
        FilteringTextInputFormatter
            .digitsOnly, // textinput has to have only numbers
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
    );
  }
}
