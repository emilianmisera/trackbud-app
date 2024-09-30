import 'package:flutter/material.dart';
import 'package:track_bud/utils/overview/chart/expenes%20chart/build_bar.dart';

/// This Widget displays a MonthChart in OverviewScreen
class MonthChart extends StatelessWidget {
  final List<double> expenses;
  final double monthlyBudgetGoal;

  const MonthChart({super.key, required this.expenses, required this.monthlyBudgetGoal});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final defaultColorScheme = Theme.of(context).colorScheme;
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    int currentDay = now.day;

    // Calculate cumulative expenses with running total
    List<double> cumulativeExpenses = List.filled(daysInMonth, 0.0);
    double runningTotal = 0;
    for (int i = 0; i < daysInMonth; i++) {
      if (i < expenses.length) {
        runningTotal += expenses[i];
      }
      cumulativeExpenses[i] = runningTotal;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(daysInMonth, (index) {
        double cumulativeExpense = cumulativeExpenses[index];
        // Calculate fillPercentage only if the day is before or equal to today
        // Set to 0 for future days
        double fillPercentage = index < currentDay ? (cumulativeExpense / monthlyBudgetGoal).clamp(0.0, 1.0) : 0.0;
        bool isOverBudget = cumulativeExpense > monthlyBudgetGoal;
        bool isCurrentDay = index == currentDay - 1;

        return BuildBar(
          label: isCurrentDay ? '${index + 1}' : '',
          fillPercentage: fillPercentage,
          isOverBudget: isOverBudget,
          isCurrentDay: isCurrentDay,
          width: 8,
          defaultColorScheme: defaultColorScheme,
        );
      }),
    );
  }
}
