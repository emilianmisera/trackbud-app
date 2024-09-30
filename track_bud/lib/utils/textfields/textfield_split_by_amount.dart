import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/textinput_formatters.dart';

/// Custom Textfield for Split ByAmount option in MethodSplitSelector (AddSplit)
class TextFieldByAmount extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final TextStyle? suffixStyle;
  final TextStyle? inputStyle;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  const TextFieldByAmount(
      {super.key, required this.controller, this.hintText, this.suffixStyle, this.inputStyle, this.onChanged, this.focusNode});
  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      style: inputStyle ?? TextStyles.headingStyle.copyWith(color: defaultColorScheme.primary),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textAlign: TextAlign.center,
      focusNode: focusNode,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+([.,]\d{0,2})?')), MaxValueInputFormatter(maxValue: 999999)],
      decoration: InputDecoration(
        hintText: hintText ?? '0.00',
        suffix: Text("€", style: suffixStyle ?? TextStyles.headingStyle.copyWith(color: defaultColorScheme.primary)),
        contentPadding: const EdgeInsets.all(CustomPadding.smallSpace),
        hintStyle: TextStyles.hintStyleHeading.copyWith(color: defaultColorScheme.secondary),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: true,
        fillColor: defaultColorScheme.surface,
        border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
      ),
    );
  }
}
