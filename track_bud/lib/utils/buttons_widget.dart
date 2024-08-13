import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:track_bud/utils/constants.dart';

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
