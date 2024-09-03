import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';

class MonthChart extends StatefulWidget {
  final List<double> expenses;
  const MonthChart({super.key, required this.expenses});

  @override
  State<MonthChart> createState() => _MonthChartState();
}

class _MonthChartState extends State<MonthChart> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  // Get the current day of the month (1-31)
  int get _currentDayOfMonth => DateTime.now().day - 1;
  int daysInMonth = 31;

  // Get expenses for a month
  List<double> _getMonthExpenses() {
    List<double> monthExpenses = List.filled(31, 0.0);
    // Fill with available expenses, leaving the rest as zeros
    for (int i = 0; i < widget.expenses.length && i < 31; i++) {
      monthExpenses[i] = widget.expenses[i];
    }
    return monthExpenses;
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Create height animation
    _heightAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final List<double> monthExpenses = _getMonthExpenses();
    double maxExpense = monthExpenses.reduce((a, b) => a > b ? a : b);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(daysInMonth, (index) {
          bool isCurrentDay = index == _currentDayOfMonth;
          return Column(
            children: [
              Container(
                height: 75,
                width: 8,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: CustomColor.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedBuilder(
                    animation: _heightAnimation,
                    builder: (context, child) {
                      return Container(
                        width: 8,
                        height: maxExpense > 0 ? (monthExpenses[index] / maxExpense) * 75 * _heightAnimation.value : 0,
                        decoration: BoxDecoration(
                          color: CustomColor.bluePrimary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const Gap(CustomPadding.smallSpace),
              // Blue circle indicator for current day
              if (isCurrentDay)
                Container(
                  height: 10,
                  width: 10,
                  decoration: const BoxDecoration(
                    color: CustomColor.bluePrimary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
