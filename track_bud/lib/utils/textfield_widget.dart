// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final bool isMultiline; // Neuer Parameter

  const CustomTextfield({
    Key? key,
    required this.name,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.autofocus,
    this.width,
    this.prefix,
    this.isMultiline = false, // Standardmäßig false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: CustomTextStyle.regularStyleMedium,
        ),
        SizedBox(
          height: CustomPadding.mediumSpace,
        ),
        CustomShadow(
          child: Container(
            width: width ?? double.infinity,
            height: isMultiline ? 120 : 60, // Höhe anpassen basierend auf isMultiline
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              cursorColor: CustomColor.bluePrimary,
              autofocus: autofocus ?? false,
              maxLines: isMultiline ? 3 : 1, // Maximal 3 Zeilen, wenn isMultiline true ist
              decoration: InputDecoration(
                prefixIcon: prefix,
                hintText: hintText,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: CustomPadding.defaultSpace,
                  vertical: CustomPadding.contentHeightSpace,
                ),
                hintStyle: CustomTextStyle.hintStyleDefault,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                filled: true,
                fillColor: CustomColor.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
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
    return SimpleShadow(
        color: CustomColor.black,
        opacity: 0.084,
        offset: Offset(0, 0),
        sigma: 2,
        child: child);
  }
}

// Custom Textfield for BankAccountInfo Page & BudgetGoalPage
class TextFieldAmountOfMoney extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  TextFieldAmountOfMoney({
    Key? key,
    required this.controller, this.hintText,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: TextFormField(
        controller: controller,
        style: CustomTextStyle.headingStyle,
        keyboardType: TextInputType.numberWithOptions(),
        textAlign: TextAlign.center,
        inputFormatters: [
          FilteringTextInputFormatter
              .digitsOnly, // textinput has to have only numbers
        ],
        decoration: InputDecoration(
          hintText: hintText ?? AppString.lines,
          suffix: Text(
            "€",
            style: CustomTextStyle.headingStyle,
          ),
          contentPadding: EdgeInsets.only(
              left: CustomPadding.defaultSpace,
              right: CustomPadding.defaultSpace,
              top: CustomPadding.contentHeightSpace,
              bottom: CustomPadding.contentHeightSpace),
          hintStyle: CustomTextStyle.hintStyleHeading,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: CustomColor.white,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
