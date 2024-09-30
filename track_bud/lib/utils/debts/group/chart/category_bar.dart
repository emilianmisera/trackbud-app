import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';

/// This Widget displays a Bar of used Categories
/// used in OverviewScreen and GroupTransactionOverview
class CategoryBar extends StatelessWidget {
  final Map<String, double> categoryExpenses; // Map of category names to their respective expense values
  final Map<String, Color> categoryColors; // Map of category names to their respective colors
  final double? height; // Optional height for the category bar

  const CategoryBar({super.key, required this.categoryExpenses, required this.categoryColors, this.height});

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;

    // Calculate the total expense by summing all category expenses
    double totalExpense = categoryExpenses.values.fold(0, (sum, expense) => sum + expense);

    // Create a sorted list of expenses in descending order, source: ClaudeAI
    List<MapEntry<String, double>> sortedExpenses = categoryExpenses.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    // If there are no expenses, return an empty bar
    if (totalExpense == 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(Constants.roundedCorners),
        child: Container(height: 8, color: defaultColorScheme.outline),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(Constants.roundedCorners),
      child: SizedBox(
        height: height ?? 20,
        child: Row(
          children: sortedExpenses.asMap().entries.map((entry) {
            int index = entry.key; // Get the index of the current entry
            MapEntry<String, double> categoryEntry = entry.value; // Extract category entry
            String category = categoryEntry.key; // Category name
            double expense = categoryEntry.value; // Expense value for the category
            double percentage = expense / totalExpense; // Calculate percentage of total expense

            return Expanded(
              flex: (percentage * 100).round(), // Set flex based on percentage
              child: Container(
                margin: EdgeInsets.only(
                  left: index == 0 ? 0 : .3, // No left margin for the first item, source: ClaudeAI
                  right: index == sortedExpenses.length - 1 ? 0 : .3, // No right margin for the last item, source ClaudeAI
                ),
                child: Container(color: categoryColors[category] ?? defaultColorScheme.outline),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
