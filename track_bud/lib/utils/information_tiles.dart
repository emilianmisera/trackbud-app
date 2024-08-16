// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/textfield_widget.dart';

class InfoTile extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;
  final double? width;
  const InfoTile({
    Key? key,
    required this.title,
    required this.amount, 
    required this.color, 
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: CustomPadding.contentHeightSpace, horizontal: CustomPadding.defaultSpace),
        width: width ?? MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          color: CustomColor.white,
          borderRadius: BorderRadius.circular(Constants.buttonBorderRadius)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$amount €', style: CustomTextStyle.headingStyle.copyWith(color: color),),
            SizedBox(height: CustomPadding.mediumSpace,),
            Text(title, style: CustomTextStyle.regularStyleDefault,),
          ],
        ),
      ),
    );
  }
}
