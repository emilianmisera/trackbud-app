import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';

class AccAdjustmentButton extends StatelessWidget {
  final String icon;
  final String name;
  final void Function() onPressed;
  final Widget? widget;
  const AccAdjustmentButton(
      {super.key,
      required this.icon,
      required this.name,
      required this.onPressed,
      this.widget});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: SvgPicture.asset(icon),
      label: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: CustomTextStyle.regularStyleDefault,
          ),
          widget ?? Icon(Icons.arrow_forward_ios)
        ],
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColor.backgroundPrimary,
        foregroundColor: CustomColor.black,
        fixedSize: const Size(double.infinity, 60),
        elevation: 0,
        surfaceTintColor: CustomColor.backgroundPrimary,
      ),
    );
  }
}

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({super.key});

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  final _currencyList = [
    "€",
    "\$",
    "£",
    "¥",
  ]; // List of currency Symbols
  String? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      // conatiner decoration
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          color: CustomColor.grey,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: DropdownButton<String>(
          // DropdownButton
          items: _currencyList.map(buildMenuItem).toList(),
          onChanged: (value) => setState(() {
            this.value = value;
          }),
          value: value,
          elevation: 0,
          style: CustomTextStyle.regularStyleMedium,
          dropdownColor: CustomColor.white,
          iconSize: 0.0,
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: CustomTextStyle.titleStyleMedium,
        ),
      );
}

class AccAdjustmentWidget extends StatefulWidget {
  final String icon;
  final String name;
  final Widget? widget;
  const AccAdjustmentWidget(
      {super.key, required this.icon, required this.name, this.widget});

  @override
  State<AccAdjustmentWidget> createState() => _AccAdjustmentWidgetState();
}

class _AccAdjustmentWidgetState extends State<AccAdjustmentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      padding: EdgeInsets.only(
          left: CustomPadding.defaultSpace, right: CustomPadding.defaultSpace),
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
              SizedBox(
                width: 8,
              ),
              Text(
                widget.name,
                style: CustomTextStyle.regularStyleDefault,
              ),
            ],
          ),
          widget.widget ?? Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}

class CustomSegmentControl extends StatefulWidget {
  const CustomSegmentControl({super.key});

  @override
  State<CustomSegmentControl> createState() => _CustomSegmentControlState();
}

class _CustomSegmentControlState extends State<CustomSegmentControl> {
  int? _sliding = 0;

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
  child: Container(
    width: double.infinity,
    child: CupertinoSlidingSegmentedControl(
      children: {
        0: Container(
          height: MediaQuery.sizeOf(context).height * Constants.segmentedControlHeight,
          alignment: Alignment.center,
          child: Text(
            AppString.expense, 
            style: _sliding == 0 ? CustomTextStyle.slidingStyleExpense : CustomTextStyle.slidingStyleDefault
          ),
        ),
        1: Container(
          height: MediaQuery.sizeOf(context).height * Constants.segmentedControlHeight,
          alignment: Alignment.center,
          child: Text(
            AppString.income, 
            style: _sliding == 1 ? CustomTextStyle.slidingStyleIncome : CustomTextStyle.slidingStyleDefault
          ),
        ),
      },
      groupValue: _sliding,
      onValueChanged: (int? newValue){
        setState(() {
          _sliding = newValue;
        });
      },
      backgroundColor: CustomColor.white,
    ),
  ),
);
  }
}