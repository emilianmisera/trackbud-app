import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';

/// reusbale TextField
class CustomTextfield extends StatelessWidget {
  final String? name;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final bool? autofocus;
  final double? width;
  final Widget? prefix;
  final Widget? suffix;
  final bool isMultiline;
  final TextInputType? type;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final int maxLength;
  final String? errorText;
  final Color? borderColor;

  const CustomTextfield({
    super.key,
    this.name,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.autofocus,
    this.width,
    this.maxLength = 25,
    this.prefix,
    this.suffix,
    this.isMultiline = false,
    this.type,
    this.inputFormatters,
    this.focusNode,
    this.keyboardType,
    this.errorText,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (name != null) Text(name!, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
        const Gap(CustomPadding.mediumSpace),
        CustomShadow(
          child: SizedBox(
            width: width ?? double.infinity,
            height: isMultiline ? 120 : Constants.height,
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              cursorColor: CustomColor.bluePrimary,
              autofocus: autofocus ?? false,
              maxLines: isMultiline ? 3 : 1,
              maxLength: keyboardType == TextInputType.emailAddress ? 100 : maxLength,
              focusNode: focusNode,
              keyboardType: keyboardType ?? TextInputType.text,
              textInputAction: TextInputAction.next,
              inputFormatters: inputFormatters,
              style: TextStyle(color: defaultColorScheme.primary),
              decoration: InputDecoration(
                counterText: '',
                prefix: Align(
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: prefix,
                ),
                suffix: Align(
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: suffix,
                ),
                hintText: hintText,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace, vertical: CustomPadding.contentHeightSpace),
                hintStyle: TextStyles.hintStyleDefault.copyWith(color: defaultColorScheme.secondary),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                filled: true,
                fillColor: defaultColorScheme.surface,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor ?? defaultColorScheme.outline, width: 1.0),
                  borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: CustomColor.red, width: 1.0),
                  borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: CustomColor.red, width: 1.0),
                  borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
                ),
                errorText: errorText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
