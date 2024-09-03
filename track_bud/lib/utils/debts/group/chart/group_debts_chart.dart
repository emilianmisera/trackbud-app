import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/group/chart/category_bar.dart';
import 'package:track_bud/utils/debts/group/chart/category_expense_info.dart';
import 'package:track_bud/utils/enum/categories.dart';
import 'package:track_bud/utils/textfield_widgets.dart';

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


