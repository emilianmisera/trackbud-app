import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/provider/user_provider.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/group/chart/category_bar.dart';
import 'package:track_bud/utils/enum/categories.dart';
import 'package:track_bud/utils/overview/chart/expenes%20chart/expenses_charts.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/tiles/time_unit_selection.dart';
import 'package:track_bud/provider/transaction_provider.dart';

class ExpensesOverviewTile extends StatefulWidget {
  const ExpensesOverviewTile({super.key});

  @override
  State<ExpensesOverviewTile> createState() => _ExpensesOverviewTileState();
}

class _ExpensesOverviewTileState extends State<ExpensesOverviewTile> {
  int _currentTimeUnit = 1; // Default time unit set to "This Month"

  // A map of category names to their respective colors
  final categoryColors = {for (var category in Categories.values) category.categoryName: category.color};

  @override
  void initState() {
    super.initState();
    // After the first frame is rendered, calculate total expense for the current time unit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final transactionProvider = context.read<TransactionProvider>();
      transactionProvider.calculateTotalExpenseForTimeUnit(_currentTimeUnit);
    });
  }

  // Function to return the text representation of the current time unit
  String _getTimeUnitText() {
    switch (_currentTimeUnit) {
      case 0:
        return 'Heute'; // Today
      /*
      case 1:
        return 'Die letzten 7 Tage'; // Last 7 Days
      */
      case 1:
        return 'Dieser Monat'; // This Month
      case 2:
        return 'Dieses Jahr'; // This Year
      default:
        return 'Dieser Monat'; // Default to This Month
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        // Check if the chart should be reloaded and recalculate if necessary
        if (transactionProvider.shouldReloadChart) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            transactionProvider.calculateTotalExpenseForTimeUnit(_currentTimeUnit);
            transactionProvider.resetReloadFlag(); // Reset the reload flag after updating
          });
        }

        final userProvider = context.read<UserProvider>();
        final defaultColorScheme = Theme.of(context).colorScheme;

        return CustomShadow(
          child: Container(
            padding: const EdgeInsets.all(CustomPadding.defaultSpace),
            decoration: BoxDecoration(
              color: defaultColorScheme.surface, // Background color of the tile
              borderRadius: BorderRadius.circular(Constants.contentBorderRadius), // Rounded corners
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time unit selection widget
                SelectTimeUnit(
                  onValueChanged: (int? newValue) {
                    setState(() {
                      _currentTimeUnit = newValue ?? 2; // Update the current time unit
                    });
                    context.read<TransactionProvider>().calculateTotalExpenseForTimeUnit(_currentTimeUnit);
                  },
                ),
                const Gap(CustomPadding.defaultSpace), // Gap for spacing
                Text(_getTimeUnitText(), style: TextStyles.hintStyleDefault.copyWith(color: defaultColorScheme.secondary)),
                // Display total expense for the selected time unit
                Consumer<TransactionProvider>(
                  builder: (context, transactionProvider, child) {
                    return Text(
                        '${transactionProvider.totalExpenseForTimeUnit.toStringAsFixed(2)}€', // Total expense formatted to two decimal places
                        style: TextStyles.headingStyle.copyWith(color: defaultColorScheme.primary));
                  },
                ),
                const Gap(CustomPadding.mediumSpace), // Gap for spacing

                // Display category expenses in a bar chart format
                CategoryBar(
                  categoryExpenses: transactionProvider.categoryAmounts, // Pass category amounts
                  categoryColors: categoryColors, // Pass category colors
                  height: 8, // Set the height of the category bar
                ),
                const Gap(CustomPadding.defaultSpace), // Gap for spacing

                // Display detailed expenses charts
                Consumer<TransactionProvider>(
                  builder: (context, transactionProvider, child) {
                    return ExpensesCharts(
                      currentTimeUnit: _currentTimeUnit,
                      expenses: transactionProvider.expensesForTimeUnit, // Pass the expenses for the selected time unit
                      monthlyBudgetGoal: userProvider.currentUser?.monthlySpendingGoal ?? 0.0, // Pass the user's monthly spending goal
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
