import 'package:flutter/material.dart';
import 'package:track_bud/utils/overview/chart/expenes%20chart/build_bar.dart';

//TODO: Remove
/// This Widget displays a WeekChart in OverviewScreen
class WeekChart extends StatelessWidget {
  final List<double> expenses;
  final double monthlyBudgetGoal;
  final List<String> days = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];

  WeekChart({
    super.key,
    required this.expenses,
    required this.monthlyBudgetGoal,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final defaultColorScheme = Theme.of(context).colorScheme;

    // 1. Calculate weekly expenses
    int startIndex = expenses.length > 7 ? expenses.length - 7 : 0;
    List<double> weekExpenses = expenses.sublist(startIndex);
    while (weekExpenses.length < 7) {
      weekExpenses.insert(0, 0.0);
    }

    // 2. Calculate cumulative expenses for the WEEK
    List<double> cumulativeWeekExpenses = [];
    double runningTotal = 0;
    for (int i = 0; i < 7; i++) {
      runningTotal += weekExpenses[i];
      cumulativeWeekExpenses.add(runningTotal);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        double cumulativeExpense = cumulativeWeekExpenses[index];
        double fillPercentage = (cumulativeExpense / monthlyBudgetGoal).clamp(0.0, 1.0);
        bool isOverBudget = cumulativeExpense > monthlyBudgetGoal;
        bool isCurrentDay = index == 6;

        return BuildBar(
          label: days[(now.weekday - 7 + index) % 7],
          fillPercentage: fillPercentage,
          isOverBudget: isOverBudget,
          isCurrentDay: isCurrentDay,
          defaultColorScheme: defaultColorScheme,
        );
      }),
    );
  }
}
