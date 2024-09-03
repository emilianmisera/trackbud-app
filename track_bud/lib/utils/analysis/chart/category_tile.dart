import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/categories/category_icon.dart';
import 'package:track_bud/utils/constants.dart';

// Widget that displays information about each category in the chart
class CategoryTile extends StatelessWidget {
  final Color color;
  final String title;
  final double amount;
  final double totalAmount;
  final Image icon;
  final VoidCallback onTap;
  final int transactionCount;

  const CategoryTile({
    super.key,
    required this.color,
    required this.title,
    required this.amount,
    required this.icon,
    required this.onTap,
    required this.totalAmount,
    required this.transactionCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(CustomPadding.defaultSpace),
        decoration: BoxDecoration(color: CustomColor.white, borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
        child: Row(
          children: [
            CategoryIcon(color: color, iconWidget: icon),
            const Gap(CustomPadding.mediumSpace),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyles.regularStyleMedium),
                  Text(
                    '${((amount / totalAmount) * 100).toStringAsFixed(2)}%',
                    style: TextStyles.hintStyleDefault.copyWith(fontSize: TextStyles.fontSizeHint),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${amount.toStringAsFixed(2)}€', style: TextStyles.regularStyleMedium),
                const Gap(CustomPadding.mediumSpace),
                Text(
                  '$transactionCount Transaktionen',
                  style: TextStyles.hintStyleDefault.copyWith(fontSize: TextStyles.fontSizeHint),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
