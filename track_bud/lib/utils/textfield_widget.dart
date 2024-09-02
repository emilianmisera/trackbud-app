// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';

class CustomTextfield extends StatelessWidget {
  final String name;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final bool? autofocus;
  final double? width;
  final Widget? prefix;
  final bool isMultiline;
  final TextInputType? type;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextfield({
    Key? key,
    required this.name,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.autofocus,
    this.width,
    this.prefix,
    this.isMultiline = false,
    this.type,
    this.inputFormatters, // default false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyles.regularStyleMedium,
        ),
        SizedBox(
          height: CustomPadding.mediumSpace,
        ),
        CustomShadow(
          child: Container(
            width: width ?? double.infinity,
            height: isMultiline ? 120 : Constants.height, // choose height of Textfield Box
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              cursorColor: CustomColor.bluePrimary,
              autofocus: autofocus ?? false,
              maxLines: isMultiline ? 3 : 1, // Max 3 Lines if multiline true
              keyboardType: type ?? TextInputType.text,
              inputFormatters: inputFormatters,
              decoration: InputDecoration(
                prefix: Align(
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: prefix,
                ),
                hintText: hintText,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: CustomPadding.defaultSpace,
                  vertical: CustomPadding.contentHeightSpace,
                ),
                hintStyle: TextStyles.hintStyleDefault,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                filled: true,
                fillColor: CustomColor.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

//Custom Shadow Widget which is used for all TextFields and Tiles
class CustomShadow extends StatelessWidget {
  final Widget child;
  const CustomShadow({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SimpleShadow(color: CustomColor.black, opacity: 0.084, offset: Offset(0, 0), sigma: 2, child: child);
  }
}

// Custom Textfield for BankAccountInfo Page & BudgetGoalPage
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
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')), // textinput has to have only numbers or a dot or a comma
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

class SearchTextfield extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool? autofocus;
  final void Function(String) onChanged;

  const SearchTextfield({
    Key? key,
    required this.hintText,
    required this.controller,
    this.autofocus,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: Container(
        width: double.infinity,
        height: Constants.height,
        child: TextFormField(
          controller: controller,
          cursorColor: CustomColor.bluePrimary,
          autofocus: autofocus ?? false,
          decoration: InputDecoration(
            prefixIcon: SvgPicture.asset(
              AssetImport.search,
              fit: BoxFit.scaleDown,
            ),
            hintText: hintText,
            contentPadding: EdgeInsets.symmetric(
              horizontal: CustomPadding.defaultSpace,
              vertical: CustomPadding.contentHeightSpace,
            ),
            hintStyle: TextStyles.hintStyleDefault,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: CustomColor.white,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
            ),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// Custom Textfield for Split ByAmount option
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
        FilteringTextInputFormatter.digitsOnly, // textinput has to have only numbers
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
