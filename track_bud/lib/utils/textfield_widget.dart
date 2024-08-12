// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';

class Textfield extends StatelessWidget {
  final String name;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;

  const Textfield({
    Key? key,
    required this.name,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
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
        Shadow(
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            cursorColor: CustomColor.bluePrimary,
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: EdgeInsets.only(
                  left: CustomPadding.defaultSpace,
                  right: CustomPadding.defaultSpace,
                  top: CustomPadding.contentHeightSpace,
                  bottom: CustomPadding.contentHeightSpace),
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
        )
      ],
    );
  }
}

//Custom Shadow Widget which is used for all TextFields and Tiles
class Shadow extends StatelessWidget {
  final Widget child;
  const Shadow({super.key, required this.child});

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
  const TextFieldAmountOfMoney({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shadow(
      child: TextFormField(
        controller: controller,
        style: CustomTextStyle.headingStyle,
        keyboardType: TextInputType.numberWithOptions(),
        textAlign: TextAlign.center,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly, // textinput has to have only numbers
        ],
        decoration: InputDecoration(
          hintText: AppString.lines,
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
