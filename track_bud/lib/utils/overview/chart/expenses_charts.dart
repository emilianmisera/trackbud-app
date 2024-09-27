import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';

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
      case 1:
        return WeekChart(
            expenses: expenses, monthlyBudgetGoal: monthlyBudgetGoal);
      case 2:
        return MonthChart(
            expenses: expenses, monthlyBudgetGoal: monthlyBudgetGoal);
      case 3:
        return YearChart(
            expenses: expenses, monthlyBudgetGoal: monthlyBudgetGoal);
      default:
        return const SizedBox();
    }
  }
}

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
        double fillPercentage =
            (cumulativeExpense / monthlyBudgetGoal).clamp(0.0, 1.0);
        bool isOverBudget = cumulativeExpense > monthlyBudgetGoal;
        bool isCurrentDay = index == 6;

        return _buildBar(
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

class MonthChart extends StatelessWidget {
  final List<double> expenses;
  final double monthlyBudgetGoal;

  const MonthChart({
    super.key,
    required this.expenses,
    required this.monthlyBudgetGoal,
  });

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
        double fillPercentage = index < currentDay
            ? (cumulativeExpense / monthlyBudgetGoal).clamp(0.0, 1.0)
            : 0.0; // Set to 0 for future days
        bool isOverBudget = cumulativeExpense > monthlyBudgetGoal;
        bool isCurrentDay = index == currentDay - 1;

        return _buildBar(
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

class YearChart extends StatelessWidget {
  final List<double> expenses;
  final double monthlyBudgetGoal;
  final List<String> months = [
    'J',
    'F',
    'M',
    'A',
    'M',
    'J',
    'J',
    'A',
    'S',
    'O',
    'N',
    'D'
  ];

  YearChart({
    super.key,
    required this.expenses,
    required this.monthlyBudgetGoal,
  });

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

        return _buildBar(
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

Widget _buildBar({
  required String label,
  required double fillPercentage,
  required bool isOverBudget,
  required ColorScheme defaultColorScheme,
  bool isCurrentDay = false,
  bool isCurrentMonth = false,
  double width = 30,
}) {
  return Column(
    children: [
      Container(
        height: 75,
        width: width,
        decoration: BoxDecoration(
          color: defaultColorScheme.outline,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: width,
            height: 75 * fillPercentage,
            decoration: BoxDecoration(
              color:
                  isOverBudget ? CustomColor.darkRed : CustomColor.bluePrimary,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
      const Gap(CustomPadding.smallSpace),
      Text(
        label,
        style: TextStyles.hintStyleDefault.copyWith(
          fontSize: 12,
          color: (isCurrentDay || isCurrentMonth)
              ? defaultColorScheme.surfaceTint
              : null,
        ),
      ),
      if (isCurrentDay || isCurrentMonth)
        Container(
          height: 4,
          width: 4,
          decoration: BoxDecoration(
            color: defaultColorScheme.surfaceTint,
            shape: BoxShape.circle,
          ),
        ),
    ],
  );
}
