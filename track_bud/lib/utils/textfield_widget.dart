// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:track_bud/utils/constants.dart';

class Textfield extends StatelessWidget {
  final String name;
  final String hintText; 
  const Textfield({
    Key? key,
    required this.name,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: CustomTextStyle.regularStyleMedium,),
        SizedBox(height: CustomPadding.mediumSpace,),
        SimpleShadow(
          color: CustomColor.black,
          opacity: 0.084,
          offset: Offset(0, 0),
          sigma: 1,
          child: TextFormField(
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: EdgeInsets.only(left: CustomPadding.defaultSpace, right: CustomPadding.defaultSpace, top: CustomPadding.contentHeightSpace, bottom: CustomPadding.contentHeightSpace),
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
