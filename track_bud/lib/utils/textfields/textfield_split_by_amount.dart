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
  final ValueChanged<String>? onChanged;
  const TextFieldByAmount({
    super.key,
    required this.controller,
    this.hintText,
    this.suffixStyle,
    this.inputStyle,
    this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      style: inputStyle ?? TextStyles.headingStyle.copyWith(color: defaultColorScheme.primary),
      keyboardType: const TextInputType.numberWithOptions(),
      textAlign: TextAlign.center,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // textinput has to have only numbers
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
    );
  }
}
