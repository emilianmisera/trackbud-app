import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';

// Widget for displaying amount and title information
class InfoTile extends StatelessWidget {
  final String title; // The title of the info tile
  final String amount; // The amount to be displayed
  final Color color; // The color of the amount text
  final double? width; // Optional width of the tile

  const InfoTile({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return CustomShadow(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: CustomPadding.defaultSpace,
          horizontal: CustomPadding.defaultSpace,
        ),
        width: width ?? MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          color: defaultColorScheme.surface,
          borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the amount
            Text('$amount€', style: TextStyles.headingStyle.copyWith(color: color)),
            const Gap(CustomPadding.mediumSpace),
            // Display the title
            Text(title, style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
          ],
        ),
      ),
    );
  }
}
