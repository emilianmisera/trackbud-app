import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:track_bud/models/friend_split_model.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/categories/category_icon.dart';
import 'package:track_bud/utils/enum/categories.dart';
import 'package:track_bud/utils/shadow.dart';

/// This Widgets shows the info about splits between you and your friend
/// in FreindProfileScreen
class FriendSplitTile extends StatelessWidget {
  final FriendSplitModel split;
  final String currentUserId;
  final String friendName;

  const FriendSplitTile({super.key, required this.split, required this.currentUserId, required this.friendName});

  @override
  Widget build(BuildContext context) {
    bool isCreditor = split.creditorId == currentUserId;
    bool isPaid = split.status == 'paid';

    // Top amount always shows the total spent (creditor amount)
    String topAmount =
        split.type == 'expense' ? '-${split.creditorAmount.toStringAsFixed(2)}€' : '+${split.creditorAmount.toStringAsFixed(2)}';

    // Bottom amount always shows the amount owed
    String bottomAmount = '${split.debtorAmount.toStringAsFixed(2)}€';

    // Color is green if you're the creditor (getting money back), red if you're the debtor (owing money)
    Color amountColor = isCreditor ? Colors.green : Colors.red;

    // Get the category icon and color (default to "sonstiges" if category is not found)
    final categoryData = Categories.values
        .firstWhere((category) => category.categoryName.toLowerCase() == split.category.toLowerCase(), orElse: () => Categories.sonstiges);
    final defaultColorScheme = Theme.of(context).colorScheme;

    return CustomShadow(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(CustomPadding.defaultSpace),
        decoration: BoxDecoration(color: defaultColorScheme.surface, borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Constants.roundedCorners), color: categoryData.color.withOpacity(0.2)),
                  padding: const EdgeInsets.only(right: CustomPadding.defaultSpace),
                  child: Row(
                    children: [
                      CategoryIcon(color: categoryData.color, iconWidget: categoryData.icon),
                      const Gap(CustomPadding.smallSpace),
                      Text(isCreditor ? 'Du' : friendName,
                          style: TextStyles.regularStyleDefault
                              .copyWith(fontSize: TextStyles.fontSizeHint, color: defaultColorScheme.primary)),
                    ],
                  ),
                ),
                // Top amount (total spent) in black
                Text(topAmount, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
              ],
            ),
            const Gap(CustomPadding.defaultSpace),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(split.title, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
                // Bottom amount (owed amount) with color based on creditor/debtor status
                Text(bottomAmount,
                    style: TextStyles.regularStyleDefault.copyWith(
                        color: amountColor,
                        decoration: isPaid ? TextDecoration.lineThrough : null,
                        decorationColor: defaultColorScheme.primary)),
              ],
            ),
            Divider(color: defaultColorScheme.outline),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Datum',
                    style: TextStyles.hintStyleDefault.copyWith(fontSize: TextStyles.fontSizeHint, color: defaultColorScheme.secondary)),
                Text(DateFormat('dd.MM.yyyy, HH:mm').format(split.date.toDate()),
                    style: TextStyles.regularStyleDefault.copyWith(fontSize: TextStyles.fontSizeHint, color: defaultColorScheme.primary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
