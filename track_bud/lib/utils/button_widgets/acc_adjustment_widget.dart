import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';

class AccAdjustmentWidget extends StatefulWidget {
  final String icon;
  final String name;
  final Widget? widget;
  final Color? color;
  const AccAdjustmentWidget({super.key, required this.icon, required this.name, this.widget, this.color});

  @override
  State<AccAdjustmentWidget> createState() => _AccAdjustmentWidgetState();
}

class _AccAdjustmentWidgetState extends State<AccAdjustmentWidget> {
  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      height: Constants.height,
      padding: const EdgeInsets.only(left: CustomPadding.defaultSpace, right: CustomPadding.defaultSpace),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        color: widget.color ?? defaultColorScheme.surface,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                widget.icon,
                colorFilter: ColorFilter.mode(defaultColorScheme.primary, BlendMode.srcIn),
              ),
              const Gap(
                8,
              ),
              Text(widget.name, style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
            ],
          ),
          widget.widget ?? const Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}
