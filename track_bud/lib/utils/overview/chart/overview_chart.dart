import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/provider/user_provider.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/group/chart/category_bar.dart';
import 'package:track_bud/utils/enum/categories.dart';
import 'package:track_bud/utils/overview/chart/expenses_charts.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/tiles/time_unit_selection.dart';
import 'package:track_bud/provider/transaction_provider.dart';

class ExpensesOverviewTile extends StatefulWidget {
  const ExpensesOverviewTile({super.key});

  @override
  State<ExpensesOverviewTile> createState() => _ExpensesOverviewTileState();
}

class _ExpensesOverviewTileState extends State<ExpensesOverviewTile> {
  int _currentTimeUnit = 2;
  final categoryColors = {
    for (var category in Categories.values) category.categoryName: category.color,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final transactionProvider = context.read<TransactionProvider>();
      transactionProvider.calculateTotalExpenseForTimeUnit(_currentTimeUnit);
    });
  }

  String _getTimeUnitText() {
    switch (_currentTimeUnit) {
      case 0:
        return 'Heute';
      case 1:
        return 'Die letzten 7 Tage';
      case 2:
        return 'Dieser Monat';
      case 3:
        return 'Dieses Jahr';
      default:
        return 'Dieser Monat';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        if (transactionProvider.shouldReloadChart) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            transactionProvider.calculateTotalExpenseForTimeUnit(_currentTimeUnit);
            transactionProvider.resetReloadFlag();
          });
        }
        final userProvider = context.read<UserProvider>();
        final defaultColorScheme = Theme.of(context).colorScheme;
        return CustomShadow(
          child: Container(
            padding: const EdgeInsets.all(CustomPadding.defaultSpace),
            decoration: BoxDecoration(
              color: defaultColorScheme.surface,
              borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectTimeUnit(
                  onValueChanged: (int? newValue) {
                    setState(() {
                      _currentTimeUnit = newValue ?? 2;
                    });
                    context.read<TransactionProvider>().calculateTotalExpenseForTimeUnit(_currentTimeUnit);
                  },
                ),
                const Gap(CustomPadding.defaultSpace),
                Text(_getTimeUnitText(), style: TextStyles.hintStyleDefault.copyWith(color: defaultColorScheme.secondary)),
                Consumer<TransactionProvider>(
                  builder: (context, transactionProvider, child) {
                    return Text(
                      '${transactionProvider.totalExpenseForTimeUnit.toStringAsFixed(2)}€',
                      style: TextStyles.headingStyle.copyWith(color: defaultColorScheme.primary),
                    );
                  },
                ),
                const Gap(CustomPadding.mediumSpace),
                // Pass the categoryAmounts to the CategoryBar
                CategoryBar(
                  categoryExpenses: transactionProvider.categoryAmounts,
                  categoryColors: categoryColors,
                  height: 8,
                ),
                const Gap(CustomPadding.defaultSpace),
                Consumer<TransactionProvider>(builder: (context, transactionProvider, child) {
                  return ExpensesCharts(
                    currentTimeUnit: _currentTimeUnit,
                    expenses: transactionProvider.expensesForTimeUnit,
                    monthlyBudgetGoal: userProvider.currentUser?.monthlySpendingGoal ?? 0.0,
                  );
                })
              ],
            ),
          ),
        );
      },
    );
  }
}
