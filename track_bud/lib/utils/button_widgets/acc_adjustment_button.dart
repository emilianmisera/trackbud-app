// ignore: unused_import
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:track_bud/utils/constants.dart';

class AccAdjustmentButton extends StatelessWidget {
  final String icon;
  final String name;
  final void Function() onPressed;
  final EdgeInsets? padding;
  final Widget? widget;
  const AccAdjustmentButton({super.key, required this.icon, required this.name, required this.onPressed, this.widget, this.padding});

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return ElevatedButton.icon(
      icon: SvgPicture.asset(
        icon,
        colorFilter: ColorFilter.mode(defaultColorScheme.primary, BlendMode.srcIn),
      ),
      label: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
          const Icon(Icons.arrow_forward_ios_rounded),
        ],
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: defaultColorScheme.onSurface,
          foregroundColor: defaultColorScheme.primary,
          fixedSize: const Size(double.infinity, Constants.height),
          elevation: 0,
          surfaceTintColor: defaultColorScheme.surface,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace)),
    );
  }
}
