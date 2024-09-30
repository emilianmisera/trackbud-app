import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';

/// Widget for a single split button
class SplitButton extends StatefulWidget {
  final String icon;
  final String text;
  final void Function() onPressed;
  final bool isSelected;

  const SplitButton({super.key, required this.icon, required this.text, required this.onPressed, required this.isSelected});

  @override
  State<SplitButton> createState() => _SplitButtonState();
}

class _SplitButtonState extends State<SplitButton> {
  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return CustomShadow(
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: defaultColorScheme.surface,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Constants.contentBorderRadius))),
          minimumSize: const Size(25, 10),
          padding: const EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace, vertical: CustomPadding.contentHeightSpace),
          elevation: 0,
        ),
        child: Column(
          children: [
            // Display the icon
            SvgPicture.asset(widget.icon,
                colorFilter: ColorFilter.mode(widget.isSelected ? CustomColor.bluePrimary : defaultColorScheme.secondary, BlendMode.srcIn)),
            const Gap(CustomPadding.smallSpace),
            // Display the text
            Text(widget.text,
                style: TextStyles.hintStyleDefault
                    .copyWith(color: widget.isSelected ? CustomColor.bluePrimary : defaultColorScheme.secondary)),
          ],
        ),
      ),
    );
  }
}
