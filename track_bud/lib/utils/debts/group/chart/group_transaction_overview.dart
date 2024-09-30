import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/group/chart/category_bar.dart';
import 'package:track_bud/utils/debts/group/chart/category_expense_info.dart';
import 'package:track_bud/utils/enum/categories.dart';
import 'package:track_bud/utils/shadow.dart';

/// Widget that displays an overview of transactions categorized by expense type
class TransactionOverview extends StatelessWidget {
  // Map of categories to their corresponding amounts
  final Map<Categories, double?> categoryAmounts;
  final bool isOverview;

  const TransactionOverview({super.key, required this.categoryAmounts, this.isOverview = false});

  // Build the category bar chart, source: ClaudeAI
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
  Widget buildCategoryList(ColorScheme defaultColorScheme) {
    // Filter out categories with null or zero values, sort by amount in descending order, source: ClaudeAI
    List<MapEntry<Categories, double>> validCategories = categoryAmounts.entries
        .where((e) => e.value != null && e.value! > 0)
        .map((e) => MapEntry(e.key, e.value!)) // Cast to double instead of double?
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Determine if we need two columns based on the number of categories
    bool useTwoColumns = validCategories.length > 5;

    return useTwoColumns ? buildTwoColumnList(validCategories, defaultColorScheme) : buildSingleColumnList(validCategories);
  }

  // Build the category list with a left-to-right sorting
  Widget buildTwoColumnList(List<MapEntry<Categories, double>> validCategories, ColorScheme defaultColorScheme) {
    // Initialize the left and right columns (help from ChatGPT to sort them from left to right)
    List<MapEntry<Categories, double>> leftColumn = [];
    List<MapEntry<Categories, double>> rightColumn = [];

    // Distribute categories left to right (alternating between the columns)
    for (int i = 0; i < validCategories.length; i++) {
      if (i % 2 == 0) {
        leftColumn.add(validCategories[i]); // Even index -> Left column
      } else {
        rightColumn.add(validCategories[i]); // Odd index -> Right column
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: buildCategoryColumn(leftColumn)),
        VerticalDivider(thickness: 3, color: defaultColorScheme.outline),
        Expanded(child: buildCategoryColumn(rightColumn))
      ],
    );
  }

  // Build a single column of categories
  Widget buildCategoryColumn(List<MapEntry<Categories, double>> categories) {
    return Column(
      children: categories
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

  // Build the category list in a single column
  Widget buildSingleColumnList(List<MapEntry<Categories, double>> validCategories) {
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

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    // Render the category bar differently based on the isOverview flag
    return isOverview
        ? buildCategoryBar(height: 7.0)
        : CustomShadow(
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              padding: const EdgeInsets.all(CustomPadding.defaultSpace),
              decoration:
                  BoxDecoration(color: defaultColorScheme.surface, borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
              child: Column(
                children: [buildCategoryBar(), const Gap(CustomPadding.bigSpace), buildCategoryList(defaultColorScheme)],
              ),
            ),
          );
  }
}
