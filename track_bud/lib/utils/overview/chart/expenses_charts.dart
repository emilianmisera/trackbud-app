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
  final List<String> days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  WeekChart({
    super.key,
    required this.expenses,
    required this.monthlyBudgetGoal,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final defaultColorScheme = Theme.of(context).colorScheme;

    // Calculate the last 7 days, including today
    List<DateTime> lastSevenDays =
        List.generate(7, (index) => now.subtract(Duration(days: 6 - index)));

    // Calculate the cumulative expenses for the last 7 days
    List<double> weekExpenses = List.filled(7, 0.0);
    double runningTotal = 0;
    for (int i = 0; i < 7; i++) {
      final day = lastSevenDays[i];
      int expenseIndex = day.day - 1; // day.day starts from 1, so subtract 1
      if (expenseIndex < expenses.length) {
        runningTotal += expenses[expenseIndex];
      }
      weekExpenses[i] = runningTotal; // Cumulative total
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        double cumulativeExpense = weekExpenses[index];
        double fillPercentage =
            (cumulativeExpense / monthlyBudgetGoal).clamp(0.0, 1.0);
        bool isOverBudget = cumulativeExpense > monthlyBudgetGoal;
        bool isCurrentDay =
            index == 6; // The last day (rightmost) is always today

        return _buildBar(
          label: days[index],
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

  MonthChart({
    super.key,
    required this.expenses,
    required this.monthlyBudgetGoal,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final defaultColorScheme = Theme.of(context).colorScheme;
    int currentDay = now.day;

    // Calculate cumulative expenses
    List<double> cumulativeExpenses = [];
    double runningTotal = 0;
    for (int i = 0; i < currentDay && i < expenses.length; i++) {
      runningTotal += expenses[i];
      cumulativeExpenses.add(runningTotal);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(daysInMonth, (index) {
        double cumulativeExpense =
            index < cumulativeExpenses.length ? cumulativeExpenses[index] : 0;
        double fillPercentage =
            (cumulativeExpense / monthlyBudgetGoal).clamp(0.0, 1.0);
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
              color: isOverBudget ? CustomColor.red : CustomColor.bluePrimary,
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
          color:
              (isCurrentDay || isCurrentMonth) ? CustomColor.bluePrimary : null,
        ),
      ),
      if (isCurrentDay || isCurrentMonth)
        Container(
          height: 10,
          width: 8,
          decoration: const BoxDecoration(
            color: CustomColor.bluePrimary,
            shape: BoxShape.circle,
          ),
        ),
    ],
  );
}
