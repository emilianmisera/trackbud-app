import 'package:flutter/material.dart';
import 'package:track_bud/utils/overview/chart/expenes%20chart/build_bar.dart';

/// This Widget displays a YearChart in OverviewScreen
class YearChart extends StatelessWidget {
  final List<double> expenses;
  final double monthlyBudgetGoal;
  final List<String> months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];

  YearChart({super.key, required this.expenses, required this.monthlyBudgetGoal});

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(12, (index) {
        double expense = index < expenses.length ? expenses[index] : 0;
        double fillPercentage = (expense / monthlyBudgetGoal).clamp(0.0, 1.0);
        bool isOverBudget = expense > monthlyBudgetGoal;
        bool isCurrentMonth = index == DateTime.now().month - 1;

        return BuildBar(
          label: months[index],
          fillPercentage: fillPercentage,
          isOverBudget: isOverBudget,
          isCurrentMonth: isCurrentMonth,
          defaultColorScheme: defaultColorScheme,
          width: 20,
        );
      }),
    );
  }
}
