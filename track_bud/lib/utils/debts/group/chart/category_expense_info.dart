import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/categories/category_icon.dart';
import 'package:track_bud/utils/constants.dart';

// Widget that displays expense information for a single category
class CategoryInfo extends StatelessWidget {
  final String categoryName;
  final Image icon;
  final Color iconColor;
  final double? amount;

  const CategoryInfo({super.key, required this.categoryName, required this.icon, required this.iconColor, required this.amount});

  // Formats the amount as a string with two decimal places
  String _formatAmount(double? value) {
    if (value == null) return '0.00€';
    return '${value.toStringAsFixed(2)}€';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CategoryIcon(color: iconColor, iconWidget: icon),
        Gap(CustomPadding.mediumSpace),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(categoryName, style: TextStyles.regularStyleMedium),
            Text(_formatAmount(amount), style: TextStyles.hintStyleDefault),
          ],
        )
      ],
    );
  }
}