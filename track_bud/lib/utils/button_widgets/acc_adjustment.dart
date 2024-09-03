import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';

class AccAdjustmentWidget extends StatefulWidget {
  final String icon;
  final String name;
  final Widget? widget;
  const AccAdjustmentWidget({super.key, required this.icon, required this.name, this.widget});

  @override
  State<AccAdjustmentWidget> createState() => _AccAdjustmentWidgetState();
}

class _AccAdjustmentWidgetState extends State<AccAdjustmentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: Constants.height,
      padding: EdgeInsets.only(left: CustomPadding.defaultSpace, right: CustomPadding.defaultSpace),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: CustomColor.backgroundPrimary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(widget.icon),
              Gap(
                8,
              ),
              Text(
                widget.name,
                style: TextStyles.regularStyleDefault,
              ),
            ],
          ),
          widget.widget ?? Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}
