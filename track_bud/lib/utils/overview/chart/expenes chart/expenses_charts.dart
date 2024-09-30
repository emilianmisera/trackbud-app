import 'package:flutter/material.dart';
import 'package:track_bud/utils/overview/chart/expenes%20chart/month_chart.dart';
import 'package:track_bud/utils/overview/chart/expenes%20chart/year_chart.dart';

class ExpensesCharts extends StatelessWidget {
  final int currentTimeUnit;
  final List<double> expenses;
  final double monthlyBudgetGoal;

  const ExpensesCharts({
    super.key,
    required this.currentTimeUnit,
    required this.expenses,
    required this.monthlyBudgetGoal,
  });

  @override
  Widget build(BuildContext context) {
    switch (currentTimeUnit) {
      case 0:
        return const SizedBox(); // Day view, show nothing
      /*
      case 1:
        return WeekChart(expenses: expenses, monthlyBudgetGoal: monthlyBudgetGoal);
      */
      case 1:
        return MonthChart(expenses: expenses, monthlyBudgetGoal: monthlyBudgetGoal);
      case 2:
        return YearChart(expenses: expenses, monthlyBudgetGoal: monthlyBudgetGoal);
      default:
        return const SizedBox();
    }
  }
}
