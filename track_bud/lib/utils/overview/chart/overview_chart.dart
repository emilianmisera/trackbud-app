import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/provider/user_provider.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/group/chart/group_debts_chart.dart';
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
  int _currentTimeUnit = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final transactionProvider = context.read<TransactionProvider>();
      final userProvider = context.read<UserProvider>();
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
        return 'Diese Woche';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        if (transactionProvider.shouldReloadChart) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            transactionProvider
                .calculateTotalExpenseForTimeUnit(_currentTimeUnit);
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
              borderRadius:
                  BorderRadius.circular(Constants.contentBorderRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectTimeUnit(
                  onValueChanged: (int? newValue) {
                    setState(() {
                      _currentTimeUnit = newValue ?? 1;
                    });
                    context
                        .read<TransactionProvider>()
                        .calculateTotalExpenseForTimeUnit(_currentTimeUnit);
                  },
                ),
                const Gap(CustomPadding.defaultSpace),
                Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: defaultColorScheme.secondary,
                      size: 15,
                    ),
                    Text(
                      _getTimeUnitText(),
                      style: TextStyles.hintStyleDefault,
                    ),
                  ],
                ),
                Consumer<TransactionProvider>(
                  builder: (context, transactionProvider, child) {
                    return Text(
                      '${transactionProvider.totalExpenseForTimeUnit.toStringAsFixed(2)}€',
                      style: TextStyles.headingStyle
                          .copyWith(color: defaultColorScheme.primary),
                    );
                  },
                ),
                const Gap(CustomPadding.mediumSpace),
                /* TransactionOverview(
              isOverview: true,
              categoryAmounts: context.watch<TransactionProvider>().categoryAmounts,
            ),*/
                const Gap(CustomPadding.defaultSpace),
                Consumer<TransactionProvider>(
                    builder: (context, transactionProvider, child) {
                  return ExpensesCharts(
                    currentTimeUnit: _currentTimeUnit,
                    expenses: transactionProvider.expensesForTimeUnit,
                    monthlyBudgetGoal:
                        userProvider.currentUser?.monthlySpendingGoal ?? 0.0,
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
