import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';

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
        Text(name, style: TextStyles.regularStyleMedium),
        Gap(CustomPadding.mediumSpace),
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
                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
