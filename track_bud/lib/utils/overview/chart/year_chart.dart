import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';

class YearChart extends StatefulWidget {
  final List<double> expenses;
  final double budgetGoal;

  const YearChart({required this.expenses, required this.budgetGoal, super.key});

  @override
  State<YearChart> createState() => _YearChartState();
}

class _YearChartState extends State<YearChart> with SingleTickerProviderStateMixin {
  final List<String> months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    // Create height animation
    _heightAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.reset();
    _animationController.forward();
  }

  // Get expenses for a year
  List<double> _getYearExpenses() {
    List<double> yearExpenses = List.filled(12, 0.0);
    int weeksInYear = 52;
    // Aggregate weekly expenses into monthly expenses
    for (int i = 0; i < 12; i++) {
      int startWeek = i * 4;
      int endWeek = (i + 1) * 4;
      if (endWeek > weeksInYear) endWeek = weeksInYear;
      for (int j = startWeek * 7; j < endWeek * 7 && j < widget.expenses.length; j++) {
        yearExpenses[i] += widget.expenses[j];
      }
    }
    return yearExpenses;
  }

  @override
  Widget build(BuildContext context) {
    final List<double> yearExpenses = _getYearExpenses();
    double maxExpense = yearExpenses.reduce((a, b) => a > b ? a : b);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        12,
        (index) {
          bool isCurrentMonth = index == DateTime.now().month - 1;
          return Column(
            children: [
              Container(
                height: 75,
                width: 20,
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
                        width: 20,
                        height: maxExpense > 0 ? (yearExpenses[index] / maxExpense) * 75 * _heightAnimation.value : 0,
                        decoration: BoxDecoration(
                          color: yearExpenses[index] > widget.budgetGoal ? CustomColor.red : CustomColor.bluePrimary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Gap(4),
              Text(
                months[index],
                style: TextStyles.hintStyleDefault.copyWith(
                  fontSize: 13,
                  color: isCurrentMonth ? CustomColor.bluePrimary : null,
                ),
              ),
              // Blue circle indicator for current month
              if (isCurrentMonth)
                Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(color: CustomColor.bluePrimary, shape: BoxShape.circle),
                ),
            ],
          );
        },
      ),
    );
  }
}
