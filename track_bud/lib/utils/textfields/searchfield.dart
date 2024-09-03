import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';

/// Displaying a Searchfield
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
              borderRadius:
                  BorderRadius.circular(Constants.contentBorderRadius),
            ),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}