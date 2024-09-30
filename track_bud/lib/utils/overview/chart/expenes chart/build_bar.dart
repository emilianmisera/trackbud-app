import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';

class BuildBar extends StatelessWidget {
  final String label;
  final double fillPercentage;
  final bool isOverBudget;
  final ColorScheme defaultColorScheme;
  final bool isCurrentDay;
  final bool isCurrentMonth;
  final double width;

  const BuildBar({
    super.key,
    required this.label,
    required this.fillPercentage,
    required this.isOverBudget,
    required this.defaultColorScheme,
    this.isCurrentDay = false,
    this.isCurrentMonth = false,
    this.width = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 75,
          width: width,
          decoration: BoxDecoration(
            color: defaultColorScheme.outline,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: width,
              height: 75 * fillPercentage,
              decoration: BoxDecoration(
                color: isOverBudget ? CustomColor.darkRed : CustomColor.bluePrimary,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
        const Gap(CustomPadding.smallSpace),
        Text(
          label,
          style: TextStyles.hintStyleDefault.copyWith(
            fontSize: 12,
            color: (isCurrentDay || isCurrentMonth) ? defaultColorScheme.surfaceTint : null,
          ),
        ),
        if (isCurrentDay || isCurrentMonth)
          Container(
            height: 4,
            width: 4,
            decoration: BoxDecoration(
              color: defaultColorScheme.surfaceTint,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}
