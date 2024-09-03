//https://stackoverflow.com/a/63360734
//https://stackoverflow.com/a/53549197

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/button_widgets/buttons_widget.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/enum/categories.dart';
import 'package:track_bud/utils/textfield_widgets.dart';

class CategoryBar extends StatelessWidget {
  final Map<String, double> categoryExpenses;
  final Map<String, Color> categoryColors;
  final double? height;

  const CategoryBar({
    Key? key,
    required this.categoryExpenses,
    required this.categoryColors,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the total expense by summing up all category expenses
    // fold() to iterate through all values and sum them up
    double totalExpense = categoryExpenses.values.fold(0, (sum, expense) => sum + expense);

    // Sort the expenses in descending order
    // convert the map entries to a list to sort
    List<MapEntry<String, double>> sortedExpenses = categoryExpenses.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    if (totalExpense == 0) {
      // If there are no expenses, return an empty grey container
      return ClipRRect(
        borderRadius: BorderRadius.circular(5), // apply rounded corners, as borderRadius doesn't work directly on Container
        child: Container(
          height: 20,
          color: CustomColor.grey,
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        height: height ?? 20,
        child: Row(
          children: sortedExpenses.map((entry) {
            String category = entry.key;
            double expense = entry.value;
            // Calculate the percentage of this category's expense for width of bar
            double percentage = expense / totalExpense;
            return Expanded(
              // width of bar will be proportional to percentage
              flex: (percentage * 100).round(),
              child: Container(
                // if color not found, grey is used instead
                color: categoryColors[category] ?? CustomColor.grey,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// Widget that displays an overview of transactions categorized by expense type
class TransactionOverview extends StatelessWidget {
  // Map of categories to their corresponding amounts
  final Map<Categories, double?> categoryAmounts;
  final bool isOverview;

  const TransactionOverview({
    super.key,
    required this.categoryAmounts,
    this.isOverview = false,
  });

  @override
  Widget build(BuildContext context) {
    // Render the category bar differently based on the isOverview flag
    return isOverview
        ? buildCategoryBar(height: 7.0)
        : CustomShadow(
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              padding: EdgeInsets.all(CustomPadding.defaultSpace),
              decoration: BoxDecoration(
                color: CustomColor.white,
                borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
              ),
              child: Column(
                children: [
                  buildCategoryBar(),
                  Gap(CustomPadding.bigSpace),
                  buildCategoryList(),
                ],
              ),
            ),
          );
  }

  // Build the category bar chart
  Widget buildCategoryBar({double height = 20.0}) {
    return CategoryBar(
      // Map category names to their corresponding amounts
      categoryExpenses: Map.fromEntries(categoryAmounts.entries.map((e) => MapEntry(e.key.categoryName, e.value ?? 0.0))),
      // Map category names to their corresponding colors
      categoryColors: categoryAmounts.entries.fold<Map<String, Color>>(
        {},
        (acc, entry) => {
          ...acc,
          entry.key.categoryName: entry.key.color,
        },
      ),
      height: height,
    );
  }

  // Build the list of category information widgets
  Widget buildCategoryList() {
    // Filter out categories with null or zero values, sort by amount in descending order
    List<MapEntry<Categories, double>> validCategories = categoryAmounts.entries
        .where((e) => e.value != null && e.value! > 0)
        .map((e) => MapEntry(e.key, e.value!)) // Cast to double instead of double?
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: validCategories
          .map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: CustomPadding.mediumSpace),
                child: CategoryInfo(
                  categoryName: entry.key.categoryName,
                  icon: entry.key.icon,
                  iconColor: entry.key.color,
                  amount: entry.value,
                ),
              ))
          .toList(),
    );
  }
}

// Widget that displays information for a single category
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
        Gap(
          CustomPadding.mediumSpace,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              categoryName,
              style: TextStyles.regularStyleMedium,
            ),
            Text(
              _formatAmount(amount),
              style: TextStyles.hintStyleDefault,
            ),
          ],
        )
      ],
    );
  }
}
