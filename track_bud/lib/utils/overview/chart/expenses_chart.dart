import 'package:flutter/material.dart';
import 'package:track_bud/utils/overview/chart/month_chart.dart';
import 'package:track_bud/utils/overview/chart/week_chart.dart';
import 'package:track_bud/utils/overview/chart/year_chart.dart';

// Widget for displaying an animated chart of expenses
class ExpensesChart extends StatefulWidget {
  final int currentTimeUnit;
  final List<double> expenses;
  final double budgetGoal;

  const ExpensesChart({
    super.key,
    required this.currentTimeUnit,
    required this.expenses,
    this.budgetGoal = 400.00,
  });

  @override
  State<ExpensesChart> createState() => _ExpensesChartState();
}

class _ExpensesChartState extends State<ExpensesChart> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // Build appropriate chart based on current time unit
    switch (widget.currentTimeUnit) {
      case 0:
        return const SizedBox(); // Day view, show nothing
      case 1:
        return WeekChart(
          expenses: widget.expenses,
        );
      case 2:
        return MonthChart(
          expenses: widget.expenses,
        );
      case 3:
        return YearChart(
          expenses: widget.expenses,
          budgetGoal: widget.budgetGoal,
        );
      default:
        return const SizedBox();
    }
  }
}
