import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/textfield_widgets.dart';

// Widget for a single split button
class SplitButton extends StatefulWidget {
  // The icon to display on the button
  final String icon;
  // The text to display on the button
  final String text;
  // Function to call when the button is pressed
  final void Function() onPressed;
  // Whether this button is currently selected
  final bool isSelected;

  const SplitButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  State<SplitButton> createState() => _SplitButtonState();
}

class _SplitButtonState extends State<SplitButton> {
  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: ElevatedButton(
        onPressed: widget.onPressed,
        child: Column(
          children: [
            // Display the icon
            SvgPicture.asset(widget.icon,
                colorFilter: ColorFilter.mode(widget.isSelected ? CustomColor.bluePrimary : CustomColor.hintColor, BlendMode.srcIn)),
            Gap(CustomPadding.smallSpace),
            // Display the text
            Text(widget.text,
                style: TextStyles.hintStyleDefault.copyWith(color: widget.isSelected ? CustomColor.bluePrimary : CustomColor.hintColor)),
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColor.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Constants.contentBorderRadius))),
          minimumSize: Size(25, 10),
          padding: EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace, vertical: CustomPadding.contentHeightSpace),
          elevation: 0,
        ),
      ),
    );
  }
}
